import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:warnings/markers/warning_marker.dart';

class WarningMarkerWidget extends StatelessWidget {
  final WarningMarkerType type;
  final Color color;

  const WarningMarkerWidget({
    super.key,
    required this.type,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
