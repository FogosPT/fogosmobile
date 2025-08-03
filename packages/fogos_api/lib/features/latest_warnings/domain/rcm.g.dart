// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rcm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RCM _$RCMFromJson(Map<String, dynamic> json) => _RCM(
  id: json['_id'] as String,
  concelho: json['concelho'] as String,
  date: DateTime.parse(json['date'] as String),
  hoje: json['hoje'] as String,
  amanha: json['amanha'] as String,
  depois: json['depois'] as String,
  depois2: json['depois2'] as String,
  depois3: json['depois3'] as String,
  dico: json['dico'] as String,
  updated: Ated.fromJson(json['updated'] as Map<String, dynamic>),
  created: Ated.fromJson(json['created'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RCMToJson(_RCM instance) => <String, dynamic>{
  '_id': instance.id,
  'concelho': instance.concelho,
  'date': instance.date.toIso8601String(),
  'hoje': instance.hoje,
  'amanha': instance.amanha,
  'depois': instance.depois,
  'depois2': instance.depois2,
  'depois3': instance.depois3,
  'dico': instance.dico,
  'updated': instance.updated,
  'created': instance.created,
};
