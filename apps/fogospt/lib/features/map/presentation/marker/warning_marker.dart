import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fogospt/features/map/presentation/marker/marker_importance.dart';
import 'package:latlong2/latlong.dart';

typedef MarkerTapped = void Function();

enum WarningMarkerType {
  fire,
  other;

  String get icon {
    switch (this) {
      case WarningMarkerType.fire:
        return 'assets/icons/ico_fire.svg';
      case WarningMarkerType.other:
        return 'assets/icons/ico_pointer.svg';
    }
  }

  Color get color {
    switch (this) {
      case WarningMarkerType.fire:
        return const Color(0xFFFF0000);
      case WarningMarkerType.other:
        return const Color(0xFF0000FF);
    }
  }

  from(String type) {
    switch (type) {
      case 'fire':
        return WarningMarkerType.fire;
      default:
        return WarningMarkerType.other;
    }
  }
}

class WarningMarker extends Marker {
  WarningMarker({
    required LatLng point,
    required WarningMarkerType type,
    required MarkerTapped? onTap,
    required MarkerImportance importance,
    required Color color,
  }) : super(
          child: WarningMarkerWidget(type: type, onTap: onTap, color: color),
          point: point,
          width: importance.size,
          height: importance.size,
        );
}

class WarningMarkerWidget extends StatelessWidget {
  final WarningMarkerType type;
  final MarkerTapped? onTap;
  final Color color;

  const WarningMarkerWidget({
    super.key,
    required this.type,
    this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        type.icon,
        colorFilter: ColorFilter.mode(
          color,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
