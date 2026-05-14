import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:fogosmobile/models/ipma_wind_grid.dart';

/// Snapshot of the Mapbox camera at one instant, in the form the overlay needs
/// to render. Kept tiny so we can pump it through a ValueNotifier per frame.
@immutable
class WindCameraSnapshot {
  final double centerLng;
  final double centerLat;
  final double zoom;
  final DateTime updatedAt;

  const WindCameraSnapshot({
    required this.centerLng,
    required this.centerLat,
    required this.zoom,
    required this.updatedAt,
  });
}

/// Floating particle-flow overlay above the Mapbox `MapWidget`.
///
/// Performance design (see plan §B):
/// - All projection runs in Dart (no platform-channel `pixelForCoordinate`).
/// - Wrapped in a `RepaintBoundary` so the map widget tree doesn't repaint.
/// - Drops to 30 fps automatically when frame budget is missed.
/// - Pauses entirely when the toggle is off / app backgrounded / outside the
///   AROME grid's longitude range.
class AnimatedWindOverlay extends StatefulWidget {
  final IpmaWindGrid grid;
  final ValueListenable<WindCameraSnapshot?> camera;

  const AnimatedWindOverlay({
    Key? key,
    required this.grid,
    required this.camera,
  }) : super(key: key);

  @override
  State<AnimatedWindOverlay> createState() => _AnimatedWindOverlayState();
}

