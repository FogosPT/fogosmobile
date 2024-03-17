import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fogosmobile/models/base_location_model.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

ModisResult modisFromJson(String str) => ModisResult.fromJson(json.decode(str));

String modisToJson(ModisResult data) => json.encode(data.toJson());

class Modis extends BaseMapboxModel implements Equatable {
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
  Modis({
    required this.latitude,
    required this.longitude,
    required this.brightness,
    required this.scan,
    required this.track,
    required this.acqDate,
    required this.acqTime,
    required this.satellite,
    required this.confidence,
    required this.version,
    required this.brightT31,
    required this.frp,
    required this.daynight,
  }) : super(LatLng(latitude ?? 0, longitude ?? 0), '$latitude');

  factory Modis.fromJson(Map<String, dynamic> json) => Modis(
        latitude: json["latitude"] != null
            ? double.tryParse(json["latitude"]) ?? 0.0
            : 0.0,
        longitude: json["latitude"] != null
            ? double.tryParse(json["longitude"]) ?? 0.0
            : 0.0,
        brightness: json["brightness"],
        scan: json["scan"],
        track: json["track"],
        acqDate: json["acq_date"] != null
            ? DateTime.parse(json["acq_date"])
            : DateTime.now(),
        acqTime: json["acq_time"],
        satellite: json["satellite"],
        confidence: json["confidence"],
        version: json["version"],
        brightT31: json["bright_t31"],
        frp: json["frp"],
        daynight: json["daynight"],
      );

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
  bool skip<T>(List<T> filters) {
    return !(longitude != null);
  }

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
}

class ModisResult {
  Modis modis;

  ModisResult({required this.modis});

  factory ModisResult.fromJson(Map<String, dynamic> json) => ModisResult(
        modis: Modis.fromJson(json["1"]),
      );

  Map<String, dynamic> toJson() => {"1": modis.toJson()};

  static List<Modis> fromMap(Map<String, dynamic> obj) {
    return obj.values.map((map) => Modis.fromJson(map)).toList();
  }
}
