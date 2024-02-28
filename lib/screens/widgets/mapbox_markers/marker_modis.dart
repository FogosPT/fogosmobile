import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fogosmobile/models/modis.dart';
import 'package:fogosmobile/screens/widgets/mapbox_markers/marker_base.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class ModisMarker extends StatefulWidget implements BaseMarker {
  final Modis _modis;
  final Point _initialPosition;
  final LatLng _coordinate;
  final void Function(ModisMarkerState) _addMarkerState;
  final void Function(Modis) _openModal;

  ModisMarker(
    String key,
    this._modis,
    this._coordinate,
    this._initialPosition,
    this._addMarkerState,
    this._openModal,
  ) : super(key: Key(key));

  @override
  LatLng get location => _coordinate;

  @override
  State<StatefulWidget> createState() {
    final state = ModisMarkerState();
    _addMarkerState(state);
    return state;
  }
}

class ModisMarkerState extends BaseMarkerState<ModisMarker> {
  final _iconSize = 10.0;

  Point _position = Point(0, 0);

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
        onTap: () => widget._openModal.call(widget._modis),
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

  @override
  LatLng getCoordinates() {
    return widget._coordinate;
  }

  @override
  void initState() {
    _position = widget._initialPosition;
    super.initState();
  }

  @override
  void updatePosition(Point<num> point) {
    setState(() {
      _position = point;
    });
  }
}
