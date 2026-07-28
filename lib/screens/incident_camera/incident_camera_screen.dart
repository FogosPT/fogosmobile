import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'package:geocoding/geocoding.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'package:flutter_svg/flutter_svg.dart';

import '../ar_view/ar_compass_math.dart';
import '../assets/images.dart';
import '../../middleware/shared_preferences_manager.dart';
import '../../models/fire.dart';
import '../../services/incident_photos_service.dart';
import '../../services/orientation_service.dart';
import '../../utils/haversine.dart';
import '../../utils/png_exif.dart';
import '../settings/photo_signature_settings.dart';

enum HeadingQuality { good, medium, bad, unknown }

class _HeadingSample {
  final double headingDeg;
  final int atMs;
  final HeadingQuality quality;
  const _HeadingSample(this.headingDeg, this.atMs, this.quality);
}

class IncidentCameraScreen extends StatefulWidget {
  final Fire? fire;

  const IncidentCameraScreen({Key? key, this.fire}) : super(key: key);

  @override
  State<IncidentCameraScreen> createState() => _IncidentCameraScreenState();
}

class _IncidentCameraScreenState extends State<IncidentCameraScreen> {
  // Camera
  CameraController? _cameraController;
  bool _cameraReady = false;
  bool _cameraDenied = false;
  bool _isSaving = false;

  // Zoom
  double _minZoom = 1.0;
  double _maxZoom = 1.0;
  double _currentZoom = 1.0;
  double _baseZoom = 1.0;
  List<double> _zoomPresets = <double>[1.0];

  // Exposure compensation
  double _minExposureOffset = 0.0;
  double _maxExposureOffset = 0.0;
  double _exposureOffset = 0.0;

  // Flash + composition
  FlashMode _flashMode = FlashMode.off;
  bool _showGrid = false;

  // Tap-to-focus marker
  Offset? _focusPoint;
  Timer? _focusHideTimer;

  // Three-state indicator of how much we trust the current heading.
  // Driven by the OS-fused source when available (CMDeviceMotion /
  // TYPE_ROTATION_VECTOR) or by our own motion / mag / pitch heuristics
  // in the sensors_plus fallback.
  HeadingQuality _headingQuality = HeadingQuality.unknown;
  bool _magneticFieldOk = true; // retained for the fallback path

  // Fallback sensor state (only used when the native OrientationService
  // isn't emitting — e.g. old iOS / Android device with no ROTATION_VECTOR).
  static const _accelAlpha = 0.08;
  static const _magAlpha = 0.15;
  List<double> _accel = [0, 0, 9.8];
  List<double> _mag = [0, 1, 0];
  // Angular rate (rad/s) from the gyroscope, low-pass filtered.
  double _gyroRate = 0;
  // Deviation of |accel| from 9.8, low-pass filtered — proxy for linear
  // motion (walking, hand tremor). Kept in m/s².
  double _accelDeviation = 0;
  double _deviceHeading = 0;
  // Elevation of the camera axis above horizontal, in degrees. Populated
  // by both the native and fallback paths. Near-vertical (>|60°|) means
  // the horizontal projection is unreliable.
  double _cameraPitch = 0;
  bool _trueNorthHeading = false;
  bool _useNativeOrientation = false;
  StreamSubscription<AccelerometerEvent>? _accelSub;
  StreamSubscription<MagnetometerEvent>? _magSub;
  StreamSubscription<GyroscopeEvent>? _gyroSub;
  StreamSubscription<OrientationEvent>? _orientationSub;

  // Rolling window of recent heading readings, used to compute a circular
  // median at capture time so a single noisy sample doesn't end up in the
  // EXIF.
  final List<_HeadingSample> _headingSamples = [];
  static const int _maxHeadingSamples = 30;

  // Location
  double? _userLat;
  double? _userLng;
  double? _userAlt;
  String? _placeName;

  // GPS time reference for accurate Lisbon time
  DateTime? _gpsTimestamp;
  DateTime? _gpsSystemTimestamp;
  late tz.Location _lisbon;

  // Live clock
  late Timer _clockTimer;
  late DateTime _now;

  // Optional user-configured signature drawn into the watermark.
  String? _signature;

