import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/utils/haversine.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'ar_compass_math.dart';
import 'ar_fire_overlay.dart';

class ArViewScreen extends StatefulWidget {
  const ArViewScreen({Key? key}) : super(key: key);

  @override
  State<ArViewScreen> createState() => _ArViewScreenState();
}

class _ArViewScreenState extends State<ArViewScreen> {
  // Camera
  CameraController? _cameraController;
  bool _cameraReady = false;
  bool _cameraDenied = false;

  // Sensors (low-pass filtered)
  static const _alpha = 0.15;
  List<double> _accel = [0, 0, 9.8];
  List<double> _mag = [0, 1, 0];
  double _deviceHeading = 0;
  double _devicePitch = 0;
  StreamSubscription<AccelerometerEvent>? _accelSub;
  StreamSubscription<MagnetometerEvent>? _magSub;

  // Location
  double? _userLat;
  double? _userLng;
  bool _locationDenied = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _initCamera();
    _initLocation();
    _initSensors();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    _accelSub?.cancel();
    _magSub?.cancel();
    _cameraController?.dispose();
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
      ResolutionPreset.medium,
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
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (mounted) setState(() => _locationDenied = true);
      return;
    }
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 10),
        ),
      );
      if (mounted) {
        setState(() {
          _userLat = pos.latitude;
          _userLng = pos.longitude;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _locationDenied = true);
    }
  }

  void _initSensors() {
    _accelSub =
        accelerometerEventStream(samplingPeriod: SensorInterval.uiInterval).listen((e) {
      _accel = [
        _alpha * e.x + (1 - _alpha) * _accel[0],
        _alpha * e.y + (1 - _alpha) * _accel[1],
        _alpha * e.z + (1 - _alpha) * _accel[2],
      ];
      _recomputeHeading();
    });
    _magSub =
        magnetometerEventStream(samplingPeriod: SensorInterval.uiInterval).listen((e) {
      _mag = [
        _alpha * e.x + (1 - _alpha) * _mag[0],
        _alpha * e.y + (1 - _alpha) * _mag[1],
        _alpha * e.z + (1 - _alpha) * _mag[2],
      ];
      _recomputeHeading();
    });
  }

  void _recomputeHeading() {
    final (az, pitch) = computeHeadingAndPitch(_accel, _mag);
    if ((az - _deviceHeading).abs() > 0.5 || (pitch - _devicePitch).abs() > 0.5) {
      setState(() {
        _deviceHeading = az;
        _devicePitch = pitch;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraDenied) return _buildPermissionDenied();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_cameraReady && _cameraController != null)
            CameraPreview(_cameraController!)
          else
            const Center(
                child: CircularProgressIndicator(color: Colors.white)),
          if (_cameraReady) _buildFireOverlays(),
          _buildCloseButton(),
          if (_cameraReady && _locationDenied) _buildLocationBanner(),
        ],
      ),
    );
  }

  Widget _buildFireOverlays() {
    if (_userLat == null || _userLng == null) {
      return const SizedBox.shrink();
    }

    final size = MediaQuery.of(context).size;

    return StoreConnector<AppState, List<Fire>>(
      converter: (store) => store.state.fires,
      builder: (context, fires) {
        const maxRadius = 50.0;
        const cardWidth = 160.0;
        const cardHeight = 68.0;

        // Build and sort overlays by distance (closest on top)
        final visible = <({Fire fire, double dist, double x, double y})>[];

        for (final fire in fires) {
          final dist = haversineKm(_userLat!, _userLng!, fire.lat, fire.lng);
          if (dist > maxRadius) continue;

          final bearing = bearingTo(_userLat!, _userLng!, fire.lat, fire.lng);
          final relBearing = ((bearing - _deviceHeading) + 360) % 360;
          // Detection FOV is wider than the camera FOV to account for fire
          // spread — the registered coordinate is the ignition point, but the
          // actual smoke column may be several km away from it.
          final x = projectToScreenX(relBearing, size.width, fovDeg: 100.0);
          if (x == null) continue;

          final y = projectToScreenY(_devicePitch, size.height);
          visible.add((
            fire: fire,
            dist: dist,
            x: x.clamp(0.0, size.width - cardWidth),
            y: y.clamp(60.0, size.height - cardHeight - 40),
          ));
        }

        if (visible.isEmpty) {
          return Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(child: _buildBanner('Sem incêndios nos 50 km à volta')),
          );
        }

        // Sort descending by distance so the closest renders last (on top)
        visible.sort((a, b) => b.dist.compareTo(a.dist));

        return Stack(
          children: visible
              .map((v) => Positioned(
                    left: v.x,
                    top: v.y,
                    child: ArFireOverlay(fire: v.fire, distanceKm: v.dist),
                  ))
              .toList(),
        );
      },
    );
  }

  Widget _buildLocationBanner() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Center(child: _buildBanner('Localização não disponível')),
    );
  }

  Widget _buildBanner(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.65),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text,
          style: const TextStyle(color: Colors.white, fontSize: 14)),
    );
  }

  Widget _buildCloseButton() {
    return Positioned(
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
    );
  }

  Widget _buildPermissionDenied() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.camera_alt_outlined,
                  size: 64, color: Colors.white38),
              const SizedBox(height: 16),
              const Text(
                'Acesso à câmara necessário',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
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
                child: const Text('Voltar',
                    style: TextStyle(color: Colors.white54)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
