import 'package:flutter/material.dart';

class FireGradientAppBar extends AppBar {
  FireGradientAppBar({Text title, List<Widget> actions, TabBar bottom})
      : super(
          title: title,
          backgroundColor: Colors.white,
          elevation: 0.5,
          actions: actions,
          bottom: bottom,
          flexibleSpace: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    Colors.orange,
                    Colors.red,
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
          ),
        );
}
