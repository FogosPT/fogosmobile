import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

abstract class BaseMarker implements StatefulWidget{

  final Point location;

  BaseMarker(this.location);
}

abstract class BaseMarkerState<T extends StatefulWidget> extends State<T> {

  Point getCoordinates();

  void updatePosition(ScreenCoordinate point);
}
