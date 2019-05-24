import 'package:flutter/material.dart';

class MeansHistory {
  final List<Means> means;

  MeansHistory({this.means});

  factory MeansHistory.fromJson(List<dynamic> json) {
    List<Means> means = new List<Means>();
    means = json.map((i) => Means.fromJson(i)).toList();
    return MeansHistory(means: means);
  }
}

class Means {
  final int aerial;
  final int man;
  final int terrain;
  final DateTime label;

  Means({this.man, this.aerial, this.terrain, this.label});

  factory Means.fromJson(Map<String, dynamic> parsedJson) {

   DateTime dateLabel =
        DateTime.fromMillisecondsSinceEpoch(parsedJson['created'] * 1000);

    return Means(
      man: parsedJson['man'],
      aerial: parsedJson['aerial'],
      terrain: parsedJson['terrain'],
      label: dateLabel,
    );
  }
}

class DetailsHistory {
  final List<Details> details;

  DetailsHistory({this.details});

  factory DetailsHistory.fromJson(List<dynamic> json) {
    List<Details> details = new List<Details>();
    details = json.map((i) => Details.fromJson(i)).toList();
    return DetailsHistory(details: details);
  }
}

class Details {
  final String status;
  final int statusCode;
  final DateTime label;

  Details({this.status, this.statusCode, this.label});

  factory Details.fromJson(Map<String, dynamic> parsedJson) {
    DateTime dateLabel =
        DateTime.fromMillisecondsSinceEpoch(parsedJson['created'] * 1000);
    return Details(
      status: parsedJson['status'],
      statusCode: parsedJson['statusCode'],
      label: dateLabel,
    );
  }
}
