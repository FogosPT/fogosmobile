import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fogosmobile/models/base_location_model.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

ModisResult modisFromJson(String str) => ModisResult.fromJson(json.decode(str));

String modisToJson(ModisResult data) => json.encode(data.toJson());

class ModisResult {
  ModisResult({
    this.modis,
  });

  Modis modis;

  factory ModisResult.fromJson(Map<String, dynamic> json) => ModisResult(
        modis: Modis.fromJson(json["1"]),
      );

  Map<String, dynamic> toJson() => {
        "1": modis.toJson(),
      };

  static List<Modis> fromMap(Map<String, dynamic> obj) {
    if (obj == null || obj.values == null) {
      return [];
    }

    return obj.values.map((map) => Modis.fromJson(map)).toList();
  }
}

class Modis extends BaseMapboxModel implements Equatable {
  Modis({
    this.latitude,
    this.longitude,
    this.brightness,
    this.scan,
    this.track,
    this.acqDate,
    this.acqTime,
    this.satellite,
    this.confidence,
    this.version,
    this.brightT31,
    this.frp,
    this.daynight,
  }) : super(LatLng(latitude, longitude), '$latitude');

  double latitude;
  double longitude;
  String brightness;
  String scan;
  String track;
  DateTime acqDate;
  String acqTime;
  String satellite;
  String confidence;
  String version;
  String brightT31;
  String frp;
  String daynight;

  factory Modis.fromJson(Map<String, dynamic> json) => Modis(
        latitude:
            json["latitude"] != null ? double.tryParse(json["latitude"]) : null,
        longitude: json["latitude"] != null
            ? double.tryParse(json["longitude"])
            : null,
        brightness: json["brightness"],
        scan: json["scan"],
        track: json["track"],
        acqDate:
            json["acq_date"] != null ? DateTime.parse(json["acq_date"]) : null,
        acqTime: json["acq_time"],
        satellite: json["satellite"],
        confidence: json["confidence"],
        version: json["version"],
        brightT31: json["bright_t31"],
        frp: json["frp"],
        daynight: json["daynight"],
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "brightness": brightness,
        "scan": scan,
        "track": track,
        "acq_date":
            "${acqDate.year.toString().padLeft(4, '0')}-${acqDate.month.toString().padLeft(2, '0')}-${acqDate.day.toString().padLeft(2, '0')}",
        "acq_time": acqTime,
        "satellite": satellite,
        "confidence": confidence,
        "version": version,
        "bright_t31": brightT31,
        "frp": frp,
        "daynight": daynight,
      };

  @override
  List<Object> get props => [
        latitude,
        longitude,
        brightness,
        scan,
        track,
        acqDate,
        acqTime,
        satellite,
        confidence,
        version,
        brightT31,
        frp,
        daynight,
      ];

  @override
  bool get stringify => true;

  @override
  bool filter<T>(List<T> filters) {
    return latitude != null && longitude != null;
  }
}
