import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fogosmobile/models/base_location_model.dart';
import 'package:fogosmobile/models/contributor.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/models/modis.dart';
import 'package:fogosmobile/models/viirs.dart';
import 'package:fogosmobile/screens/widgets/mapbox_markers/marker_base.dart';
import 'package:fogosmobile/screens/widgets/mapbox_markers/marker_fire.dart';
import 'package:fogosmobile/screens/widgets/mapbox_markers/marker_modis.dart';
import 'package:fogosmobile/screens/widgets/mapbox_markers/marker_viirs.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MarkerStack<T extends BaseMapboxModel, V extends BaseMarker,
    B extends BaseMarkerState, F> extends StatefulWidget {
  final bool ignoreTouch;

  final MapboxMapController mapController;

  final List<T> data;

  final void Function(dynamic item) openModal;

  final Map<String, Widget> _markers;

  final List<B> _markerStates;

  final List<F> filters;

  MarkerStack({
    @required this.mapController,
    @required this.data,
    this.ignoreTouch = false,
    this.openModal,
    this.filters,
    Key key,
  })  : this._markers = {},
        this._markerStates = [],
        super(key: key) {
    this.mapController?.addListener(() {
      if(mapController.isCameraMoving){
       updatePositions();
      }
    });
  }

  void updatePositions() async {
    final latLngs = <LatLng>[];
    for (final markerState in _markerStates) {
      latLngs.add(markerState.getCoordinates());
    }

    mapController?.toScreenLocationBatch(latLngs)?.then((points) {
      _markerStates.asMap().forEach((index, _) {
        _markerStates[index].updatePosition(points[index]);
      });
    });
  }

  @override
  _MarkerStackState createState() => _MarkerStackState<T, V, B, F>();


}

class _MarkerStackState<T extends BaseMapboxModel, V extends BaseMarker,
    B extends BaseMarkerState, F> extends State<MarkerStack> {
  @override
  Widget build(BuildContext context) {
    final latLngs = widget.data
            ?.skipWhile((value) => value.skip<F>(widget.filters))
            ?.map<LatLng>((item) => item.location)
            ?.toList() ??
        [];
    widget.mapController?.toScreenLocationBatch(latLngs)?.then((value) {
      value.asMap().forEach((index, value) {
        final point = Point<double>(value.x as double, value.y as double);
        final latLng = latLngs[index];
        final item = widget.data[index];
        _addMarker(item, latLng, point);
      });

      setState(() {});
    });

    return IgnorePointer(
      ignoring: widget.ignoreTouch,
      child: Stack(
        children: widget._markers.values.toList(),
      ),
    );
  }

  void _addMarker(T item, LatLng latLng, Point<double> point) {
    var value;
    switch (V) {
      case ViirsMarker:
        value = ViirsMarker(
          item.getId,
          item as Viirs,
          item.location,
          point,
          _addMarkerState,
          _openModal,
        );
        break;
      case ModisMarker:
        value = ModisMarker(
          item.getId,
          item as Modis,
          item.location,
          point,
          _addMarkerState,
          _openModal,
        );
        break;
      case FireMarker:
        value = FireMarker(
          item.getId,
          item as Fire,
          item.location,
          point,
          _addMarkerState,
          _openModal,
        );
        break;
    }

    if(value != null){
      widget._markers.putIfAbsent(item.getId, () => value);
    }
  }

  void _openModal(dynamic item) {
    widget.openModal?.call(item);
  }

  void _addMarkerState(state) {
    widget._markerStates.add(state);
  }
}
