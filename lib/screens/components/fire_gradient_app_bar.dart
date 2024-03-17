import 'package:flutter/material.dart';
import 'package:fogosmobile/styles/theme.dart';

class FireGradientAppBar extends AppBar {
  FireGradientAppBar({
    required Text title,
    List<Widget> actions = const [],
    TabBar bottom = const TabBar(tabs: []),
  }) : super(
          title: title,
          backgroundColor: Colors.white,
          elevation: 0.5,
          actions: actions,
          bottom: bottom,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  FogosTheme().accentColor,
                  FogosTheme().primaryColor,
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
        );
}
