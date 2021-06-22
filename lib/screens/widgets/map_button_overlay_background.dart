import 'package:flutter/material.dart';

class MapButtonOverlayBackground extends StatelessWidget {
  final Widget child;

  const MapButtonOverlayBackground({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(14.0)),
        color: Colors.white54,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: child,
      ),
    );
  }
}
