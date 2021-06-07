import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class ViirsMarker extends StatefulWidget {
  final Point _initialPosition;
  final LatLng _coordinate;
  final void Function(ViirsMarkerState) _addMarkerState;
  final void Function() _openModal;

  ViirsMarker(
    String key,
    this._coordinate,
    this._initialPosition,
    this._addMarkerState,
    this._openModal,
  ) : super(key: Key(key));

  @override
  State<StatefulWidget> createState() {
    final state = ViirsMarkerState(_initialPosition, _openModal);
    _addMarkerState(state);
    return state;
  }
}

class ViirsMarkerState extends State {
  final _iconSize = 10.0;

  Point _position;
  void Function() _openModal;

  ViirsMarkerState(this._position, this._openModal);

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
        child: new Container(
          decoration:
              BoxDecoration(color: Colors.amberAccent, shape: BoxShape.circle),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "V",
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
    return (widget as ViirsMarker)._coordinate;
  }
}
