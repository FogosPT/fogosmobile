import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/models/modis.dart';
import 'package:fogosmobile/screens/utils/widget_utils.dart';
import 'package:fogosmobile/store/app_store.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class ModiisMarker extends StatefulWidget {
  final Point _initialPosition;
  final LatLng _coordinate;
  final void Function(ModiisMarkerState) _addMarkerState;
  final void Function() _openModal;

  ModiisMarker(
    String key,
    this._coordinate,
    this._initialPosition,
    this._addMarkerState,
    this._openModal,
  ) : super(key: Key(key));

  @override
  State<StatefulWidget> createState() {
    final state = ModiisMarkerState(_initialPosition, _openModal);
    _addMarkerState(state);
    return state;
  }
}

class ModiisMarkerState extends State {
  final _iconSize = 10.0;

  Point _position;
  void Function() _openModal;

  ModiisMarkerState(this._position, this._openModal);

  @override
  Widget build(BuildContext context) {
    var ratio = 1.0;

    if (!kIsWeb) {
      ratio = Platform.isIOS ? 1.0 : MediaQuery.of(context).devicePixelRatio;
    }

    return Positioned(
      left: _position.x / ratio - _iconSize / 2,
      top: _position.y / ratio - _iconSize / 2,
      child: GestureDetector(
        onTap: () => _openModal?.call(),
        child: Container(
          decoration:
              BoxDecoration(color: Colors.amberAccent, shape: BoxShape.circle),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "M",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void updatePosition(Point<num> point) {
    setState(() {
      _position = point;
    });
  }

  LatLng getCoordinate() {
    return (widget as ModiisMarker)._coordinate;
  }
}
