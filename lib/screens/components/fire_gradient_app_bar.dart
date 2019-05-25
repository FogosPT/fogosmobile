import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/models/app_state.dart';

class FireGradientAppBar extends AppBar {
  FireGradientAppBar({Text title, List<StoreConnector<AppState, VoidCallback>> actions, TabBar bottom})
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
