import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:warnings/markers/marker_importance.dart';
import 'package:warnings/markers/warning_marker_widget.dart';

enum WarningMarkerType {
  important,
  fire,
  alarm,
  watch,
  pointer,
  fake,
  unknown;

  String get icon {
    switch (this) {
      case WarningMarkerType.fire:
        return 'assets/icons/ico_fire.svg';
      case WarningMarkerType.pointer:
        return 'assets/icons/ico_pointer.svg';
      case WarningMarkerType.important:
        return 'assets/icons/ico_fire.svg';
      case WarningMarkerType.alarm:
        return 'assets/icons/ico_alarm.svg';
      case WarningMarkerType.watch:
        return 'assets/icons/ico_watch.svg';
      case WarningMarkerType.fake:
        return 'assets/icons/ico_fake.svg';
      case WarningMarkerType.unknown:
        return 'assets/icons/ico_fire.svg';
    }
  }
}

class WarningMarker extends Marker {
  WarningMarker({
    required super.point,
    required WarningMarkerType type,
    required MarkerImportance importance,
    required Color color,
  }) : super(
          child: WarningMarkerWidget(
            type: type,
            color: color,
          ),
          width: importance.size,
          height: importance.size,
        );
}
