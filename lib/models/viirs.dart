// To parse this JSON data, do
//
//     final viirsResult = viirsResultFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fogosmobile/models/base_location_model.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

ViirsResult viirsResultFromJson(String str) =>
    ViirsResult.fromJson(json.decode(str));

String viirsResultToJson(ViirsResult data) => json.encode(data.toJson());

class Viirs extends BaseMapboxModel implements Equatable {
  double latitude;

  double longitude;
  String brightTi4;
  String scan;
  String track;
  DateTime acqDate;
  String acqTime;
  String satellite;
  String confidence;
  String version;
  String brightTi5;
  String frp;
  String daynight;
  Viirs({
    required this.latitude,
    required this.longitude,
    required this.brightTi4,
    required this.scan,
    required this.track,
    required this.acqDate,
    required this.acqTime,
    required this.satellite,
    required this.confidence,
    required this.version,
    required this.brightTi5,
    required this.frp,
    required this.daynight,
  }) : super(LatLng(latitude, longitude), '$latitude');

  factory Viirs.fromJson(Map<String, dynamic> json) => Viirs(
        latitude: json["latitude"] != null
            ? double.tryParse(json["latitude"]) ?? 0.0
            : 0.0,
        longitude: json["latitude"] != null
            ? double.tryParse(json["longitude"]) ?? 0.0
            : 0.0,
        brightTi4: json["bright_ti4"],
        scan: json["scan"],
        track: json["track"],
        acqDate: json["acq_date"] != null
            ? DateTime.parse(json["acq_date"])
            : DateTime.now(),
        acqTime: json["acq_time"],
        satellite: json["satellite"],
        confidence: json["confidence"],
        version: json["version"],
        brightTi5: json["bright_ti5"],
        frp: json["frp"],
        daynight: json["daynight"],
      );

  @override
  List<Object> get props => [
        latitude,
        longitude,
        brightTi4,
        scan,
        track,
        acqDate,
        acqTime,
        satellite,
        confidence,
        version,
        brightTi5,
        frp,
        daynight,
      ];

  @override
  bool get stringify => true;

  @override
  bool skip<T>(List<T> filters) {
    return !(longitude != null) && !(latitude != 0.0 && longitude != 0.0);
  }

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "bright_ti4": brightTi4,
        "scan": scan,
        "track": track,
        "acq_date":
            "${acqDate.year.toString().padLeft(4, '0')}-${acqDate.month.toString().padLeft(2, '0')}-${acqDate.day.toString().padLeft(2, '0')}",
        "acq_time": acqTime,
        "satellite": satellite,
        "confidence": confidence,
        "version": version,
        "bright_ti5": brightTi5,
        "frp": frp,
        "daynight": daynight,
      };
}

class ViirsResult {
  Viirs viirs;

  ViirsResult({required this.viirs});

  factory ViirsResult.fromJson(Map<String, dynamic> json) => ViirsResult(
        viirs: Viirs.fromJson(json["1"]),
      );

  Map<String, dynamic> toJson() => {"1": viirs.toJson()};

  static List<Viirs> fromMap(Map<String, dynamic> obj) {
    return obj.values.map((map) => Viirs.fromJson(map)).toList();
  }
}
