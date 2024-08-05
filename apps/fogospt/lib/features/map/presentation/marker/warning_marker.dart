import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fogospt/features/map/presentation/marker/marker_importance.dart';
import 'package:latlong2/latlong.dart';

typedef MarkerTapped = void Function();

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
      child: SizedBox(
        height: 50,
        width: 50,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: SvgPicture.asset(
                height: 30,
                type.icon,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
