// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fires.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Fires _$FiresFromJson(Map<String, dynamic> json) => _Fires(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>)
      .map((e) => Fire.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$FiresToJson(_Fires instance) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
};
