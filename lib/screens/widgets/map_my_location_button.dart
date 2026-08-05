import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'
    show Geolocator, LocationAccuracy, LocationSettings;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' hide LocationSettings;
import 'package:permission_handler/permission_handler.dart';

/// Floating map button that centres the map on the user's current location.
///
/// Handles the full flow: prompt for permission if needed, check that the
/// system location service is on, fetch the position, enable the map's
/// location puck, then fly the camera there. Errors surface as a snackbar so
/// the user can act on them.
class MapMyLocationButton extends StatefulWidget {
  /// Provider for the current [MapboxMap] instance. Called each tap so the
  /// widget stays valid across map re-creations (e.g. style reloads).
  final MapboxMap? Function() mapProvider;

  /// Zoom level to fly to. Defaults to a street-level 14.
  final double zoom;

  const MapMyLocationButton({
    super.key,
    required this.mapProvider,
    this.zoom = 14.0,
  });

  @override
  State<MapMyLocationButton> createState() => _MapMyLocationButtonState();
}

class _MapMyLocationButtonState extends State<MapMyLocationButton> {
  bool _busy = false;

  Future<void> _handleTap() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      var status = await Permission.locationWhenInUse.status;
      if (!status.isGranted) {
        status = await Permission.locationWhenInUse.request();
      }
      if (!status.isGranted) {
        _showMessage(status.isPermanentlyDenied
            ? 'Ativa a permissão de localização nas definições.'
            : 'Permissão de localização negada.');
        return;
      }

      final serviceOn = await Geolocator.isLocationServiceEnabled();
      if (!serviceOn) {
        _showMessage('Ativa a localização no dispositivo.');
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 8),
        ),
      );

      final map = widget.mapProvider();
      if (map == null || !mounted) return;

      try {
        await map.location.updateSettings(LocationComponentSettings(
          enabled: true,
          puckBearingEnabled: true,
        ));
      } catch (_) {}

      await map.flyTo(
        CameraOptions(
          center: Point(coordinates: Position(pos.longitude, pos.latitude)),
          zoom: widget.zoom,
        ),
        MapAnimationOptions(duration: 1200),
      );
    } catch (_) {
      _showMessage('Não foi possível obter a localização.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showMessage(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), duration: const Duration(seconds: 3)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: _handleTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: _busy
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xffff512f),
                  ),
                )
              : const Icon(
                  Icons.my_location,
                  color: Color(0xffff512f),
                  size: 22,
                ),
        ),
      ),
    );
  }
}
