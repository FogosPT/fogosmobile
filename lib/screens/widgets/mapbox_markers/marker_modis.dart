import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fogosmobile/models/modis.dart';
import 'package:fogosmobile/screens/widgets/mapbox_markers/marker_base.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class ModisMarker extends StatefulWidget implements BaseMarker{
  final Modis _modis;
  final ScreenCoordinate _initialPosition;
  final Point _coordinate;
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
  State<StatefulWidget> createState() {
    final state = ModisMarkerState();
    _addMarkerState(state);
    return state;
  }

  @override
  Point get location => _coordinate;
}

class ModisMarkerState extends BaseMarkerState<ModisMarker>{
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
        onTap: () => widget._openModal?.call(widget._modis),
        child: Container(
          decoration:
              BoxDecoration(color: Color(0xffF7B267), shape: BoxShape.circle),
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