  @override
  void initState() {
    super.initState();
    tz_data.initializeTimeZones();
    _lisbon = tz.getLocation('Europe/Lisbon');
    _now = tz.TZDateTime.now(_lisbon);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _initCamera();
    _initLocation();
    _initSensors();
    final saved = SharedPreferencesManager.preferences
        .getString(kIncidentPhotoSignatureKey);
    if (saved != null && saved.trim().isNotEmpty) {
      _signature = saved.trim();
    }
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = _currentLisbonTime());
    });
  }

  DateTime _currentLisbonTime() {
    if (_gpsTimestamp != null && _gpsSystemTimestamp != null) {
      final elapsed = DateTime.now().difference(_gpsSystemTimestamp!);
      final gpsNow = _gpsTimestamp!.add(elapsed);
      return tz.TZDateTime.from(gpsNow, _lisbon);
    }
    return tz.TZDateTime.now(_lisbon);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    _accelSub?.cancel();
    _magSub?.cancel();
    _gyroSub?.cancel();
    _orientationSub?.cancel();
    OrientationService.stop();
    _cameraController?.dispose();
    _clockTimer.cancel();
    _focusHideTimer?.cancel();
    super.dispose();
  }

  Future<void> _initCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (mounted) setState(() => _cameraDenied = true);
      return;
    }
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      if (mounted) setState(() => _cameraDenied = true);
      return;
    }
    final controller = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );
    await controller.initialize();

    double minZoom = 1.0, maxZoom = 1.0;
    double minExp = 0.0, maxExp = 0.0;
    try {
      minZoom = await controller.getMinZoomLevel();
      maxZoom = await controller.getMaxZoomLevel();
      minExp = await controller.getMinExposureOffset();
      maxExp = await controller.getMaxExposureOffset();
    } catch (_) {}

    final presets = <double>[];
    if (minZoom < 0.95) presets.add(double.parse(minZoom.toStringAsFixed(1)));
    presets.add(1.0);
    if (maxZoom >= 2.0) presets.add(2.0);
    if (maxZoom >= 5.0) presets.add(5.0);
    if (maxZoom >= 10.0) presets.add(10.0);

    try {
      await controller.setFlashMode(FlashMode.off);
    } catch (_) {}

    if (!mounted) return;
    setState(() {
      _cameraController = controller;
      _cameraReady = true;
      _minZoom = minZoom;
      _maxZoom = maxZoom;
      _currentZoom = minZoom < 1.0 ? 1.0 : minZoom;
      _minExposureOffset = minExp;
      _maxExposureOffset = maxExp;
      _zoomPresets = presets;
    });
  }

  Future<void> _initLocation() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
      if (mounted) {
        setState(() {
          _userLat = pos.latitude;
          _userLng = pos.longitude;
          _userAlt = pos.altitude;
          _gpsTimestamp = pos.timestamp.toUtc();
          _gpsSystemTimestamp = DateTime.now();
        });
        // Android needs the coordinate to compute magnetic declination
        // and report a true-north heading. iOS resolves this internally
        // via `.xTrueNorthZVertical`.
        OrientationService.setLocation(
          pos.latitude, pos.longitude, altitude: pos.altitude,
        );
      }
      // Reverse geocode in parallel — failure is non-fatal
      try {
        final placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
        if (placemarks.isNotEmpty && mounted) {
          final p = placemarks.first;
          final parts = [p.subLocality, p.locality, p.administrativeArea]
              .where((s) => s != null && s.isNotEmpty)
              .toSet()
              .toList();
          if (parts.isNotEmpty) {
            setState(() => _placeName = parts.join(', '));
          }
        }
      } catch (_) {}
    } catch (_) {}
  }

  void _initSensors() {
    // Prefer the OS-fused orientation source: CMDeviceMotion on iOS (with
    // .xTrueNorthZVertical) and TYPE_ROTATION_VECTOR on Android. That
    // stack fuses accelerometer, gyroscope and magnetometer under a
    // Kalman-style filter, gives us the camera axis directly, and reports
    // a real calibration state. The raw sensors_plus pipeline below is
    // only wired up if the native side reports the sensor is unavailable.
    _startNativeOrientation();
    _startFallbackSensors();
  }

  Future<void> _startNativeOrientation() async {
    final available = await OrientationService.isAvailable();
    if (!available) return;
    final started = await OrientationService.start();
    if (!started) return;
    _orientationSub = OrientationService.events.listen(_onNativeOrientation);
    if (mounted) setState(() => _useNativeOrientation = true);
    // Feed GPS in so the Android bridge can add local declination for
    // true-north correction. iOS resolves it internally.
    if (_userLat != null && _userLng != null) {
      await OrientationService.setLocation(_userLat!, _userLng!, altitude: _userAlt);
    }
  }

  void _onNativeOrientation(OrientationEvent e) {
    final quality = _classifyNativeQuality(e);
    _headingSamples.add(_HeadingSample(
        e.headingDeg, DateTime.now().millisecondsSinceEpoch, quality));
    if (_headingSamples.length > _maxHeadingSamples) {
      _headingSamples.removeAt(0);
    }
    if (!mounted) return;
    final diff = ((e.headingDeg - _deviceHeading + 540) % 360) - 180;
    final pitchDiff = (e.pitchDeg - _cameraPitch).abs();
    if (diff.abs() > 0.3 ||
        pitchDiff > 0.5 ||
        quality != _headingQuality ||
        e.isTrueNorth != _trueNorthHeading) {
      setState(() {
        _deviceHeading = e.headingDeg;
        _cameraPitch = e.pitchDeg;
        _headingQuality = quality;
        _trueNorthHeading = e.isTrueNorth;
        _magneticFieldOk = quality != HeadingQuality.bad;
      });
    }
  }

  HeadingQuality _classifyNativeQuality(OrientationEvent e) {
    if (e.accuracy == OrientationAccuracy.uncalibrated) return HeadingQuality.bad;
    if (e.pitchDeg.abs() > 70) return HeadingQuality.bad;
    if (e.accuracy == OrientationAccuracy.low) return HeadingQuality.medium;
    if (e.pitchDeg.abs() > 55) return HeadingQuality.medium;
    if (e.accuracy == OrientationAccuracy.high) return HeadingQuality.good;
    if (e.accuracy == OrientationAccuracy.medium) return HeadingQuality.medium;
    return HeadingQuality.good;
  }

  void _startFallbackSensors() {
    _accelSub = accelerometerEventStream(samplingPeriod: SensorInterval.uiInterval).listen((e) {
      _accel = [
        _accelAlpha * e.x + (1 - _accelAlpha) * _accel[0],
        _accelAlpha * e.y + (1 - _accelAlpha) * _accel[1],
        _accelAlpha * e.z + (1 - _accelAlpha) * _accel[2],
      ];
      final mag = math.sqrt(
          _accel[0] * _accel[0] + _accel[1] * _accel[1] + _accel[2] * _accel[2]);
      _accelDeviation =
          _accelAlpha * (mag - 9.81).abs() + (1 - _accelAlpha) * _accelDeviation;
      _updateFallbackHeading();
    });
    _magSub = magnetometerEventStream(samplingPeriod: SensorInterval.uiInterval).listen((e) {
      _mag = [
        _magAlpha * e.x + (1 - _magAlpha) * _mag[0],
        _magAlpha * e.y + (1 - _magAlpha) * _mag[1],
        _magAlpha * e.z + (1 - _magAlpha) * _mag[2],
      ];
      _updateFallbackHeading();
    });
    _gyroSub = gyroscopeEventStream(samplingPeriod: SensorInterval.uiInterval).listen((e) {
      final rate = math.sqrt(e.x * e.x + e.y * e.y + e.z * e.z);
      _gyroRate = 0.2 * rate + 0.8 * _gyroRate;
    });
  }

  void _updateFallbackHeading() {
    // Native source takes precedence; ignore fallback calculations when
    // Core Motion / ROTATION_VECTOR is feeding us fused values.
    if (_useNativeOrientation) return;

    final az = computeHeadingTiltCompensated(_accel, _mag);
    final magOk = _magneticFieldPlausible(_mag);
    // Pitch of camera axis (-Z_device) above horizontal:
    // sin(pitch) = -a_z / |a| (accel points opposite to gravity → z<0 when
    // camera aimed above horizon).
    final anorm = math.sqrt(
        _accel[0] * _accel[0] + _accel[1] * _accel[1] + _accel[2] * _accel[2]);
    final pitch = anorm > 0
        ? math.asin((-_accel[2] / anorm).clamp(-1.0, 1.0)) * 180 / math.pi
        : 0.0;

    if (az.isNaN) {
      if (magOk != _magneticFieldOk && mounted) {
        setState(() => _magneticFieldOk = magOk);
      }
      return;
    }

    // Motion gating — refuse to accept a new heading while the phone is
    // moving. Linear accel corrupts gravity estimation, and gyro rate
    // above ~0.5 rad/s means the user is panning; either way the fused
    // heading is unreliable. We still keep displaying the last stable
    // value so the UI doesn't jump.
    final moving = _accelDeviation > 0.6 || _gyroRate > 0.5;

    final quality = _classifyFallbackQuality(
      magOk: magOk,
      moving: moving,
      pitch: pitch,
    );

    _headingSamples.add(_HeadingSample(
        az, DateTime.now().millisecondsSinceEpoch, quality));
    if (_headingSamples.length > _maxHeadingSamples) {
      _headingSamples.removeAt(0);
    }

    if (moving && quality == HeadingQuality.bad) {
      // Don't update the visible heading during heavy motion; keep the
      // pitch/quality flags fresh though.
      if (mounted &&
          (pitch.round() != _cameraPitch.round() ||
              quality != _headingQuality ||
              magOk != _magneticFieldOk)) {
        setState(() {
          _cameraPitch = pitch;
          _headingQuality = quality;
          _magneticFieldOk = magOk;
        });
      }
      return;
    }

    // Shortest angular distance, so the 359°↔1° step doesn't trigger.
    final diff = ((az - _deviceHeading + 540) % 360) - 180;
    final needsUpdate = diff.abs() > 0.5 ||
        magOk != _magneticFieldOk ||
        quality != _headingQuality ||
        (pitch - _cameraPitch).abs() > 0.5;
    if (needsUpdate && mounted) {
      setState(() {
        _deviceHeading = az;
        _magneticFieldOk = magOk;
        _cameraPitch = pitch;
        _headingQuality = quality;
        _trueNorthHeading = false;
      });
    }
  }

  HeadingQuality _classifyFallbackQuality({
    required bool magOk,
    required bool moving,
    required double pitch,
  }) {
    if (!magOk) return HeadingQuality.bad;
    if (pitch.abs() > 70) return HeadingQuality.bad;
    if (moving) return HeadingQuality.medium;
    if (pitch.abs() > 55) return HeadingQuality.medium;
    return HeadingQuality.good;
  }

  bool _magneticFieldPlausible(List<double> mag) {
    final m = magneticFieldMagnitude(mag);
    // Earth field is 25–65 μT; allow a bit of slack for a warm-up magnetometer.
    return m >= 20 && m <= 75;
  }

  /// Circular median of the samples collected inside [windowMs] before now.
  /// Returns null if the window contains no usable (non-bad) samples.
  ({double heading, HeadingQuality quality})? _captureHeadingMedian({
    int windowMs = 500,
  }) {
    if (_headingSamples.isEmpty) return null;
    final cutoff = DateTime.now().millisecondsSinceEpoch - windowMs;
    final recent = _headingSamples
        .where((s) => s.atMs >= cutoff && s.quality != HeadingQuality.bad)
        .toList();
    if (recent.isEmpty) return null;
    // Circular mean via unit-vector sum — resistant to the 359°↔0° wrap.
    double sx = 0, sy = 0;
    for (final s in recent) {
      final r = s.headingDeg * math.pi / 180.0;
      sx += math.cos(r);
      sy += math.sin(r);
    }
    final mean = (math.atan2(sy, sx) * 180 / math.pi + 360) % 360;
    // Worst quality present in the window bubbles up.
    HeadingQuality worst = HeadingQuality.good;
    for (final s in recent) {
      if (s.quality == HeadingQuality.medium && worst == HeadingQuality.good) {
        worst = HeadingQuality.medium;
      }
    }
    return (heading: mean, quality: worst);
  }

  String _headingToCardinal(double deg) {
    const dirs = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    return dirs[((deg + 22.5) / 45).floor() % 8];
  }

  String _formatCoord(double value, bool isLat) {
    final abs = value.abs();
    final dir = isLat ? (value >= 0 ? 'N' : 'S') : (value >= 0 ? 'E' : 'W');
    return '${abs.toStringAsFixed(5)}°$dir';
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  String _formatDate(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final mo = dt.month.toString().padLeft(2, '0');
    return '$d/$mo/${dt.year}';
  }

  Future<void> _setZoom(double zoom) async {
    final controller = _cameraController;
    if (controller == null) return;
    final clamped = zoom.clamp(_minZoom, _maxZoom);
    try {
      await controller.setZoomLevel(clamped);
    } catch (_) {
      return;
    }
    if (mounted) setState(() => _currentZoom = clamped);
  }

  void _onScaleStart(ScaleStartDetails _) {
    _baseZoom = _currentZoom;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (details.pointerCount < 2) return;
    _setZoom(_baseZoom * details.scale);
  }

  Future<void> _setExposureOffset(double offset) async {
    final controller = _cameraController;
    if (controller == null) return;
    final clamped = offset.clamp(_minExposureOffset, _maxExposureOffset);
    try {
      await controller.setExposureOffset(clamped);
    } catch (_) {
      return;
    }
    if (mounted) setState(() => _exposureOffset = clamped);
  }

  Future<void> _cycleFlashMode() async {
    final controller = _cameraController;
    if (controller == null) return;
    const order = [FlashMode.off, FlashMode.auto, FlashMode.always, FlashMode.torch];
    final next = order[(order.indexOf(_flashMode) + 1) % order.length];
    try {
      await controller.setFlashMode(next);
    } catch (_) {
      return;
    }
    if (mounted) setState(() => _flashMode = next);
  }

  Future<void> _handleTapFocus(Offset localPos, Size areaSize) async {
    final controller = _cameraController;
    if (controller == null) return;
    final normalized = Offset(
      (localPos.dx / areaSize.width).clamp(0.0, 1.0),
      (localPos.dy / areaSize.height).clamp(0.0, 1.0),
    );
    try {
      await controller.setFocusMode(FocusMode.auto);
      await controller.setFocusPoint(normalized);
      await controller.setExposureMode(ExposureMode.auto);
      await controller.setExposurePoint(normalized);
    } catch (_) {}
    if (!mounted) return;
    setState(() => _focusPoint = localPos);
    _focusHideTimer?.cancel();
    _focusHideTimer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _focusPoint = null);
    });
  }

  IconData _flashIcon(FlashMode mode) {
    switch (mode) {
      case FlashMode.off:
        return Icons.flash_off;
      case FlashMode.auto:
        return Icons.flash_auto;
      case FlashMode.always:
        return Icons.flash_on;
      case FlashMode.torch:
        return Icons.highlight;
    }
  }

  Future<void> _captureAndSave() async {
    if (_cameraController == null || _isSaving) return;
    setState(() => _isSaving = true);

    File? tmpFile;
    try {
      // Snapshot values at moment of capture
      final lat = _userLat;
      final lng = _userLng;
      final alt = _userAlt;
      final captureTime = _currentLisbonTime();

      // Prefer the circular median over the trailing ~500ms — single
      // noisy samples don't survive. If every recent sample was flagged
      // as bad (uncalibrated compass or near-vertical camera) drop the
      // heading entirely rather than baking a lie into the EXIF.
      final medianed = _captureHeadingMedian();
      final headingForEmbed = medianed?.heading;
      final headingQuality = medianed?.quality ?? HeadingQuality.bad;
      final headingForWatermark = medianed?.heading ?? _deviceHeading;
      final isTrueNorth = _trueNorthHeading;

      final xFile = await _cameraController!.takePicture();
      final bytes = await xFile.readAsBytes();

      final composited = await _composeImage(
          bytes, lat, lng, alt, headingForWatermark, captureTime,
          headingIsFinal: headingForEmbed != null,
          headingQuality: headingQuality);

      // Preview the composed photo so the user can discard and retake before
      // we touch tmp files, the gallery or the upload flow.
      final keep = await _showPhotoPreview(composited);
      if (!keep) {
        if (mounted) setState(() => _isSaving = false);
        return;
      }

      // Inject the eXIf chunk into the PNG bytes ourselves. native_exif on
      // Android cannot write EXIF into PNG (ExifInterface only supports
      // JPEG/WebP/HEIC writes), and the fogos.pt API requires the eXIf chunk
      // to extract GPS coordinates.
      final pngWithExif = addPngExif(
        pngBytes: composited,
        lat: lat,
        lng: lng,
        altitude: alt,
        imgDirection: headingForEmbed,
        imgDirectionTrue: isTrueNorth,
        dateTimeOriginal: captureTime,
      );

      final tmpDir = await getTemporaryDirectory();
      tmpFile = File('${tmpDir.path}/fogos_${captureTime.millisecondsSinceEpoch}.png');
      await tmpFile.writeAsBytes(pngWithExif);

      // Decide whether to also upload. Only offer upload when there is an
      // associated fire and we actually captured GPS (the API rejects
      // without GPS, no point trying).
      final fire = widget.fire;
      final hasGps = lat != null && lng != null;
      final canUpload = fire != null && hasGps;

      bool shouldUpload = false;
      bool allowPublic = true;
      if (canUpload) {
        final choice = await _askUploadConfirmation();
        if (choice.cancelled) {
          try {
            await tmpFile.delete();
          } catch (_) {}
          if (mounted) setState(() => _isSaving = false);
          return;
        }
        shouldUpload = choice.send;
        allowPublic = choice.allowPublic;
      }

      // Save to gallery and (optionally) upload in parallel.
      final saveFuture = Gal.putImage(tmpFile.path, album: 'Fogos.pt');
      final uploadFuture = shouldUpload
          ? IncidentPhotosService().uploadIncidentPhoto(
              fireId: fire!.id,
              photoFile: tmpFile,
              allowPublic: allowPublic,
              signature: _signature,
            )
          : null;

      UploadResult? uploadResult;
      try {
        if (uploadFuture != null) {
          final results = await Future.wait([saveFuture, uploadFuture]);
          uploadResult = results[1] as UploadResult;
        } else {
          await saveFuture;
        }
      } finally {
        try {
          await tmpFile.delete();
        } catch (_) {}
      }

      if (!mounted) return;

      final message = uploadResult == null
          ? 'Foto guardada na galeria.'
          : _uploadResultMessage(uploadResult);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 4)),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (tmpFile != null) {
        try {
          await tmpFile.delete();
        } catch (_) {}
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao guardar foto: $e')),
        );
        setState(() => _isSaving = false);
      }
    }
  }

  Future<bool> _showPhotoPreview(Uint8List pngBytes) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 4,
                    child: Center(
                      child: Image.memory(pngBytes, fit: BoxFit.contain),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white54),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () => Navigator.of(ctx).pop(false),
                          icon: const Icon(Icons.refresh),
                          label: const Text(
                            'Repetir',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () => Navigator.of(ctx).pop(true),
                          icon: const Icon(Icons.check),
                          label: const Text(
                            'Usar foto',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return result == true;
  }

  Future<({bool cancelled, bool send, bool allowPublic})>
      _askUploadConfirmation() async {
    bool allowPublic = true;
    const bodyStyle = TextStyle(fontSize: 13, color: Colors.black87, height: 1.5);
    const boldStyle = TextStyle(
      fontSize: 13,
      color: Colors.black87,
      height: 1.5,
      fontWeight: FontWeight.bold,
    );

    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          title: const Text('Enviar foto para o Fogos.pt?'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Antes de enviar, lê com atenção:', style: bodyStyle),
                  const SizedBox(height: 12),
                  RichText(
                    text: TextSpan(
                      style: bodyStyle,
                      children: const [
                        TextSpan(text: '• '),
                        TextSpan(
                          text: 'As coordenadas GPS estão visíveis na própria foto',
                          style: boldStyle,
                        ),
                        TextSpan(
                            text: ' (no rodapé). Confirma que estás confortável a '
                                'partilhar a tua localização antes de enviar.'),
                      ],
                    ),
                  ),
                  if (_signature != null && _signature!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: bodyStyle,
                        children: [
                          const TextSpan(text: '• '),
                          TextSpan(
                            text: 'A foto será assinada com o nome "$_signature"',
                            style: boldStyle,
                          ),
                          const TextSpan(text: ', configurado nas Definições.'),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: bodyStyle,
                      children: const [
                        TextSpan(
                            text: '• Se autorizares a publicação, e depois de aprovada, a foto fica '),
                        TextSpan(
                          text: 'publicamente disponível a todos os utilizadores da app Fogos.pt',
                          style: boldStyle,
                        ),
                        TextSpan(text: ' e é '),
                        TextSpan(
                          text: 'partilhada com a ANEPC',
                          style: boldStyle,
                        ),
                        TextSpan(text: ' e outras entidades operacionais.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: bodyStyle,
                      children: const [
                        TextSpan(text: '• Se '),
                        TextSpan(text: 'não', style: boldStyle),
                        TextSpan(
                            text: ' autorizares a publicação, a foto é partilhada '),
                        TextSpan(
                          text: 'apenas com a ANEPC',
                          style: boldStyle,
                        ),
                        TextSpan(
                            text: ' para efeitos operacionais e não aparece publicamente na app.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: bodyStyle,
                      children: const [
                        TextSpan(text: '• ', style: bodyStyle),
                        TextSpan(text: 'Não envies fotos', style: boldStyle),
                        TextSpan(text: ' que contenham:'),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 12, top: 2),
                    child: Text(
                      '— pessoas identificáveis sem o seu consentimento\n'
                      '— matrículas, documentos ou outros dados pessoais\n'
                      '— crimes, atos ofensivos ou conteúdo gráfico/violento',
                      style: bodyStyle,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: bodyStyle,
                      children: const [
                        TextSpan(text: '• És o '),
                        TextSpan(text: 'único responsável', style: boldStyle),
                        TextSpan(
                            text: ' pelo conteúdo que partilhas. O Fogos.pt e a VOST '
                                'Portugal reservam-se o direito de rejeitar fotos que '
                                'violem estas regras ou a lei aplicável.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: bodyStyle,
                      children: const [
                        TextSpan(text: '• Fotos '),
                        TextSpan(text: 'rejeitadas', style: boldStyle),
                        TextSpan(text: ' na moderação são '),
                        TextSpan(
                          text: 'eliminadas definitivamente',
                          style: boldStyle,
                        ),
                        TextSpan(text: ' de todos os sistemas.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: bodyStyle,
                      children: const [
                        TextSpan(text: '• Fotos '),
                        TextSpan(text: 'aceites', style: boldStyle),
                        TextSpan(text: ' poderão ser '),
                        TextSpan(
                          text: 'conservadas e utilizadas para outros fins',
                          style: boldStyle,
                        ),
                        TextSpan(
                            text: ', tais como '),
                        TextSpan(
                          text: 'treino de modelos de Inteligência Artificial',
                          style: boldStyle,
                        ),
                        TextSpan(
                            text: ', análise operacional ou investigação, '
                                'podendo ou não ser eliminadas no futuro.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: allowPublic,
                        onChanged: (v) =>
                            setStateDialog(() => allowPublic = v ?? true),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              setStateDialog(() => allowPublic = !allowPublic),
                          child: const Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Text(
                              'Autorizo a publicação pública desta foto na app '
                              'Fogos.pt. Se desmarcado, a foto é partilhada apenas '
                              'com a ANEPC.',
                              style: bodyStyle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Ao tocar em "Enviar", confirmas que leste e aceitas estas condições.',
                    style: TextStyle(
                        fontSize: 12, color: Colors.black54, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop('cancel'),
              child: const Text(
                'Cancelar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop('save'),
              child: const Text(
                'Só guardar na tua galeria',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop('send'),
              child: const Text(
                'Enviar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
    return (
      cancelled: result == 'cancel' || result == null,
      send: result == 'send',
      allowPublic: allowPublic,
    );
  }

  String _uploadResultMessage(UploadResult result) {
    switch (result) {
      case UploadAccepted():
        return 'Foto guardada e enviada. Aguarda moderação antes de ser publicada.';
      case UploadMissingGps():
        return 'Precisamos da localização para enviar a foto. Verifica as permissões de localização.';
      case UploadNotFound():
        return 'Este incidente já não está disponível.';
      case UploadTooLarge():
        return 'Foto guardada. Não foi enviada porque é demasiado grande.';
      case UploadInvalidFormat():
        return 'Foto guardada. Não conseguimos enviá-la — tenta tirar outra.';
      case UploadRateLimited(:final retryAfter):
        final minutes = (retryAfter.inSeconds / 60).ceil();
        return 'Foto guardada. Estás a enviar demasiado rápido — tenta dentro de $minutes min.';
      case UploadServerError():
        return 'Foto guardada. Não foi possível enviá-la agora — tenta mais tarde.';
      case UploadNetworkError():
        return 'Foto guardada. Sem ligação para enviar — tenta mais tarde.';
    }
  }

  Future<Uint8List> _composeImage(
    Uint8List jpegBytes,
    double? lat,
    double? lng,
    double? alt,
    double heading,
    DateTime captureTime, {
    bool headingIsFinal = true,
    HeadingQuality headingQuality = HeadingQuality.good,
  }) async {
    final codec = await ui.instantiateImageCodec(jpegBytes);
    final frame = await codec.getNextFrame();
    final srcImage = frame.image;
    final w = srcImage.width.toDouble();
    final h = srcImage.height.toDouble();

    // Rasterize SVG logo to ui.Image for compositing
    final pictureInfo = await vg.loadPicture(
      SvgAssetLoader(imgSvgLogoBrancoHorizontal),
      null,
    );
    final logoTargetW = (w * 0.25).round();
    final logoScale = logoTargetW / pictureInfo.size.width;
    final logoTargetH = (pictureInfo.size.height * logoScale).round();
    final logoRecorder = ui.PictureRecorder();
    final logoCanvas = Canvas(logoRecorder, Rect.fromLTWH(0, 0, logoTargetW.toDouble(), logoTargetH.toDouble()));
    logoCanvas.scale(logoScale);
    logoCanvas.drawPicture(pictureInfo.picture);
    pictureInfo.picture.dispose();
    final logoImage = await logoRecorder.endRecording().toImage(logoTargetW, logoTargetH);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, w, h));
    canvas.drawImage(srcImage, Offset.zero, Paint());

    final fire = widget.fire;

    // Top block — fire info (only when associated with a fire)
    final fireLines = <String>[];
    if (fire != null) {
      final locationParts = [fire.local, fire.city, fire.district]
          .where((s) => s.isNotEmpty)
          .toSet()
          .toList();
      if (locationParts.isNotEmpty) fireLines.add(locationParts.join(', '));
      fireLines.add('ID: ${fire.id}');
    }

    // Bottom block — photo context
    final photoLines = <String>[];
    if (_signature != null && _signature!.isNotEmpty) {
      photoLines.add('— $_signature');
    }
    if (_placeName != null) photoLines.add('Local da foto: $_placeName');
    if (lat != null && lng != null) {
      photoLines.add('GPS: ${_formatCoord(lat, true)}  ${_formatCoord(lng, false)}');
      if (fire != null) {
        final dist = haversineKm(lat, lng, fire.lat, fire.lng);
        photoLines.add('Dist. ao incêndio: ${dist.toStringAsFixed(1)} km');
      }
    }
    final altStr = alt != null ? 'Alt: ${alt.toStringAsFixed(1)} m' : '';
    final String dirStr;
    if (!headingIsFinal || headingQuality == HeadingQuality.bad) {
      dirStr = 'Dir: —';
    } else {
      final label = headingQuality == HeadingQuality.medium ? '~' : '';
      dirStr =
          'Dir: $label${_headingToCardinal(heading)} (${heading.toStringAsFixed(0)}°)';
    }
    photoLines.add(altStr.isNotEmpty ? '$altStr   $dirStr' : dirStr);
    photoLines.add('${_formatDate(captureTime)}  ${_formatTime(captureTime)}');

    _drawWatermark(canvas, w, h, logoImage);
    if (fireLines.isNotEmpty) _drawBlock(canvas, w, h, fireLines, top: true);
    _drawBlock(canvas, w, h, photoLines, top: false);

    final picture = recorder.endRecording();
    final composed = await picture.toImage(srcImage.width, srcImage.height);
    final byteData = await composed.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  void _drawWatermark(Canvas canvas, double imgW, double imgH, ui.Image logo) {
    final padding = imgW * 0.02;
    final innerPadH = imgW * 0.012;
    final innerPadV = imgW * 0.008;
    final logoW = logo.width.toDouble();
    final logoH = logo.height.toDouble();
    final left = imgW - logoW - padding - innerPadH * 2;
    final top = padding;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, logoW + innerPadH * 2, logoH + innerPadV * 2),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0x99000000),
    );

    // Force the logo silhouette to render as solid white regardless of the
    // SVG's original fill — the rasterizer occasionally misses class-based
    // styles in the source SVG and falls back to dark fills, which over the
    // dark overlay made the logo look grey.
    canvas.drawImage(
      logo,
      Offset(left + innerPadH, top + innerPadV),
      Paint()..colorFilter = const ColorFilter.mode(Colors.white, BlendMode.srcIn),
    );
  }

  /// Draws a semi-transparent text block anchored to the top-left or
  /// bottom-left corner of the image.
  void _drawBlock(Canvas canvas, double imgW, double imgH, List<String> lines,
      {required bool top}) {
    if (lines.isEmpty) return;
    final fontSize = imgH * 0.022;
    final padding = imgW * 0.02;
    final lineGap = fontSize * 0.5;
    final maxTextW = imgW * 0.55; // cap block width at 55% of image

    final textPainters = lines.map((line) {
      final tp = TextPainter(
        text: TextSpan(
          text: line,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      tp.layout(maxWidth: maxTextW);
      return tp;
    }).toList();

    // Use actual rendered heights so wrapped lines don't overflow the box
    final maxLineW = textPainters.fold(0.0, (m, tp) => tp.width > m ? tp.width : m);
    final totalTextH = textPainters.fold(0.0, (s, tp) => s + tp.height) +
        lineGap * (textPainters.length - 1);
    final blockW = maxLineW + padding * 2;
    final blockH = totalTextH + padding * 1.5;
    final left = padding;
    final blockTop = top ? padding : imgH - blockH - padding;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, blockTop, blockW, blockH),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0x99000000),
    );

    var textY = blockTop + padding * 0.75;
    for (final tp in textPainters) {
      tp.paint(canvas, Offset(left + padding, textY));
      textY += tp.height + lineGap;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraDenied) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.camera_alt_outlined, size: 64, color: Colors.white38),
                const SizedBox(height: 16),
                const Text(
                  'Acesso à câmara necessário',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ativa a permissão nas definições\ndo dispositivo.',
                  style: TextStyle(color: Colors.white54, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: openAppSettings,
                  child: const Text('Abrir Definições'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Voltar', style: TextStyle(color: Colors.white54)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final safePadding = MediaQuery.of(context).padding;
    final mediaSize = MediaQuery.of(context).size;
    final hasExposureRange = _maxExposureOffset > _minExposureOffset;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera preview + gesture layer (pinch to zoom, tap to focus/expose)
          if (_cameraReady && _cameraController != null)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onScaleStart: _onScaleStart,
              onScaleUpdate: _onScaleUpdate,
              onTapUp: (details) =>
                  _handleTapFocus(details.localPosition, mediaSize),
              child: SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    // previewSize is always landscape (width > height).
                    // Swap for portrait; use as-is for landscape.
                    width: isLandscape
                        ? (_cameraController!.value.previewSize?.width ?? 1)
                        : (_cameraController!.value.previewSize?.height ?? 1),
                    height: isLandscape
                        ? (_cameraController!.value.previewSize?.height ?? 1)
                        : (_cameraController!.value.previewSize?.width ?? 1),
                    child: CameraPreview(_cameraController!),
                  ),
                ),
              ),
            )
          else
            const Center(child: CircularProgressIndicator(color: Colors.white)),

          // Rule-of-thirds grid
          if (_showGrid)
            const Positioned.fill(
              child: IgnorePointer(child: _GridOverlay()),
            ),

          // Tap-to-focus marker
          if (_focusPoint != null)
            Positioned(
              left: _focusPoint!.dx - 36,
              top: _focusPoint!.dy - 36,
              child: const IgnorePointer(child: _FocusMarker()),
            ),

          // Close button — respects safe area on both axes
          Positioned(
            top: safePadding.top + 8,
            left: safePadding.left + 12,
            child: Material(
              color: Colors.black54,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => Navigator.of(context).pop(),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.close, color: Colors.white, size: 24),
                ),
              ),
            ),
          ),

          // Flash + grid toggles — top-right
          Positioned(
            top: safePadding.top + 8,
            right: safePadding.right + 12,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildIconButton(
                  icon: _flashIcon(_flashMode),
                  active: _flashMode != FlashMode.off,
                  onTap: _cycleFlashMode,
                ),
                const SizedBox(height: 8),
                _buildIconButton(
                  icon: _showGrid ? Icons.grid_on : Icons.grid_off,
                  active: _showGrid,
                  onTap: () => setState(() => _showGrid = !_showGrid),
                ),
              ],
            ),
          ),

          // Exposure compensation slider — left side, vertical
          if (hasExposureRange)
            Positioned(
              left: safePadding.left + 6,
              top: 0,
              bottom: 0,
              child: Center(child: _buildExposureSlider()),
            ),

          if (isLandscape) ...[
            // Shutter button — vertically centred on the right
            Positioned(
              right: safePadding.right + 16,
              top: 0,
              bottom: 0,
              child: Center(child: _buildShutterButton()),
            ),
            // Info panel — bottom strip, leaving room for the shutter
            Positioned(
              bottom: 0,
              left: 0,
              right: safePadding.right + 100,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {},
                child: Container(
                  color: Colors.black.withValues(alpha: 0.65),
                  padding: EdgeInsets.fromLTRB(16, 8, 16, safePadding.bottom + 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildZoomRow(),
                      const SizedBox(height: 6),
                      _buildInfoRow(),
                    ],
                  ),
                ),
              ),
            ),
          ] else ...[
            // Portrait — info + shutter stacked at the bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {},
                child: Container(
                  color: Colors.black.withValues(alpha: 0.65),
                  padding: EdgeInsets.fromLTRB(16, 12, 16, safePadding.bottom + 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildZoomRow(),
                      const SizedBox(height: 8),
                      _buildInfoRow(),
                      const SizedBox(height: 20),
                      Center(child: _buildShutterButton()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow() {
    final latStr = _userLat != null ? _formatCoord(_userLat!, true) : '—';
    final lngStr = _userLng != null ? _formatCoord(_userLng!, false) : '—';
    final altStr = _userAlt != null ? '${_userAlt!.toStringAsFixed(1)} m' : '—';
    final trueSuffix = _trueNorthHeading ? ' T' : '';
    final dirStr = _headingQuality == HeadingQuality.bad
        ? '—'
        : '${_headingToCardinal(_deviceHeading)} (${_deviceHeading.toStringAsFixed(0)}°$trueSuffix)';
    final qualityColor = switch (_headingQuality) {
      HeadingQuality.good => const Color(0xFF4CAF50),
      HeadingQuality.medium => const Color(0xFFFFC107),
      HeadingQuality.bad => const Color(0xFFF44336),
      HeadingQuality.unknown => Colors.white54,
    };
    final qualityIcon = switch (_headingQuality) {
      HeadingQuality.good => Icons.check_circle_outline,
      HeadingQuality.medium => Icons.warning_amber_rounded,
      HeadingQuality.bad => Icons.error_outline,
      HeadingQuality.unknown => Icons.help_outline,
    };
    final distStr = (widget.fire != null && _userLat != null && _userLng != null)
        ? '${haversineKm(_userLat!, _userLng!, widget.fire!.lat, widget.fire!.lng).toStringAsFixed(1)} km'
        : null;

    return DefaultTextStyle(
      style: const TextStyle(color: Colors.white, fontSize: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('GPS: $latStr  $lngStr'),
              Text(_formatTime(_now)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Alt: $altStr'),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Dir: $dirStr'),
                  const SizedBox(width: 6),
                  Icon(qualityIcon, color: qualityColor, size: 14),
                ],
              ),
            ],
          ),
          if (_headingQuality == HeadingQuality.bad)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _cameraPitch.abs() > 65
                    ? 'Endireita o telemóvel — direção indefinida'
                    : 'Bússola pouco fiável — afasta-te de metais / calibra',
                style: TextStyle(color: qualityColor, fontSize: 11),
              ),
            )
          else if (_headingQuality == HeadingQuality.medium)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _cameraPitch.abs() > 50
                    ? 'Ângulo elevado — direção aproximada'
                    : 'Mantém-te parado para direção precisa',
                style: TextStyle(color: qualityColor, fontSize: 11),
              ),
            ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (distStr != null) Text('Dist. ao incêndio: $distStr'),
              if (_placeName != null) Text(_placeName!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShutterButton() {
    return GestureDetector(
      onTap: _isSaving ? null : _captureAndSave,
      child: Container(
        width: 68,
        height: 68,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
          color: _isSaving ? Colors.grey.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.9),
        ),
        child: _isSaving
            ? const Padding(
                padding: EdgeInsets.all(18),
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : null,
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required bool active,
    required VoidCallback onTap,
  }) {
    return Material(
      color: active ? const Color(0xE6F09819) : Colors.black54,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }

  Widget _buildExposureSlider() {
    return Container(
      width: 42,
      height: 220,
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          const Icon(Icons.wb_sunny_outlined, color: Colors.white, size: 18),
          Expanded(
            child: RotatedBox(
              quarterTurns: 3,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 2,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                  activeTrackColor: const Color(0xFFF09819),
                  inactiveTrackColor: Colors.white24,
                  thumbColor: Colors.white,
                  overlayColor: const Color(0x33F09819),
                ),
                child: Slider(
                  value: _exposureOffset.clamp(_minExposureOffset, _maxExposureOffset),
                  min: _minExposureOffset,
                  max: _maxExposureOffset,
                  onChanged: _setExposureOffset,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16,
            child: Text(
              '${_exposureOffset >= 0 ? '+' : ''}${_exposureOffset.toStringAsFixed(1)}',
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoomRow() {
    if (_zoomPresets.length <= 1 && _maxZoom <= 1.001) {
      return const SizedBox.shrink();
    }
    // Highlight the preset closest to the current zoom
    final closestPreset = _zoomPresets.reduce(
      (a, b) => (a - _currentZoom).abs() < (b - _currentZoom).abs() ? a : b,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _zoomPresets.map((preset) {
        final isActive = preset == closestPreset;
        final onPreset = (_currentZoom - preset).abs() < 0.05;
        final label = (isActive && !onPreset)
            ? '${_currentZoom.toStringAsFixed(1)}x'
            : (preset < 1
                ? '${preset.toStringAsFixed(1)}x'
                : '${preset.toStringAsFixed(0)}x');
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Material(
            color: isActive ? Colors.white : Colors.black54,
            shape: const StadiumBorder(),
            child: InkWell(
              customBorder: const StadiumBorder(),
              onTap: () => _setZoom(preset),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Text(
                  label,
                  style: TextStyle(
                    color: isActive ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _GridOverlay extends StatelessWidget {
  const _GridOverlay();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _GridPainter());
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..strokeWidth = 0.5;
    canvas.drawLine(
        Offset(size.width / 3, 0), Offset(size.width / 3, size.height), paint);
    canvas.drawLine(Offset(size.width * 2 / 3, 0),
        Offset(size.width * 2 / 3, size.height), paint);
    canvas.drawLine(
        Offset(0, size.height / 3), Offset(size.width, size.height / 3), paint);
    canvas.drawLine(Offset(0, size.height * 2 / 3),
        Offset(size.width, size.height * 2 / 3), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FocusMarker extends StatefulWidget {
  const _FocusMarker();

  @override
  State<_FocusMarker> createState() => _FocusMarkerState();
}

class _FocusMarkerState extends State<_FocusMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    )..forward();
    _scale = Tween<double>(begin: 1.5, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _opacity = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Opacity(
        opacity: _opacity.value,
        child: Transform.scale(scale: _scale.value, child: child),
      ),
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFFFE082), width: 1.5),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
