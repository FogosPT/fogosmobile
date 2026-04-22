import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/screens/assets/images.dart';
import 'package:fogosmobile/screens/utils/widget_utils.dart';

class ArFireOverlay extends StatelessWidget {
  final Fire fire;
  final double distanceKm;
  final VoidCallback onTap;

  const ArFireOverlay({
    Key? key,
    required this.fire,
    required this.distanceKm,
    required this.onTap,
  }) : super(key: key);

  String get _distanceStr => distanceKm < 1
      ? '${(distanceKm * 1000).round()} m'
      : '${distanceKm.toStringAsFixed(1)} km';

  @override
  Widget build(BuildContext context) {
    final fireColor = getFireColor(fire);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.75),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: fireColor.withOpacity(0.7), width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: status icon + name
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  getCorrectStatusImage(fire.statusCode, fire.important, fire.isFire),
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(fireColor, BlendMode.srcIn),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fire.city,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        fire.district,
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withOpacity(0.7)),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _distanceStr,
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xfff09819)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Means row
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _meanItem(imgSvgFireman, fire.human),
                const SizedBox(width: 10),
                _meanItem(imgSvgFireTruck, fire.terrain),
                const SizedBox(width: 10),
                _meanItem(imgSvgPlane, fire.aerial),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _meanItem(String svgPath, int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(svgPath,
            width: 14, height: 14,
            colorFilter:
                const ColorFilter.mode(Colors.white70, BlendMode.srcIn)),
        const SizedBox(width: 3),
        Text(
          count.toString(),
          style: const TextStyle(fontSize: 11, color: Colors.white70),
        ),
      ],
    );
  }
}
