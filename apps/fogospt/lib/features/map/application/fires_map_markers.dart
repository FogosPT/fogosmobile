import 'package:flutter/material.dart';
import 'package:fogos_api/features/latest_warnings/domain/fire.dart';
import 'package:warnings/markers/warning_marker.dart';

typedef MarkerTapped = void Function(Fire fire);

class FiresMapMarkers {
  final List<WarningMarker> activeWarnings;

  final MarkerTapped onMarkerTapped;

  final Widget markerIcon;

  static const _defaultMarkerIcon = Icon(
    Icons.fireplace,
    color: Colors.red,
  );

  FiresMapMarkers({
    required this.activeWarnings,
    required this.onMarkerTapped,
    this.markerIcon = _defaultMarkerIcon,
  });
}

int hexToInteger(String hex) => int.parse('FF$hex', radix: 16);

extension StringColorExtensions on String {
  Color toFiresMapMarkerColor() => Color(hexToInteger(this));
}
