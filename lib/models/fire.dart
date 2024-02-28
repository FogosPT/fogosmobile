import 'package:equatable/equatable.dart';
import 'package:fogosmobile/models/base_location_model.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

//TODO Create FireEntity and separate Model from an Entity
class Fire extends BaseMapboxModel implements Equatable {
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
  final double importance;
  final double scale;

  // extra
  final String extra;
  final String cos;
  final String pco;

  Fire({
    required this.id,
    required this.importance,
    required this.sharepointId,
    required this.active,
    required this.important,
    required this.status,
    required this.statusCode,
    required this.statusColor,
    required this.nature,
    required this.natureCode,
    required this.aerial,
    required this.terrain,
    required this.human,
    required this.district,
    required this.city,
    required this.town,
    required this.local,
    required this.lat,
    required this.lng,
    required this.created,
    required this.date,
    required this.dateTime,
    required this.time,
    required this.extra,
    required this.cos,
    required this.pco,
    this.scale = 1.5,
  }) : super(LatLng(lat, lng), id);

  factory Fire.fromJson(Map<String, dynamic> map) {
    return Fire(
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
      importance: 0,
      scale: 1,
    );
  }

  String get fullAddress => '$district, $city, $town, $local';

  @override
  List<Object> get props => [id];

  @override
  bool get stringify => true;

  dynamic get(String propertyName) {
    var _mapRep = _toMap();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }

  @override
  bool skip<T>(List<T> filters) {
    return !filters.contains(status);
  }

  Map<String, dynamic> _toMap() {
    return {
      'aerial': aerial,
      'city': city,
      'dateTime': dateTime,
      'district': district,
      'human': human,
      'id': id,
      'local': local,
      'status': statusCode,
      'terrain': terrain,
      'town': town,
    };
  }

  static List<String> activeFiltersToList(List<FireStatus> statusList) {
    return statusList.map((filter) => Fire._statusToJson(filter)).toList() ??
        [];
  }

  static List<FireStatus> listFromActiveFilters(List<String> statusList) {
    return statusList.map((filter) => Fire._statusFromJson(filter)).toList() ??
        List.from(FireStatus.values);
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
}

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