class _AnimatedWindOverlayState extends State<AnimatedWindOverlay>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  static const int _initialParticleCount = 600;
  static const int _minParticleCount = 200;
  static const int _trailLen = 6; // last N positions per particle
  static const int _maxAge = 90;
  static const double _stepScale = 0.00040; // tuned for ~10 m/s wind crossings
  static const double _minZoom = 4.5;
  static const double _maxZoom = 13.0;

  late final Ticker _ticker;
  final ValueNotifier<int> _frame = ValueNotifier(0);
  final math.Random _rng = math.Random(42);

  // Particle state stored flat for cache locality.
  // Layout per particle (i): index 0 = age (frames),
  //   then 6 pairs of (lng, lat) for current + 5 historic positions.
  // So stride = 1 + 2 * _trailLen = 13.
  static const int _stride = 1 + 2 * _trailLen;
  late Float32List _state;
  int _count = _initialParticleCount;

  // Adaptive perf throttle.
  int _slowFrames = 0;
  Duration _lastFrameStamp = Duration.zero;
  bool _half = false; // if true, only step every other frame
  bool _paused = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _state = Float32List(_count * _stride);
    _spawnAll();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void didUpdateWidget(AnimatedWindOverlay old) {
    super.didUpdateWidget(old);
    if (old.grid != widget.grid) {
      _spawnAll();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState s) {
    final shouldPause = s != AppLifecycleState.resumed;
    if (shouldPause == _paused) return;
    _paused = shouldPause;
    if (_paused) {
      _ticker.stop();
    } else {
      _ticker.start();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker.dispose();
    _frame.dispose();
    super.dispose();
  }

  void _spawnAll() {
    for (var i = 0; i < _count; i++) _respawn(i);
  }

  void _respawn(int i) {
    final off = i * _stride;
    _state[off] = (_rng.nextDouble() * _maxAge).floorToDouble();
    final lng = widget.grid.lo1 +
        _rng.nextDouble() * (widget.grid.lo2 - widget.grid.lo1);
    final lat = widget.grid.la2 +
        _rng.nextDouble() * (widget.grid.la1 - widget.grid.la2);
    for (var k = 0; k < _trailLen; k++) {
      _state[off + 1 + 2 * k] = lng;
      _state[off + 2 + 2 * k] = lat;
    }
  }

  /// Bilinear u/v sample. Returns NaN if outside grid.
  (double, double) _sampleUV(double lng, double lat) {
    final g = widget.grid;
    final fx = (lng - g.lo1) / g.dx;
    final fy = (g.la1 - lat) / g.dy; // la1 is the north edge
    if (fx < 0 || fx >= g.nx - 1 || fy < 0 || fy >= g.ny - 1) {
      return (double.nan, double.nan);
    }
    final ix = fx.floor();
    final iy = fy.floor();
    final tx = fx - ix;
    final ty = fy - iy;
    final i00 = iy * g.nx + ix;
    final i01 = i00 + 1;
    final i10 = i00 + g.nx;
    final i11 = i10 + 1;
    final w00 = (1 - tx) * (1 - ty);
    final w01 = tx * (1 - ty);
    final w10 = (1 - tx) * ty;
    final w11 = tx * ty;
    final u = g.u[i00] * w00 + g.u[i01] * w01 + g.u[i10] * w10 + g.u[i11] * w11;
    final v = g.v[i00] * w00 + g.v[i01] * w01 + g.v[i10] * w10 + g.v[i11] * w11;
    return (u, v);
  }

  void _onTick(Duration elapsed) {
    if (!mounted) return;

    // Adaptive: skip every other frame after sustained slow frames.
    if (_half) {
      if (_frame.value.isOdd) {
        _frame.value = _frame.value + 1;
        return;
      }
    }

    // Measure frame time and downgrade if we're consistently > 22ms.
    final dt = elapsed - _lastFrameStamp;
    _lastFrameStamp = elapsed;
    if (dt.inMilliseconds > 22) {
      _slowFrames++;
      if (_slowFrames > 30) {
        if (_count > _minParticleCount) {
          _resizeParticles(math.max(_minParticleCount, (_count * 0.66).round()));
        } else if (!_half) {
          _half = true;
        }
        _slowFrames = 0;
      }
    } else {
      _slowFrames = math.max(0, _slowFrames - 1);
    }

    final cam = widget.camera.value;
    if (cam == null) {
      _frame.value = _frame.value + 1;
      return;
    }
    // Skip stepping at extreme zooms — particles are useless then.
    if (cam.zoom < _minZoom || cam.zoom > _maxZoom) {
      _frame.value = _frame.value + 1;
      return;
    }

    for (var i = 0; i < _count; i++) {
      final off = i * _stride;
      final age = _state[off];
      if (age >= _maxAge) {
        _respawn(i);
        continue;
      }
      final curLng = _state[off + 1];
      final curLat = _state[off + 2];
      final (u, v) = _sampleUV(curLng, curLat);
      if (u.isNaN) {
        _respawn(i);
        continue;
      }
      // Shift history (oldest gets dropped).
      for (var k = _trailLen - 1; k > 0; k--) {
        _state[off + 1 + 2 * k] = _state[off + 1 + 2 * (k - 1)];
        _state[off + 2 + 2 * k] = _state[off + 2 + 2 * (k - 1)];
      }
      _state[off + 1] = curLng + u * _stepScale;
      _state[off + 2] = curLat + v * _stepScale;
      _state[off] = age + 1;
    }

    _frame.value = _frame.value + 1;
  }

  void _resizeParticles(int newCount) {
    final old = _state;
    final oldCount = _count;
    final next = Float32List(newCount * _stride);
    final copy = math.min(oldCount, newCount);
    for (var i = 0; i < copy * _stride; i++) next[i] = old[i];
    _state = next;
    _count = newCount;
    for (var i = oldCount; i < newCount; i++) _respawn(i);
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return RepaintBoundary(
            child: CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              isComplex: true,
              willChange: true,
              painter: _WindPainter(
                state: _state,
                stride: _stride,
                count: _count,
                trailLen: _trailLen,
                camera: widget.camera,
                frame: _frame,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _WindPainter extends CustomPainter {
  final Float32List state;
  final int stride;
  final int count;
  final int trailLen;
  final ValueListenable<WindCameraSnapshot?> camera;
  final ValueListenable<int> frame;

  _WindPainter({
    required this.state,
    required this.stride,
    required this.count,
    required this.trailLen,
    required this.camera,
    required this.frame,
  }) : super(repaint: Listenable.merge([camera, frame]));

  @override
  void paint(Canvas canvas, Size size) {
    final cam = camera.value;
    if (cam == null) return;

    final proj = _Mercator(cam, size);

    // Pre-build one Paint per trail step with descending alpha.
    final paints = List<Paint>.generate(trailLen, (k) {
      final alpha = (255 * (1 - k / trailLen) * 0.85).round();
      return Paint()
        ..color = ui.Color.fromARGB(alpha, 255, 255, 255)
        ..strokeWidth = 1.4
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = false;
    });

    // Bulk path-less rendering: many short drawLine calls. Skia batches well.
    for (var i = 0; i < count; i++) {
      final off = i * stride;
      // Walk history pairs.
      double prevPx = double.nan, prevPy = double.nan;
      for (var k = 0; k < trailLen; k++) {
        final lng = state[off + 1 + 2 * k];
        final lat = state[off + 2 + 2 * k];
        final px = proj.lngToPx(lng);
        final py = proj.latToPx(lat);
        if (px.isNaN ||
            px < -64 ||
            px > size.width + 64 ||
            py < -64 ||
            py > size.height + 64) {
          prevPx = double.nan;
          continue;
        }
        if (!prevPx.isNaN) {
          canvas.drawLine(
            Offset(prevPx, prevPy),
            Offset(px, py),
            paints[k],
          );
        }
        prevPx = px;
        prevPy = py;
      }
    }
  }

  @override
  bool shouldRepaint(_WindPainter old) => true;
}

/// Web Mercator projection in Dart, baked from a camera snapshot.
/// Matches Mapbox's projection at zoom 0–18 without bearing/pitch.
class _Mercator {
  final double scale;
  final double centerWorldX;
  final double centerWorldY;
  final double halfW;
  final double halfH;

  factory _Mercator(WindCameraSnapshot cam, Size size) {
    final scale = 256.0 * math.pow(2.0, cam.zoom).toDouble();
    final cx = (cam.centerLng + 180.0) / 360.0;
    final sinLat = math.sin(cam.centerLat * math.pi / 180.0);
    final cy = 0.5 - math.log((1 + sinLat) / (1 - sinLat)) / (4 * math.pi);
    return _Mercator._(
      scale: scale,
      centerWorldX: cx * scale,
      centerWorldY: cy * scale,
      halfW: size.width / 2,
      halfH: size.height / 2,
    );
  }

  const _Mercator._({
    required this.scale,
    required this.centerWorldX,
    required this.centerWorldY,
    required this.halfW,
    required this.halfH,
  });

  double lngToPx(double lng) {
    final x = (lng + 180.0) / 360.0 * scale;
    return x - centerWorldX + halfW;
  }

  double latToPx(double lat) {
    final sinLat = math.sin(lat * math.pi / 180.0);
    final y = (0.5 - math.log((1 + sinLat) / (1 - sinLat)) / (4 * math.pi)) *
        scale;
    return y - centerWorldY + halfH;
  }
}
