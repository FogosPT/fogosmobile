enum FireStatus {
  dispatch,
  significative_ocurrence,
  vigilance,
  first_alert_dispatch,
  arrival,
  ongoing,
  in_resolution,
  in_conclusion,
  done,
  false_alarm,
  false_alert,
}

class Fire {
  final String id;
  final int sharepointId;

  // Status
  final bool active;
  final bool important;
  final int statusCode;
  final String statusColor;
  final FireStatus status;

  final String nature;
  final String natureCode;

  // Active Fighting Means
  final int aerial;
  final int terrain;
  final int human;

  // Geography
  final String district; // distrito
  final String city; // concelho
  final String town; // freguesia
  final String local; // localidade

  final double lat;
  final double lng;

  // Chronology
  final int created;
  final String date;
  final int dateTime;
  final String time;

  // Importance
  double importance;
  double scale;

  // extra
  String extra;
  String cos;
  String pco;

  Fire({
    this.id,
    this.sharepointId,
    this.active,
    this.important,
    this.status,
    this.statusCode,
    this.statusColor,
    this.nature,
    this.natureCode,
    this.aerial,
    this.terrain,
    this.human,
    this.district,
    this.city,
    this.town,
    this.local,
    this.lat,
    this.lng,
    this.created,
    this.date,
    this.dateTime,
    this.time,
    this.extra,
    this.cos,
    this.pco,
  });

  factory Fire.fromJson(Map<String, dynamic> map) {
    return new Fire(
      id: map['id'],
      sharepointId: map['sharepointId'],
      active: map['active'],
      important: map['important'],
      status: _statusFromJson(map['status']),
      statusCode: map['statusCode'],
      statusColor: map['statusColor'],
      nature: map['natureza'],
      natureCode: map['naturezaCode'],
      aerial: map['aerial'],
      terrain: map['terrain'],
      human: map['man'],
      district: map['district'],
      city: map['concelho'],
      town: map['freguesia'],
      local: map['localidade'],
      lat: map['lat'],
      lng: map['lng'],
      created: map['created']['sec'],
      date: map['date'],
      dateTime: map['dateTime']['sec'],
      time: map['hour'],
      extra: map['extra'],
      cos: map['cos'],
      pco: map['pco'],
    );
  }

  static FireStatus _statusFromJson(String status) {
    switch (status) {
      case 'Ocorrência Significativa':
        return FireStatus.significative_ocurrence;
      case 'Vigilância':
        return FireStatus.vigilance;
      case 'Despacho':
        return FireStatus.dispatch;
      case 'Despacho de 1º Alerta':
        return FireStatus.first_alert_dispatch;
      case 'Chegada ao TO':
        return FireStatus.arrival;
      case 'Em Curso':
        return FireStatus.ongoing;
      case 'Em Resolução':
        return FireStatus.in_resolution;
      case 'Conclusão':
        return FireStatus.in_conclusion;
      case 'Encerrada':
        return FireStatus.done;
      case 'Falso Alarme':
        return FireStatus.false_alarm;
      case 'Falso Alerta':
        return FireStatus.false_alert;
      default:
        throw Exception('Unknown fire state: $status');
    }
  }

  static String _statusToJson(FireStatus status) {
    switch (status) {
      case FireStatus.significative_ocurrence:
        return 'Ocorrência Significativa';
      case FireStatus.vigilance:
        return 'Vigilância';
      case FireStatus.dispatch:
        return 'Despacho';
      case FireStatus.first_alert_dispatch:
        return 'Despacho de 1º Alerta';
      case FireStatus.arrival:
        return 'Chegada ao TO';
      case FireStatus.ongoing:
        return 'Em Curso';
      case FireStatus.in_resolution:
        return 'Em Resolução';
      case FireStatus.in_conclusion:
        return 'Conclusão';
      case FireStatus.done:
        return 'Encerrada';
      case FireStatus.false_alarm:
        return 'Falso Alarme';
      case FireStatus.false_alert:
        return 'Falso Alerta';
      default:
        throw Exception('Unknown fire state: $status');
    }
  }

  static List<String> activeFiltersToList(List<FireStatus> statusList) {
    return statusList?.map((filter) => Fire._statusToJson(filter))?.toList() ?? [];
  }

  static List<FireStatus> listFromActiveFilters(List<String> statusList) {
    return statusList?.map((filter) => Fire._statusFromJson(filter))?.toList() ?? List.from(FireStatus.values);
  }

  String get fullAddress => '$district, $city, $town, $local';
}
