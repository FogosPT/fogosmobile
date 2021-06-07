import 'package:fogosmobile/models/fire.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

abstract class BaseMapboxModel {
  final String id;

  final LatLng latlng;

  BaseMapboxModel(this.latlng, this.id);

  LatLng get location => this.latlng;

  String get getId => this.id;

  /// Case this object has a status same as the filter, it should not be shown
  bool filter<T>(List<T> filters);

}
