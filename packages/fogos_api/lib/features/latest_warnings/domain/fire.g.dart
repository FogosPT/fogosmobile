// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fire.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FireImpl _$$FireImplFromJson(Map<String, dynamic> json) => _$FireImpl(
      id: json['id'] as String,
      coords: json['coords'] as bool,
      dateTime: Created.fromJson(json['dateTime'] as Map<String, dynamic>),
      date: json['date'] as String,
      hour: json['hour'] as String,
      location: json['location'] as String,
      aerial: (json['aerial'] as num).toInt(),
      terrain: (json['terrain'] as num).toInt(),
      man: (json['man'] as num).toInt(),
      district: json['district'] as String,
      concelho: json['concelho'] as String,
      freguesia: json['freguesia'] as String,
      dico: json['dico'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      naturezaCode: json['naturezaCode'] as String,
      natureza: json['natureza'] as String,
      statusCode: (json['statusCode'] as num).toInt(),
      statusColor: json['statusColor'] as String,
      status: json['status'] as String,
      important: json['important'] as bool,
      active: json['active'] as bool,
      sadoId: json['sadoId'] as String,
      sharepointId: (json['sharepointId'] as num).toInt(),
      extra: json['extra'] as String?,
      disappear: json['disappear'] as bool,
      created: Created.fromJson(json['created'] as Map<String, dynamic>),
      updated: Created.fromJson(json['updated'] as Map<String, dynamic>),
      fireStatus: $enumDecodeNullable(_$FireStatusEnumMap, json['fireStatus']),
    );

Map<String, dynamic> _$$FireImplToJson(_$FireImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'coords': instance.coords,
      'dateTime': instance.dateTime,
      'date': instance.date,
      'hour': instance.hour,
      'location': instance.location,
      'aerial': instance.aerial,
      'terrain': instance.terrain,
      'man': instance.man,
      'district': instance.district,
      'concelho': instance.concelho,
      'freguesia': instance.freguesia,
      'dico': instance.dico,
      'lat': instance.lat,
      'lng': instance.lng,
      'naturezaCode': instance.naturezaCode,
      'natureza': instance.natureza,
      'statusCode': instance.statusCode,
      'statusColor': instance.statusColor,
      'status': instance.status,
      'important': instance.important,
      'active': instance.active,
      'sadoId': instance.sadoId,
      'sharepointId': instance.sharepointId,
      'extra': instance.extra,
      'disappear': instance.disappear,
      'created': instance.created,
      'updated': instance.updated,
      'fireStatus': _$FireStatusEnumMap[instance.fireStatus],
    };

const _$FireStatusEnumMap = {
  FireStatus.dispatch: 'dispatch',
  FireStatus.significativeOcurrence: 'significativeOcurrence',
  FireStatus.vigilance: 'vigilance',
  FireStatus.firstAlertDispatch: 'firstAlertDispatch',
  FireStatus.arrival: 'arrival',
  FireStatus.ongoing: 'ongoing',
  FireStatus.inResolution: 'inResolution',
  FireStatus.inConclusion: 'inConclusion',
  FireStatus.done: 'done',
  FireStatus.falseAlarm: 'falseAlarm',
  FireStatus.falseAlert: 'falseAlert',
};
