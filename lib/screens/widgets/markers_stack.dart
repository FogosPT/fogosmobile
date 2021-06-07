import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fogosmobile/models/base_location_model.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/screens/widgets/mapbox_markers/marker_base.dart';
import 'package:fogosmobile/screens/widgets/mapbox_markers/marker_fire.dart';
import 'package:mapbox_gl/mapbox_gl.dart';


class MarkerStack<T extends BaseMapboxModel, V extends BaseMarker,
    B extends BaseMarkerState, F> extends StatefulWidget {
  final bool ignoreTouch;

  final MapboxMapController mapController;

  final List<T> data;

  final void Function() openModal;

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
        super(key: key);

  @override
  _MarkerStackState createState() => _MarkerStackState<T, V, B, F>();

  void updatePositions() {
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
}

class _MarkerStackState<T extends BaseMapboxModel, V extends BaseMarker,
    B extends BaseMarkerState, F> extends State<MarkerStack> {
  @override
  Widget build(BuildContext context) {
    final latLngs =
        widget.data?.skipWhile((value) => value.filter<F>(widget.filters))?.map<LatLng>((item) => item.location)?.toList() ?? [];
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
    switch (V) {
      case FireMarker:
        var value = FireMarker(
          item.getId,
          item as Fire,
          item.location,
          point,
          (state) {
            widget._markerStates.add(state);
          },
          () {
            widget.openModal?.call();
          },
        );
        widget._markers.putIfAbsent(item.getId, () => value);
    }
  }
}
