import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/screens/utils/widget_utils.dart';

class ArFireOverlay extends StatelessWidget {
  final Fire fire;
  final double distanceKm;

  const ArFireOverlay({Key? key, required this.fire, required this.distanceKm})
      : super(key: key);

  String get _distanceStr => distanceKm < 1
      ? '${(distanceKm * 1000).round()} m'
      : '${distanceKm.toStringAsFixed(1)} km';

  @override
  Widget build(BuildContext context) {
    final fireColor = getFireColor(fire);
    return Container(
      constraints: const BoxConstraints(maxWidth: 160),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.75),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: fireColor.withOpacity(0.7), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            getCorrectStatusImage(fire.statusCode, fire.important),
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(fireColor, BlendMode.srcIn),
          ),
          const SizedBox(width: 8),
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
                      fontSize: 11, color: Colors.white.withOpacity(0.7)),
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
    );
  }
}
