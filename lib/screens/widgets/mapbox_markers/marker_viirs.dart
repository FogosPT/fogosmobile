import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fogosmobile/models/viirs.dart';
import 'package:fogosmobile/screens/widgets/mapbox_markers/marker_base.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class ViirsMarker extends StatefulWidget implements BaseMarker{
  final Viirs _viirs;
  final ScreenCoordinate _initialPosition;
  final Point _coordinate;
  final void Function(ViirsMarkerState) _addMarkerState;
  final void Function(Viirs) _openModal;

  ViirsMarker(
    String key,
    this._viirs,
    this._coordinate,
    this._initialPosition,
    this._addMarkerState,
    this._openModal,
  ) : super(key: Key(key));

  @override
  State<StatefulWidget> createState() {
    final state = ViirsMarkerState();
    _addMarkerState(state);
    return state;
  }

  @override
  Point get location => _coordinate;
}

class ViirsMarkerState extends BaseMarkerState<ViirsMarker> {
  final _iconSize = 14.0;

  late ScreenCoordinate _position;

  @override
  void initState() {
    _position = widget._initialPosition;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.x - _iconSize / 2,
      top: _position.y - _iconSize / 2,
      child: GestureDetector(
        onTap: () => widget._openModal?.call(widget._viirs),
        child: Container(
          decoration:
              BoxDecoration(color: Color(0xffF7B267), shape: BoxShape.circle),
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

  @override
  void updatePosition(ScreenCoordinate point) {
    setState(() {
      _position = point;
    });
  }

  @override
  Point getCoordinates() {
    return widget._coordinate;
  }
}
