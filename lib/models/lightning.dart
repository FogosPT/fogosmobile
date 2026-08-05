import 'dart:convert';

import 'package:fogosmobile/models/base_location_model.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

LightningRemote lightningFromJson(String str) => LightningRemote.fromJson(json.decode(str));

String lightningToJson(LightningRemote data) => json.encode(data.toJson());

class LightningRemote {
  LightningRemote({
    required this.data,
  });

  List<Lightning> data;

  factory LightningRemote.fromJson(Map<String, dynamic> json) => LightningRemote(
        data: List<Lightning>.from(json["data"].map((x) => Lightning.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };

  static List<LightningRemote> fromList(List<dynamic> obj) {
    return obj
        .cast<Map<String, dynamic>>()
        .map((data) => LightningRemote.fromJson(data))
        .toList();
  }
}

class Lightning extends BaseMapboxModel {
  Lightning({
    required this.timestamp,
    required this.payload,
  }): super(Point(coordinates: Position(payload.longitude, payload.latitude)), timestamp);

  String timestamp;
  LightningData payload;

  factory Lightning.fromJson(Map<String, dynamic> json) => Lightning(
        timestamp: json["timestamp"] ?? '',
        payload: LightningData.fromJson(json["payload"]),
      );

  Map<String, dynamic> toJson() => {
        "timestamp": timestamp,
        "payload": payload.toJson(),
      };

  @override
  bool skip<T>(List<T>? filters) {
    return payload.latitude == 0.0 && payload.longitude == 0.0;
  }
}

class LightningData {
  LightningData({
    this.latitude = 0.0,
    this.amplitude = 0.0,
    this.longitude = 0.0,
  });

  double latitude;
  double amplitude;
  double longitude;

  factory LightningData.fromJson(Map<String, dynamic> json) => LightningData(
        latitude: (json["latitude"] ?? 0.0).toDouble(),
        amplitude: (json["amplitude"] ?? 0.0).toDouble(),
        longitude: (json["longitude"] ?? 0.0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "amplitude": amplitude,
        "longitude": longitude,
      };
}
