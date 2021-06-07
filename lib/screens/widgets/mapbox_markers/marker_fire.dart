import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/screens/utils/widget_utils.dart';
import 'package:fogosmobile/screens/widgets/mapbox_markers/marker_base.dart';
import 'package:fogosmobile/store/app_store.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class FireMarker extends StatefulWidget implements BaseMarker {
  final Fire _fire;
  final Point _initialPosition;
  final LatLng _coordinate;
  final void Function(FireMarkerState) _addMarkerState;
  final void Function() _openModal;

  FireMarker(
    String key,
    this._fire,
    this._coordinate,
    this._initialPosition,
    this._addMarkerState,
    this._openModal,
  ) : super(key: Key(key));

  @override
  State<StatefulWidget> createState() {
    final state = FireMarkerState(_initialPosition, _fire, _openModal);
    _addMarkerState(state);
    return state;
  }

  @override
  LatLng get location => _coordinate;
}

class FireMarkerState extends State implements BaseMarkerState{
  final _iconSize = 10.0;

  Point _position;
  Fire _fire;
  void Function() _openModal;

  FireMarkerState(this._position, this._fire, this._openModal);

  @override
  Widget build(BuildContext context) {
    var ratio = 1.0;

    if (!kIsWeb) {
      ratio = Platform.isIOS ? 1.0 : MediaQuery.of(context).devicePixelRatio;
    }

    return Positioned(
      left: _position.x / ratio - _iconSize / 2,
      top: _position.y / ratio - _iconSize / 2,
      child: Container(
        decoration:
            BoxDecoration(color: getFireColor(_fire), shape: BoxShape.circle),
        child: IconButton(
          icon: SvgPicture.asset(
            getCorrectStatusImage(_fire.statusCode, _fire.important),
            semanticsLabel: 'Fire Marker',
          ),
          onPressed: () {
            store.dispatch(ClearFireAction());
            store.dispatch(LoadFireAction(_fire.id));
            _openModal?.call();
          },
        ),
      ),
    );
  }

  @override
  void updatePosition(Point<num> point) {
    setState(() {
      _position = point;
    });
  }

  @override
  LatLng getCoordinates() {
    return (widget as FireMarker)._coordinate;
  }
}
