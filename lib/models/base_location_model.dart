import 'package:mapbox_gl/mapbox_gl.dart';

abstract class BaseMapboxModel {
  final String id;

  final LatLng latlng;

  BaseMapboxModel(this.latlng, this.id);

  LatLng get location => this.latlng;

  String get getId => this.id;

}
