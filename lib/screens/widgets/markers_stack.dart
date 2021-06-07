import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fogosmobile/models/base_location_model.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/screens/widgets/mapbox_markers/marker_base.dart';
import 'package:fogosmobile/screens/widgets/mapbox_markers/marker_fire.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MarkerStack<T extends BaseMapboxModel, V extends BaseMarker,
    S extends State> extends StatelessWidget {
  final bool ignoreTouch;

  final MapboxMapController mapController;

  final List<T> data;

  final void Function() openModal;

  final Map<String, Widget> _markers;

  final List<S> _markerStates;

  MarkerStack({
    @required this.mapController,
    @required this.data,
    this.ignoreTouch = false,
    this.openModal,
    Key key,
  })  : this._markers = {},
        this._markerStates = [],
  assert(data != null, 'Data passed cannot be null'),
  assert(mapController != null, 'MapController needs to be initialized'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final latLngs = data.map<LatLng>((item) => item.location).toList();
    mapController.toScreenLocationBatch(latLngs).then((value) {
      value.asMap().forEach((index, value) {
        final point = Point<double>(value.x as double, value.y as double);
        final latLng = latLngs[index];
        final item = data[index];
        _addMarker(item, latLng, point);
      });
    });

    return IgnorePointer(
      ignoring: ignoreTouch,
      child: Stack(
        children: _markers.values.toList(),
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
            print('oi');
          },
          () {
           // openModal?.call();
          },
        );
        _markers.putIfAbsent(item.getId, () => value);
    }
  }
}
