class Weather {
  final String stationId;
  final String stationLocation;
  final double temperatura;
  final double humidade;
  final double intensidadeVento;
  final double intensidadeVentoKM;
  final int idDireccVento;
  final String direccVento;
  final double precAcumulada;
  final double radiacao;
  final double pressao;
  final String date;
  final double? stationDistance;

  Weather({
    required this.stationId,
    required this.stationLocation,
    required this.temperatura,
    required this.humidade,
    required this.intensidadeVento,
    required this.intensidadeVentoKM,
    required this.idDireccVento,
    required this.direccVento,
    required this.precAcumulada,
    required this.radiacao,
    required this.pressao,
    required this.date,
    this.stationDistance,
  });

  static Weather? tryFromJson(Map<String, dynamic>? map) {
    if (map == null) return null;
    try {
      return Weather.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  factory Weather.fromJson(Map<String, dynamic> map) {
    return Weather(
      stationId: (map['stationId'] ?? '').toString(),
      stationLocation: map['stationLocation'] ?? '',
      temperatura: (map['temperatura'] ?? 0.0).toDouble(),
      humidade: (map['humidade'] ?? 0.0).toDouble(),
      intensidadeVento: (map['intensidadeVento'] ?? 0.0).toDouble(),
      intensidadeVentoKM: (map['intensidadeVentoKM'] ?? 0.0).toDouble(),
      idDireccVento: map['idDireccVento'] ?? 0,
      direccVento: map['direccVento'] ?? '',
      precAcumulada: (map['precAcumulada'] ?? 0.0).toDouble(),
      radiacao: (map['radiacao'] ?? 0.0).toDouble(),
      pressao: (map['pressao'] ?? 0.0).toDouble(),
      date: map['date'] ?? '',
      stationDistance: map['stationDistance'] != null ? (map['stationDistance']).toDouble() : null,
    );
  }
}
