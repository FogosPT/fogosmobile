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
      t: _parseIpmaUtc(j['datetime'] as String),
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
  final String rawDate;

  IpmaDailyValue({required this.t, required this.rawDate, this.value});

  factory IpmaDailyValue.fromJson(Map<String, dynamic> j) {
    final v = j['value'];
    final raw = j['datetime'] as String;
    return IpmaDailyValue(
      t: _parseIpmaUtc(raw),
      rawDate: raw.length >= 10 ? raw.substring(0, 10) : raw,
      value: v is num ? v.toDouble() : null,
    );
  }
}

DateTime _parseIpmaUtc(String iso) {
  final hasTz = iso.endsWith('Z') ||
      RegExp(r'[+-]\d{2}:?\d{2}$').hasMatch(iso);
  return DateTime.parse(hasTz ? iso : '${iso}Z').toLocal();
}

class IpmaPointData {
  final String region;
  final String referenceTime;
  final DateTime? referenceTimeLocal;
  final List<IpmaHourly> hourly;
  final Map<String, List<IpmaDailyValue>> daily;

  IpmaPointData({
    required this.region,
    required this.referenceTime,
    required this.referenceTimeLocal,
    required this.hourly,
    required this.daily,
  });

  factory IpmaPointData.fromJson(Map<String, dynamic> j) {
    final hourly = (j['hourly'] as List? ?? const [])
        .map((row) => IpmaHourly.fromJson(row as Map<String, dynamic>))
        .toList();
    final refTimeRaw = j['reference_time'] as String? ?? '';
    DateTime? refLocal;
    try {
      if (refTimeRaw.isNotEmpty) refLocal = _parseIpmaUtc(refTimeRaw);
    } catch (_) {}
    final refDay =
        refTimeRaw.length >= 10 ? refTimeRaw.substring(0, 10) : null;
    final daily = <String, List<IpmaDailyValue>>{};
    (j['daily'] as Map<String, dynamic>? ?? const {}).forEach((k, v) {
      final rows = (v as List)
          .map((row) => IpmaDailyValue.fromJson(row as Map<String, dynamic>))
          .toList();
      if (refDay != null) {
        rows.retainWhere((row) => row.rawDate.compareTo(refDay) >= 0);
      }
      daily[k] = rows;
    });
    return IpmaPointData(
      region: j['region'] as String? ?? '',
      referenceTime: refTimeRaw,
      referenceTimeLocal: refLocal,
      hourly: hourly,
      daily: daily,
    );
  }
}
