import 'package:equatable/equatable.dart';
import 'package:fogosmobile/models/base_location_model.dart';
import 'package:fogosmobile/models/icnf.dart';
import 'package:fogosmobile/models/weather.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

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

//TODO Create FireEntity and separate Model from an Entity
class Fire extends BaseMapboxModel implements Equatable {
  final String id;
  final int sharepointId;

  // Status
  final bool active;
  final bool important;
  final bool isFire;
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
  final String local;
  final String? detailLocation; // localidade

  final double lat;
  final double lng;

  // Chronology
  final int created;
  final String date;
  final int dateTime;
  final String time;

  // Importance
  double importance = 0.0;
  double scale = 0.0;

  // Weather
  final Weather? weather;

  // extra
  String extra;
  String cos;
  String pco;
  final String? kml;
  final String? kmlVost;
  final Icnf? icnf;

  Fire({
    required this.id,
    required this.sharepointId,
    required this.active,
    required this.important,
    this.isFire = true,
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
    this.detailLocation,
    required this.lat,
    required this.lng,
    required this.created,
    required this.date,
    required this.dateTime,
    required this.time,
    this.weather,
    this.extra = '',
    this.cos = '',
    this.pco = '',
    this.kml,
    this.kmlVost,
    this.icnf,
  }) : super(Point(coordinates: Position(lng, lat)), id);

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

  dynamic get(String propertyName) {
    var _mapRep = _toMap();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }

  factory Fire.fromJson(Map<String, dynamic> map) {
    return Fire(
      id: map['id'] ?? '',
      sharepointId: map['sharepointId'] ?? 0,
      active: map['active'] ?? false,
      important: map['important'] ?? false,
      isFire: map['isFire'] == true || map['isFire'] == 1 || map['isFire'] == null,
      status: _statusFromJson(map['status'] ?? ''),
      statusCode: map['statusCode'] ?? 0,
      statusColor: map['statusColor'] ?? '',
      nature: map['natureza'] ?? '',
      natureCode: map['naturezaCode'] ?? '',
      aerial: map['aerial'] ?? 0,
      terrain: map['terrain'] ?? 0,
      human: map['man'] ?? 0,
      district: map['district'] ?? '',
      city: map['concelho'] ?? '',
      town: map['freguesia'] ?? '',
      local: map['localidade'] ?? '',
      detailLocation: map['detailLocation'],
      lat: (map['lat'] ?? 0.0).toDouble(),
      lng: (map['lng'] ?? 0.0).toDouble(),
      created: map['created']?['sec'] ?? 0,
      date: map['date'] ?? '',
      dateTime: map['dateTime']?['sec'] ?? 0,
      time: map['hour'] ?? '',
      weather: map['weather'] != null ? Weather.tryFromJson(map['weather']) : null,
      extra: map['extra'] ?? '',
      cos: map['cos'] ?? '',
      pco: map['pco'] ?? '',
      kml: map['kml'],
      kmlVost: map['kmlVost'],
      icnf: map['icnf'] != null ? Icnf.fromJson(map['icnf']) : null,
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
    }
  }

  static List<String> activeFiltersToList(List<FireStatus> statusList) {
    return statusList.map((filter) => Fire._statusToJson(filter)).toList();
  }

  static List<FireStatus> listFromActiveFilters(List<String>? statusList) {
    return statusList
            ?.map((filter) => Fire._statusFromJson(filter))
            .toList() ??
        List.from(FireStatus.values);
  }

  String get fullAddress => '$district, $city, $town, $local';

  @override
  List<Object> get props => [id];

  @override
  bool get stringify => true;

  @override
  bool skip<T>(List<T>? filters) {
    if (filters != null) {
      return !filters.contains(status);
    } else
      return true;
  }
}
