import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:geolocator/geolocator.dart';
import 'package:native_exif/native_exif.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'package:geocoding/geocoding.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'package:flutter_svg/flutter_svg.dart';

import '../ar_view/ar_compass_math.dart';
import '../assets/images.dart';
import '../../models/fire.dart';
import '../../utils/haversine.dart';

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

  // Sensors (low-pass filtered)
  static const _alpha = 0.15;
  List<double> _accel = [0, 0, 9.8];
  List<double> _mag = [0, 1, 0];
  double _deviceHeading = 0;
  StreamSubscription<AccelerometerEvent>? _accelSub;
  StreamSubscription<MagnetometerEvent>? _magSub;

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
    _cameraController?.dispose();
    _clockTimer.cancel();
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
    if (!mounted) return;
    setState(() {
      _cameraController = controller;
      _cameraReady = true;
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
    // Acelerómetro não é necessário — fórmula assume telefone vertical
    _magSub = magnetometerEventStream(samplingPeriod: SensorInterval.uiInterval).listen((e) {
      _mag = [
        _alpha * e.x + (1 - _alpha) * _mag[0],
        _alpha * e.y + (1 - _alpha) * _mag[1],
        _alpha * e.z + (1 - _alpha) * _mag[2],
      ];
      _updateHeading();
    });
  }

  void _updateHeading() {
    final az = computeHeadingVertical(_mag);
    if ((az - _deviceHeading).abs() > 0.5) {
      if (mounted) setState(() => _deviceHeading = az);
    }
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

  Future<void> _captureAndSave() async {
    if (_cameraController == null || _isSaving) return;
    setState(() => _isSaving = true);

    try {
      // Snapshot values at moment of capture
      final lat = _userLat;
      final lng = _userLng;
      final alt = _userAlt;
      final heading = _deviceHeading;
      final captureTime = _currentLisbonTime();

      final xFile = await _cameraController!.takePicture();
      final bytes = await xFile.readAsBytes();

      final composited = await _composeImage(bytes, lat, lng, alt, heading, captureTime);

      // Write to temp file so we can attach EXIF metadata
      final tmpDir = await getTemporaryDirectory();
      final tmpFile = File('${tmpDir.path}/fogos_${captureTime.millisecondsSinceEpoch}.png');
      await tmpFile.writeAsBytes(composited);

      await _writeExif(tmpFile.path, lat, lng, alt, heading, captureTime);

      await Gal.putImage(tmpFile.path, album: 'Fogos.pt');
      await tmpFile.delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto guardada na galeria')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao guardar foto: $e')),
        );
        setState(() => _isSaving = false);
      }
    }
  }

  Future<Uint8List> _composeImage(
    Uint8List jpegBytes,
    double? lat,
    double? lng,
    double? alt,
    double heading,
    DateTime captureTime,
  ) async {
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
    if (_placeName != null) photoLines.add('Local: $_placeName');
    if (lat != null && lng != null) {
      photoLines.add('GPS: ${_formatCoord(lat, true)}  ${_formatCoord(lng, false)}');
      if (fire != null) {
        final dist = haversineKm(lat, lng, fire.lat, fire.lng);
        photoLines.add('Dist. ao incêndio: ${dist.toStringAsFixed(1)} km');
      }
    }
    final altStr = alt != null ? 'Alt: ${alt.toStringAsFixed(1)} m' : '';
    final dirStr = 'Dir: ${_headingToCardinal(heading)} (${heading.toStringAsFixed(0)}°)';
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

  String _toExifGps(double value) {
    final abs = value.abs();
    final deg = abs.floor();
    final minFull = (abs - deg) * 60;
    final min = minFull.floor();
    final sec = ((minFull - min) * 60 * 1000).round();
    return '$deg/1,$min/1,$sec/1000';
  }

  Future<void> _writeExif(
    String path,
    double? lat,
    double? lng,
    double? alt,
    double heading,
    DateTime captureTime,
  ) async {
    try {
      final exif = await Exif.fromPath(path);

      final dateStr =
          '${captureTime.year}:${captureTime.month.toString().padLeft(2, '0')}:${captureTime.day.toString().padLeft(2, '0')} '
          '${captureTime.hour.toString().padLeft(2, '0')}:${captureTime.minute.toString().padLeft(2, '0')}:${captureTime.second.toString().padLeft(2, '0')}';
      await exif.writeAttribute('DateTime', dateStr);
      await exif.writeAttribute('DateTimeOriginal', dateStr);

      if (lat != null && lng != null) {
        await exif.writeAttribute('GPSLatitude', _toExifGps(lat));
        await exif.writeAttribute('GPSLatitudeRef', lat >= 0 ? 'N' : 'S');
        await exif.writeAttribute('GPSLongitude', _toExifGps(lng));
        await exif.writeAttribute('GPSLongitudeRef', lng >= 0 ? 'E' : 'W');
      }
      if (alt != null) {
        await exif.writeAttribute('GPSAltitude', '${alt.abs().round()}/1');
        await exif.writeAttribute('GPSAltitudeRef', alt < 0 ? '1' : '0');
      }
      await exif.writeAttribute('GPSImgDirection', '${heading.round()}/1');
      await exif.writeAttribute('GPSImgDirectionRef', 'M');

      await exif.close();
    } catch (_) {}
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

    canvas.drawImage(
      logo,
      Offset(left + innerPadH, top + innerPadV),
      Paint(),
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

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_cameraReady && _cameraController != null)
            SizedBox.expand(
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
            )
          else
            const Center(child: CircularProgressIndicator(color: Colors.white)),

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
              child: Container(
                color: Colors.black.withValues(alpha: 0.65),
                padding: EdgeInsets.fromLTRB(16, 8, 16, safePadding.bottom + 10),
                child: _buildInfoRow(),
              ),
            ),
          ] else ...[
            // Portrait — info + shutter stacked at the bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black.withValues(alpha: 0.65),
                padding: EdgeInsets.fromLTRB(16, 12, 16, safePadding.bottom + 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildInfoRow(),
                    const SizedBox(height: 20),
                    Center(child: _buildShutterButton()),
                  ],
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
    final dirStr = '${_headingToCardinal(_deviceHeading)} (${_deviceHeading.toStringAsFixed(0)}°)';
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
              Text('Dir: $dirStr'),
            ],
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
}
