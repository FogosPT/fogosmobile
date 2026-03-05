import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fogosmobile/constants/variables.dart';
import 'package:fogosmobile/screens/widgets/mapbox_markers/marker_base.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class LightningMarker extends StatefulWidget implements BaseMarker {
  final ScreenCoordinate _initialPosition;
  final Point _coordinate;
  final void Function(LightningMarkerState) _addMarkerState;
  final void Function() _openModal;

  LightningMarker(
    String key,
    this._coordinate,
    this._initialPosition,
    this._addMarkerState,
    this._openModal,
  ) : super(key: Key(key));

  @override
  State<StatefulWidget> createState() {
    final state = LightningMarkerState(_initialPosition, _openModal);
    _addMarkerState(state);
    return state;
  }

  @override
  Point get location => _coordinate;
}

class LightningMarkerState extends BaseMarkerState<LightningMarker> {
  late ScreenCoordinate _position;
  void Function() _openModal;

  LightningMarkerState(this._position, this._openModal);

  @override
  Widget build(BuildContext context) {
    final pinSize = fullPinSize * 0.33;

    return Positioned(
      left: _position.x - pinSize / 2,
      top: _position.y - pinSize / 2,
      child: Container(
        decoration:
            BoxDecoration(color: Colors.purpleAccent, shape: BoxShape.circle),
        child: IconButton(
          icon: Center(
            child: FaIcon(
              FontAwesomeIcons.bolt,
              size: pinSize,
              color: Colors.white,
            ),
          ),
          onPressed: () {
            _openModal?.call();
          },
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
