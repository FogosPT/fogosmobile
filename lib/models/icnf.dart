class IcnfBurnArea {
  final double povoamento;
  final double agricola;
  final double mato;
  final double total;

  IcnfBurnArea({
    required this.povoamento,
    required this.agricola,
    required this.mato,
    required this.total,
  });

  factory IcnfBurnArea.fromJson(Map<String, dynamic> map) {
    return IcnfBurnArea(
      povoamento: (map['povoamento'] ?? 0).toDouble(),
      agricola: (map['agricola'] ?? 0).toDouble(),
      mato: (map['mato'] ?? 0).toDouble(),
      total: (map['total'] ?? 0).toDouble(),
    );
  }
}

class Icnf {
  final IcnfBurnArea? burnArea;
  final double? altitude;
  final bool? incendio;
  final String? fonteAlerta;

  Icnf({
    this.burnArea,
    this.altitude,
    this.incendio,
    this.fonteAlerta,
  });

  factory Icnf.fromJson(Map<String, dynamic> map) {
    return Icnf(
      burnArea: map['burnArea'] != null
          ? IcnfBurnArea.fromJson(map['burnArea'])
          : null,
      altitude: map['altitude'] != null
          ? (map['altitude'] as num).toDouble()
          : null,
      incendio: map['incendio'],
      fonteAlerta: map['fontealerta']?.toString(),
    );
  }
}
