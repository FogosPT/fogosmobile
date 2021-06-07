import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

abstract class BaseMarker implements StatefulWidget{

  final LatLng location;

  BaseMarker(this.location);
}

class BaseMarkerStates {}
