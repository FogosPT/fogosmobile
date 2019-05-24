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
    // TODO: This will not work for fires active more than one day
    // Solution: change the labels on the API to always be on a dd-MM-yyyy H:mm format instead of only having H:m

    DateTime dateLabel;

    String label = parsedJson['label'];
    final now = DateTime.now();

    int hour, minute;

    List<String> dateString = label.split(" ");
    if (dateString.length > 1) {
      hour = int.parse(dateString[1].split(":")[0]);
      minute = int.parse(dateString[1].split(":")[1]);
    } else {
      hour = int.parse(dateString[0].split(":")[0]);
      minute = int.parse(dateString[0].split(":")[1]);
    }

    TimeOfDay t = TimeOfDay(hour: hour, minute: minute);

    if (now.hour < t.hour) {
      dateLabel = DateTime(now.year, now.month, now.day - 1, t.hour, t.minute);
    } else {
      dateLabel = DateTime(now.year, now.month, now.day, t.hour, t.minute);
    }

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
    DateTime dateLabel;

    String label = parsedJson['label'];
    final now = DateTime.now();

    int hour, minute;

    List<String> dateString = label.split(" ");
    if (dateString.length > 1) {
      hour = int.parse(dateString[1].split(":")[0]);
      minute = int.parse(dateString[1].split(":")[1]);
    } else {
      hour = int.parse(dateString[0].split(":")[0]);
      minute = int.parse(dateString[0].split(":")[1]);
    }

    TimeOfDay t = TimeOfDay(hour: hour, minute: minute);

    if (now.hour < t.hour) {
      dateLabel = DateTime(now.year, now.month, now.day - 1, t.hour, t.minute);
    } else {
      dateLabel = DateTime(now.year, now.month, now.day, t.hour, t.minute);
    }

    return Details(
      status: parsedJson['status'],
      statusCode: parsedJson['statusCode'],
      label: dateLabel,
    );
  }
}
