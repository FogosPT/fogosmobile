import 'dart:collection';

import 'package:fogosmobile/utils/model_utils.dart';

class NowStats {
  final String man;
  final String aerial;
  final String cars;
  final String total;

  NowStats({this.man = "0", this.aerial = "0", this.cars = "0", this.total = "0"});

  factory NowStats.fromJson(Map<String, dynamic> parsedJson) {
    return NowStats(
        man: nonNegativeIntString(parsedJson['man']),
        aerial: nonNegativeIntString(parsedJson['aerial']),
        cars: nonNegativeIntString(parsedJson['cars']),
        total: nonNegativeIntString(parsedJson['total']));
  }
}

class TodayStats {
  final List<IntervalStats> intervalStatsList;
  final List<District> districtList;

  TodayStats({this.intervalStatsList = const [], this.districtList = const []});

  factory TodayStats.fromJson(Map<String, dynamic> parsedJson) {
    List<IntervalStats> intervalStatsList = <IntervalStats>[];
    List<District> districtList = <District>[];
    Map<String, int> districtTempMap = Map<String, int>();

    parsedJson?.forEach(
        (i, j) => intervalStatsList.add(IntervalStats.fromJson(j, i)));

    // Checks for double entries and sums them
    intervalStatsList.forEach((d) {
      d.districtMap.forEach((k, v) {
        if (districtTempMap.containsKey(k)) {
          districtTempMap.update(k, (dynamic val) => val + v);
        } else {
          districtTempMap[k] = v;
        }
      });
    });

    // Sort by increasing values
    var sortedKeys = districtTempMap.keys.toList(growable: false)
      ..sort((k1, k2) => (districtTempMap[k1] ?? 0).compareTo(districtTempMap[k2] ?? 0));
    LinkedHashMap sortedMap = LinkedHashMap.fromIterable(sortedKeys,
        key: (k) => k, value: (k) => districtTempMap[k]);

    // Convert the map to a List for chart data
    sortedMap.forEach((k, v) {
      districtList.add(District(district: k, fires: v));
    });

    return TodayStats(
        intervalStatsList: intervalStatsList, districtList: districtList);
  }
}

class YesterdayStats {
  final List<IntervalStats> intervalStatsList;
  final List<District> districtList;

  YesterdayStats({this.intervalStatsList = const [], this.districtList = const []});

  factory YesterdayStats.fromJson(Map<String, dynamic> parsedJson) {
    List<IntervalStats> intervalStatsList = <IntervalStats>[];
    List<District> districtList = <District>[];
    Map<String, int> districtTempMap = Map<String, int>();

    parsedJson?.forEach(
        (i, j) => intervalStatsList.add(IntervalStats.fromJson(j, i)));

    // Checks for double entries and sums them
    intervalStatsList.forEach((d) {
      d.districtMap.forEach((k, v) {
        if (districtTempMap.containsKey(k)) {
          districtTempMap.update(k, (dynamic val) => val + v);
        } else {
          districtTempMap[k] = v;
        }
      });
    });

    // Sort by increasing values
    var sortedKeys = districtTempMap.keys.toList(growable: false)
      ..sort((k1, k2) => (districtTempMap[k1] ?? 0).compareTo(districtTempMap[k2] ?? 0));
    LinkedHashMap sortedMap = LinkedHashMap.fromIterable(sortedKeys,
        key: (k) => k, value: (k) => districtTempMap[k]);

    // Convert the map to a List for chart data
    sortedMap.forEach((k, v) {
      districtList.add(District(district: k, fires: v));
    });

    return YesterdayStats(
        intervalStatsList: intervalStatsList, districtList: districtList);
  }
}

class LastNightStats {
  final int total;
  final List<District> districtList;

  LastNightStats({this.total = 0, this.districtList = const []});

  factory LastNightStats.fromJson(Map<String, dynamic> json) {
    List<District> districtList = <District>[];
    int total = json['total'];

    if (total != 0) {
      json['distritos']
          ?.forEach((i, j) => districtList.add(District.fromJson(i, j)));
    }

    districtList.sort((k1, k2) => k1.fires.compareTo(k2.fires));

    return LastNightStats(total: total, districtList: districtList);
  }
}

class WeekStats {
  final List<Day> days;

  WeekStats({this.days = const []});

  factory WeekStats.fromJson(List<dynamic> json) {
    List<Day> days = <Day>[];

    days = json.map((i) => Day.fromJson(i)).toList();

    return WeekStats(days: days);
  }
}

class Day {
  final String label;
  final int total;
  final int fake;

  Day({this.label = "", this.total = 0, this.fake = 0});

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(label: json['label'], total: json['total'], fake: json['false']);
  }
}

class LastHoursStats {
  final List<LastHour> lastHours;

  LastHoursStats({this.lastHours = const []});

  factory LastHoursStats.fromJson(List<dynamic> json) {
    List<LastHour> lastHours = <LastHour>[];
    lastHours = json.map((i) => LastHour.fromJson(i)).toList();
    return LastHoursStats(lastHours: lastHours);
  }
}

class LastHour {
  final int man;
  final int aerial;
  final int cars;
  final int total;
  final DateTime? label;

  LastHour({this.man = 0, this.aerial = 0, this.cars = 0, this.total = 0, this.label});

  factory LastHour.fromJson(Map<String, dynamic> parsedJson) {
    DateTime dateLabel =
        DateTime.fromMillisecondsSinceEpoch(
        parsedJson['created'].runtimeType == int
            ? parsedJson['created'] * 1000
            : parsedJson['created']['sec'] * 1000);

    return LastHour(
      man: nonNegativeInt(parsedJson['man']),
      aerial: nonNegativeInt(parsedJson['aerial']),
      cars: nonNegativeInt(parsedJson['cars']),
      total: nonNegativeInt(parsedJson['total']),
      label: dateLabel,
    );
  }
}

class IntervalStats {
  final String label;
  final int total;
  final Map<String, int> districtMap;

  IntervalStats({this.total = 0, this.districtMap = const {}, this.label = ""});

  factory IntervalStats.fromJson(Map<String, dynamic> json, String label) {
    int total = json['total'];

    Map<String, int> districtMap = Map<String, int>();

    if (total != 0) {
      json['distritos']?.forEach((i, j) => districtMap[i] = j);
    }

    return IntervalStats(total: total, label: label, districtMap: districtMap);
  }
}

class District {
  final String district;
  final int fires;

  District({this.district = "", this.fires = 0});

  factory District.fromJson(String district, int fire) {
    return District(district: district, fires: fire);
  }
}
