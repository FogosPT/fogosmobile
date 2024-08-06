import 'package:flutter_map/flutter_map.dart';
import 'package:fogospt/constants/env.dart';
import 'package:latlong2/latlong.dart';

const LatLng centerOfPortugal = LatLng(39.3999, -8.2245);
const double initialZoom = 6.5;

class FlutterMapConfiguration {
  static MapOptions getMapOptions() {
    return MapOptions(
      initialCenter: centerOfPortugal,
      initialZoom: initialZoom,
      interactionOptions: InteractionOptions(
        rotationThreshold: 0.0,
        rotationWinGestures: MultiFingerGesture.none,
      ),
      // cameraConstraint: CameraConstraint.contain(
      //   bounds: LatLngBounds(
      //     LatLng(48.0, -28),
      //     LatLng(27.0, -9),
      //   ),
      // ),
      // initialCameraFit: CameraFit.coordinates(coordinates: [
      //   LatLng(48.0, -28),
      //   LatLng(27.0, -9),
      // ]),
    );
  }

  static TileLayer getTileLayer() {
    return TileLayer(
      urlTemplate:
          "https://api.mapbox.com/styles/v1/fogospt/{id}/tiles/256/{z}/{x}/{y}?access_token={accessToken}",
      additionalOptions: {
        "accessToken": Env.mapboxAccessToken,
        'id': Env.mapboxAccessId,
      },
      retinaMode: true,
    );
  }
}
