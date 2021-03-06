import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

abstract class BaseMarker implements StatefulWidget{

  final LatLng location;

  BaseMarker(this.location);
}

abstract class BaseMarkerState<T extends StatefulWidget> extends State<T> {

  LatLng getCoordinates();

  void updatePosition(Point<num> point);
}
