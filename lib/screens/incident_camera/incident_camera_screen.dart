import 'dart:async';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../ar_view/ar_compass_math.dart';
import '../../models/fire.dart';

class IncidentCameraScreen extends StatefulWidget {
  final Fire fire;

  const IncidentCameraScreen({Key? key, required this.fire}) : super(key: key);

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

  // Live clock
  late Timer _clockTimer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _initCamera();
    _initLocation();
    _initSensors();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
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
        });
      }
    } catch (_) {}
  }

  void _initSensors() {
    _accelSub = accelerometerEventStream(samplingPeriod: SensorInterval.uiInterval).listen((e) {
      _accel = [
        _alpha * e.x + (1 - _alpha) * _accel[0],
        _alpha * e.y + (1 - _alpha) * _accel[1],
        _alpha * e.z + (1 - _alpha) * _accel[2],
      ];
      _updateHeading();
    });
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
    final (az, _) = computeHeadingAndPitch(_accel, _mag);
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
      final captureTime = DateTime.now();

      final xFile = await _cameraController!.takePicture();
      final bytes = await xFile.readAsBytes();

      final composited = await _composeImage(bytes, lat, lng, alt, heading, captureTime);

      await Gal.putImageBytes(composited, album: 'Fogos.pt');

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

    // Load logo asset
    final logoData = await rootBundle.load('assets/logo.png');
    final logoCodec = await ui.instantiateImageCodec(
      logoData.buffer.asUint8List(),
      targetWidth: (w * 0.15).round(),
    );
    final logoImage = (await logoCodec.getNextFrame()).image;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, w, h));
    canvas.drawImage(srcImage, Offset.zero, Paint());

    final fire = widget.fire;
    final locationParts = [fire.local, fire.city, fire.district]
        .where((s) => s.isNotEmpty)
        .toSet()
        .toList();

    final lines = <String>[];
    lines.add(locationParts.join(', '));
    lines.add('ID: ${fire.id}');
    if (lat != null && lng != null) {
      lines.add('GPS: ${_formatCoord(lat, true)}  ${_formatCoord(lng, false)}');
    }
    final altStr = alt != null ? 'Alt: ${alt.toStringAsFixed(1)} m' : '';
    final dirStr = 'Dir: ${_headingToCardinal(heading)} (${heading.toStringAsFixed(0)}°)';
    lines.add(altStr.isNotEmpty ? '$altStr   $dirStr' : dirStr);
    lines.add('${_formatDate(captureTime)}  ${_formatTime(captureTime)}');

    _drawOverlay(canvas, w, h, lines);
    _drawWatermark(canvas, w, h, logoImage);

    final picture = recorder.endRecording();
    final composed = await picture.toImage(srcImage.width, srcImage.height);
    final byteData = await composed.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  void _drawWatermark(Canvas canvas, double imgW, double imgH, ui.Image logo) {
    final padding = imgW * 0.02;
    final logoW = logo.width.toDouble();
    final left = imgW - logoW - padding;
    final top = padding;

    canvas.drawImage(
      logo,
      Offset(left, top),
      Paint()..color = const Color(0xAAFFFFFF),
    );
  }

  void _drawOverlay(Canvas canvas, double imgW, double imgH, List<String> lines) {
    final fontSize = imgH * 0.022;
    final padding = imgW * 0.02;
    final lineSpacing = fontSize * 1.5;

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
      tp.layout(maxWidth: imgW - padding * 4);
      return tp;
    }).toList();

    final maxLineW = textPainters.fold(0.0, (m, tp) => tp.width > m ? tp.width : m);
    final blockH = lines.length * lineSpacing + padding;
    final blockW = maxLineW + padding * 2;
    final left = padding;
    final top = imgH - blockH - padding;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, blockW, blockH),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0x99000000),
    );

    for (var i = 0; i < textPainters.length; i++) {
      textPainters[i].paint(
        canvas,
        Offset(left + padding, top + padding / 2 + i * lineSpacing),
      );
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
                  width: _cameraController!.value.previewSize?.height ?? 1,
                  height: _cameraController!.value.previewSize?.width ?? 1,
                  child: CameraPreview(_cameraController!),
                ),
              ),
            )
          else
            const Center(child: CircularProgressIndicator(color: Colors.white)),
          // Close button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 12,
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
          // Info bar + shutter
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black.withOpacity(0.65),
              padding: EdgeInsets.fromLTRB(
                16, 12, 16, MediaQuery.of(context).padding.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildInfoRow(),
                  const SizedBox(height: 20),
                  _buildShutterButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow() {
    final latStr = _userLat != null ? _formatCoord(_userLat!, true) : '—';
    final lngStr = _userLng != null ? _formatCoord(_userLng!, false) : '—';
    final altStr = _userAlt != null ? '${_userAlt!.toStringAsFixed(1)} m' : '—';
    final dirStr = '${_headingToCardinal(_deviceHeading)} (${_deviceHeading.toStringAsFixed(0)}°)';

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
          color: _isSaving ? Colors.grey.withOpacity(0.5) : Colors.white.withOpacity(0.9),
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
