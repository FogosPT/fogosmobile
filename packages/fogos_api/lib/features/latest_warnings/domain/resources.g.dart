// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resources.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Resources _$ResourcesFromJson(Map<String, dynamic> json) => _Resources(
  label: json['label'] as String,
  man: (json['man'] as num).toInt(),
  terrain: (json['terrain'] as num).toInt(),
  aerial: (json['aerial'] as num).toInt(),
  created: (json['created'] as num).toInt(),
  location: json['location'] as String?,
  personId: json['personId'] as String?,
  id: json['id'] as String?,
);

Map<String, dynamic> _$ResourcesToJson(_Resources instance) =>
    <String, dynamic>{
      'label': instance.label,
      'man': instance.man,
      'terrain': instance.terrain,
      'aerial': instance.aerial,
      'created': instance.created,
      'location': instance.location,
      'personId': instance.personId,
      'id': instance.id,
    };
