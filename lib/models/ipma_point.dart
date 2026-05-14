class IpmaHourly {
  final DateTime t;
  final double? temperature;
  final double? humidity;
  final double? wind;
  final double? gust;
  final double? pressure;
  final double? precipitation;
  final double? windU;
  final double? windV;

  IpmaHourly({
    required this.t,
    this.temperature,
    this.humidity,
    this.wind,
    this.gust,
    this.pressure,
    this.precipitation,
    this.windU,
    this.windV,
  });

  factory IpmaHourly.fromJson(Map<String, dynamic> j) {
    double? d(String k) => j[k] is num ? (j[k] as num).toDouble() : null;
    return IpmaHourly(
      t: DateTime.parse(j['datetime'] as String),
      temperature: d('temperature'),
      humidity: d('humidity'),
      wind: d('wind'),
      gust: d('gust'),
      pressure: d('pressure'),
      precipitation: d('precipitation'),
      windU: d('windU'),
      windV: d('windV'),
    );
  }
}

class IpmaDailyValue {
  final DateTime t;
  final double? value;

  IpmaDailyValue({required this.t, this.value});

  factory IpmaDailyValue.fromJson(Map<String, dynamic> j) {
    final v = j['value'];
    return IpmaDailyValue(
      t: DateTime.parse(j['datetime'] as String),
      value: v is num ? v.toDouble() : null,
    );
  }
}

class IpmaPointData {
  final String region;
  final String referenceTime;
  final List<IpmaHourly> hourly;
  final Map<String, List<IpmaDailyValue>> daily;

  IpmaPointData({
    required this.region,
    required this.referenceTime,
    required this.hourly,
    required this.daily,
  });

  factory IpmaPointData.fromJson(Map<String, dynamic> j) {
    final hourly = (j['hourly'] as List? ?? const [])
        .map((row) => IpmaHourly.fromJson(row as Map<String, dynamic>))
        .toList();
    final daily = <String, List<IpmaDailyValue>>{};
    (j['daily'] as Map<String, dynamic>? ?? const {}).forEach((k, v) {
      daily[k] = (v as List)
          .map((row) => IpmaDailyValue.fromJson(row as Map<String, dynamic>))
          .toList();
    });
    return IpmaPointData(
      region: j['region'] as String? ?? '',
      referenceTime: j['reference_time'] as String? ?? '',
      hourly: hourly,
      daily: daily,
    );
  }
}
