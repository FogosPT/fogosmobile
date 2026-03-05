import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

abstract class BaseMapboxModel {
  final String id;

  final Point latlng;

  BaseMapboxModel(this.latlng, this.id);

  Point get location => this.latlng;

  String get getId => this.id;

  /// Case this object has a status same as the filter, it should not be shown
  bool skip<T>(List<T> filter);

}
