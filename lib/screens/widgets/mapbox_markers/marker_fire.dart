import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/constants/variables.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/screens/utils/widget_utils.dart';
import 'package:fogosmobile/screens/widgets/mapbox_markers/marker_base.dart';
import 'package:fogosmobile/store/app_store.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class FireMarker extends StatefulWidget implements BaseMarker {
  final Fire _fire;
  final ScreenCoordinate _initialPosition;
  final Point _coordinate;
  final void Function(FireMarkerState) _addMarkerState;
  final void Function(Fire) _openModal;

  FireMarker(
    String key,
    this._fire,
    this._coordinate,
    this._initialPosition,
    this._addMarkerState,
    this._openModal,
  )   : assert(_coordinate != null),
        assert(_initialPosition != null),
        assert(_fire != null),
        super(key: Key(key));

  @override
  State<StatefulWidget> createState() {
    final state = FireMarkerState();
    _addMarkerState(state);
    return state;
  }

  @override
  Point get location => _coordinate;
}

class FireMarkerState extends BaseMarkerState<FireMarker> {
  final _iconSize = 10.0;

  late ScreenCoordinate _position;

  @override
  void initState() {
    _position = widget._initialPosition;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.x - _getIconSize(widget._fire.scale) / 2,
      top: _position.y - _getIconSize(widget._fire.scale) / 2,
      child: Container(
        decoration: BoxDecoration(
            color: getFireColor(widget._fire), shape: BoxShape.circle),
        child: IconButton(
          iconSize: _getIconSize(widget._fire.scale),
          icon: SvgPicture.asset(
            getCorrectStatusImage(
                widget._fire.statusCode, widget._fire.important),
            semanticsLabel: 'Fire Marker',
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          onPressed: () {
            store.dispatch(ClearFireAction());
            store.dispatch(LoadFireAction(widget._fire.id));
            widget._openModal?.call(widget._fire);
          },
        ),
      ),
    );
  }

  @override
  void updatePosition(ScreenCoordinate point) {
    if(mounted) {
      setState(() {
        _position = point;
      });
    }
  }

  @override
  Point getCoordinates() {
    return widget._coordinate;
  }

  double _getIconSize(double scale) {
    double pinSize = fullPinSize * scale;

    if (pinSize == 0) {
      pinSize = fullPinSize;
    }
    return pinSize;
  }
}
