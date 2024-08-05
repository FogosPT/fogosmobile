// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fire.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Fire _$FireFromJson(Map<String, dynamic> json) {
  return _Fire.fromJson(json);
}

/// @nodoc
mixin _$Fire {
// @JsonKey(name: "_id") required Id id,
  String get id => throw _privateConstructorUsedError;
  bool get coords => throw _privateConstructorUsedError;
  Created get dateTime => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;
  String get hour => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  int get aerial => throw _privateConstructorUsedError;
  int get terrain =>
      throw _privateConstructorUsedError; // required int meiosAquaticos,
  int get man => throw _privateConstructorUsedError;
  String get district => throw _privateConstructorUsedError;
  String get concelho => throw _privateConstructorUsedError;
  String get freguesia => throw _privateConstructorUsedError;
  String get dico => throw _privateConstructorUsedError;
  double get lat => throw _privateConstructorUsedError;
  double get lng => throw _privateConstructorUsedError;
  String get naturezaCode =>
      throw _privateConstructorUsedError; // 3101, 3103, 3105, 3107
  String get natureza =>
      throw _privateConstructorUsedError; // required dynamic especieName,
// required dynamic familiaName,
  int get statusCode => throw _privateConstructorUsedError; // 3, 4, 5, 6
  String get statusColor =>
      throw _privateConstructorUsedError; // Hexadecimal code representing colors, related with statusCode value.
  String get status => throw _privateConstructorUsedError;
  bool get important =>
      throw _privateConstructorUsedError; // required String localidade,
  bool get active => throw _privateConstructorUsedError;
  String get sadoId => throw _privateConstructorUsedError;
  int get sharepointId => throw _privateConstructorUsedError;
  String? get extra => throw _privateConstructorUsedError;
  bool get disappear =>
      throw _privateConstructorUsedError; // required Icnf? icnf,
// required String? detailLocation,
// required dynamic kml,
// required dynamic kmlVost,
// required dynamic pco,
// required dynamic cos,
// required int heliFight,
// required int heliCoord,
// required int planeFight,
// required bool anepcDirectUpdate,
// required String regiao,
// required String subRegiao,
  Created get created => throw _privateConstructorUsedError;
  Created get updated => throw _privateConstructorUsedError;
  FireStatus? get fireStatus => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FireCopyWith<Fire> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FireCopyWith<$Res> {
  factory $FireCopyWith(Fire value, $Res Function(Fire) then) =
      _$FireCopyWithImpl<$Res, Fire>;
  @useResult
  $Res call(
      {String id,
      bool coords,
      Created dateTime,
      String date,
      String hour,
      String location,
      int aerial,
      int terrain,
      int man,
      String district,
      String concelho,
      String freguesia,
      String dico,
      double lat,
      double lng,
      String naturezaCode,
      String natureza,
      int statusCode,
      String statusColor,
      String status,
      bool important,
      bool active,
      String sadoId,
      int sharepointId,
      String? extra,
      bool disappear,
      Created created,
      Created updated,
      FireStatus? fireStatus});

  $CreatedCopyWith<$Res> get dateTime;
  $CreatedCopyWith<$Res> get created;
  $CreatedCopyWith<$Res> get updated;
}

/// @nodoc
class _$FireCopyWithImpl<$Res, $Val extends Fire>
    implements $FireCopyWith<$Res> {
  _$FireCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? coords = null,
    Object? dateTime = null,
    Object? date = null,
    Object? hour = null,
    Object? location = null,
    Object? aerial = null,
    Object? terrain = null,
    Object? man = null,
    Object? district = null,
    Object? concelho = null,
    Object? freguesia = null,
    Object? dico = null,
    Object? lat = null,
    Object? lng = null,
    Object? naturezaCode = null,
    Object? natureza = null,
    Object? statusCode = null,
    Object? statusColor = null,
    Object? status = null,
    Object? important = null,
    Object? active = null,
    Object? sadoId = null,
    Object? sharepointId = null,
    Object? extra = freezed,
    Object? disappear = null,
    Object? created = null,
    Object? updated = null,
    Object? fireStatus = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      coords: null == coords
          ? _value.coords
          : coords // ignore: cast_nullable_to_non_nullable
              as bool,
      dateTime: null == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as Created,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      hour: null == hour
          ? _value.hour
          : hour // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      aerial: null == aerial
          ? _value.aerial
          : aerial // ignore: cast_nullable_to_non_nullable
              as int,
      terrain: null == terrain
          ? _value.terrain
          : terrain // ignore: cast_nullable_to_non_nullable
              as int,
      man: null == man
          ? _value.man
          : man // ignore: cast_nullable_to_non_nullable
              as int,
      district: null == district
          ? _value.district
          : district // ignore: cast_nullable_to_non_nullable
              as String,
      concelho: null == concelho
          ? _value.concelho
          : concelho // ignore: cast_nullable_to_non_nullable
              as String,
      freguesia: null == freguesia
          ? _value.freguesia
          : freguesia // ignore: cast_nullable_to_non_nullable
              as String,
      dico: null == dico
          ? _value.dico
          : dico // ignore: cast_nullable_to_non_nullable
              as String,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
      naturezaCode: null == naturezaCode
          ? _value.naturezaCode
          : naturezaCode // ignore: cast_nullable_to_non_nullable
              as String,
      natureza: null == natureza
          ? _value.natureza
          : natureza // ignore: cast_nullable_to_non_nullable
              as String,
      statusCode: null == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int,
      statusColor: null == statusColor
          ? _value.statusColor
          : statusColor // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      important: null == important
          ? _value.important
          : important // ignore: cast_nullable_to_non_nullable
              as bool,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
      sadoId: null == sadoId
          ? _value.sadoId
          : sadoId // ignore: cast_nullable_to_non_nullable
              as String,
      sharepointId: null == sharepointId
          ? _value.sharepointId
          : sharepointId // ignore: cast_nullable_to_non_nullable
              as int,
      extra: freezed == extra
          ? _value.extra
          : extra // ignore: cast_nullable_to_non_nullable
              as String?,
      disappear: null == disappear
          ? _value.disappear
          : disappear // ignore: cast_nullable_to_non_nullable
              as bool,
      created: null == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as Created,
      updated: null == updated
          ? _value.updated
          : updated // ignore: cast_nullable_to_non_nullable
              as Created,
      fireStatus: freezed == fireStatus
          ? _value.fireStatus
          : fireStatus // ignore: cast_nullable_to_non_nullable
              as FireStatus?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CreatedCopyWith<$Res> get dateTime {
    return $CreatedCopyWith<$Res>(_value.dateTime, (value) {
      return _then(_value.copyWith(dateTime: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $CreatedCopyWith<$Res> get created {
    return $CreatedCopyWith<$Res>(_value.created, (value) {
      return _then(_value.copyWith(created: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $CreatedCopyWith<$Res> get updated {
    return $CreatedCopyWith<$Res>(_value.updated, (value) {
      return _then(_value.copyWith(updated: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FireImplCopyWith<$Res> implements $FireCopyWith<$Res> {
  factory _$$FireImplCopyWith(
          _$FireImpl value, $Res Function(_$FireImpl) then) =
      __$$FireImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      bool coords,
      Created dateTime,
      String date,
      String hour,
      String location,
      int aerial,
      int terrain,
      int man,
      String district,
      String concelho,
      String freguesia,
      String dico,
      double lat,
      double lng,
      String naturezaCode,
      String natureza,
      int statusCode,
      String statusColor,
      String status,
      bool important,
      bool active,
      String sadoId,
      int sharepointId,
      String? extra,
      bool disappear,
      Created created,
      Created updated,
      FireStatus? fireStatus});

  @override
  $CreatedCopyWith<$Res> get dateTime;
  @override
  $CreatedCopyWith<$Res> get created;
  @override
  $CreatedCopyWith<$Res> get updated;
}

/// @nodoc
class __$$FireImplCopyWithImpl<$Res>
    extends _$FireCopyWithImpl<$Res, _$FireImpl>
    implements _$$FireImplCopyWith<$Res> {
  __$$FireImplCopyWithImpl(_$FireImpl _value, $Res Function(_$FireImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? coords = null,
    Object? dateTime = null,
    Object? date = null,
    Object? hour = null,
    Object? location = null,
    Object? aerial = null,
    Object? terrain = null,
    Object? man = null,
    Object? district = null,
    Object? concelho = null,
    Object? freguesia = null,
    Object? dico = null,
    Object? lat = null,
    Object? lng = null,
    Object? naturezaCode = null,
    Object? natureza = null,
    Object? statusCode = null,
    Object? statusColor = null,
    Object? status = null,
    Object? important = null,
    Object? active = null,
    Object? sadoId = null,
    Object? sharepointId = null,
    Object? extra = freezed,
    Object? disappear = null,
    Object? created = null,
    Object? updated = null,
    Object? fireStatus = freezed,
  }) {
    return _then(_$FireImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      coords: null == coords
          ? _value.coords
          : coords // ignore: cast_nullable_to_non_nullable
              as bool,
      dateTime: null == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as Created,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      hour: null == hour
          ? _value.hour
          : hour // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      aerial: null == aerial
          ? _value.aerial
          : aerial // ignore: cast_nullable_to_non_nullable
              as int,
      terrain: null == terrain
          ? _value.terrain
          : terrain // ignore: cast_nullable_to_non_nullable
              as int,
      man: null == man
          ? _value.man
          : man // ignore: cast_nullable_to_non_nullable
              as int,
      district: null == district
          ? _value.district
          : district // ignore: cast_nullable_to_non_nullable
              as String,
      concelho: null == concelho
          ? _value.concelho
          : concelho // ignore: cast_nullable_to_non_nullable
              as String,
      freguesia: null == freguesia
          ? _value.freguesia
          : freguesia // ignore: cast_nullable_to_non_nullable
              as String,
      dico: null == dico
          ? _value.dico
          : dico // ignore: cast_nullable_to_non_nullable
              as String,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
      naturezaCode: null == naturezaCode
          ? _value.naturezaCode
          : naturezaCode // ignore: cast_nullable_to_non_nullable
              as String,
      natureza: null == natureza
          ? _value.natureza
          : natureza // ignore: cast_nullable_to_non_nullable
              as String,
      statusCode: null == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int,
      statusColor: null == statusColor
          ? _value.statusColor
          : statusColor // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      important: null == important
          ? _value.important
          : important // ignore: cast_nullable_to_non_nullable
              as bool,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
      sadoId: null == sadoId
          ? _value.sadoId
          : sadoId // ignore: cast_nullable_to_non_nullable
              as String,
      sharepointId: null == sharepointId
          ? _value.sharepointId
          : sharepointId // ignore: cast_nullable_to_non_nullable
              as int,
      extra: freezed == extra
          ? _value.extra
          : extra // ignore: cast_nullable_to_non_nullable
              as String?,
      disappear: null == disappear
          ? _value.disappear
          : disappear // ignore: cast_nullable_to_non_nullable
              as bool,
      created: null == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as Created,
      updated: null == updated
          ? _value.updated
          : updated // ignore: cast_nullable_to_non_nullable
              as Created,
      fireStatus: freezed == fireStatus
          ? _value.fireStatus
          : fireStatus // ignore: cast_nullable_to_non_nullable
              as FireStatus?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FireImpl implements _Fire {
  const _$FireImpl(
      {required this.id,
      required this.coords,
      required this.dateTime,
      required this.date,
      required this.hour,
      required this.location,
      required this.aerial,
      required this.terrain,
      required this.man,
      required this.district,
      required this.concelho,
      required this.freguesia,
      required this.dico,
      required this.lat,
      required this.lng,
      required this.naturezaCode,
      required this.natureza,
      required this.statusCode,
      required this.statusColor,
      required this.status,
      required this.important,
      required this.active,
      required this.sadoId,
      required this.sharepointId,
      this.extra,
      required this.disappear,
      required this.created,
      required this.updated,
      this.fireStatus});

  factory _$FireImpl.fromJson(Map<String, dynamic> json) =>
      _$$FireImplFromJson(json);

// @JsonKey(name: "_id") required Id id,
  @override
  final String id;
  @override
  final bool coords;
  @override
  final Created dateTime;
  @override
  final String date;
  @override
  final String hour;
  @override
  final String location;
  @override
  final int aerial;
  @override
  final int terrain;
// required int meiosAquaticos,
  @override
  final int man;
  @override
  final String district;
  @override
  final String concelho;
  @override
  final String freguesia;
  @override
  final String dico;
  @override
  final double lat;
  @override
  final double lng;
  @override
  final String naturezaCode;
// 3101, 3103, 3105, 3107
  @override
  final String natureza;
// required dynamic especieName,
// required dynamic familiaName,
  @override
  final int statusCode;
// 3, 4, 5, 6
  @override
  final String statusColor;
// Hexadecimal code representing colors, related with statusCode value.
  @override
  final String status;
  @override
  final bool important;
// required String localidade,
  @override
  final bool active;
  @override
  final String sadoId;
  @override
  final int sharepointId;
  @override
  final String? extra;
  @override
  final bool disappear;
// required Icnf? icnf,
// required String? detailLocation,
// required dynamic kml,
// required dynamic kmlVost,
// required dynamic pco,
// required dynamic cos,
// required int heliFight,
// required int heliCoord,
// required int planeFight,
// required bool anepcDirectUpdate,
// required String regiao,
// required String subRegiao,
  @override
  final Created created;
  @override
  final Created updated;
  @override
  final FireStatus? fireStatus;

  @override
  String toString() {
    return 'Fire(id: $id, coords: $coords, dateTime: $dateTime, date: $date, hour: $hour, location: $location, aerial: $aerial, terrain: $terrain, man: $man, district: $district, concelho: $concelho, freguesia: $freguesia, dico: $dico, lat: $lat, lng: $lng, naturezaCode: $naturezaCode, natureza: $natureza, statusCode: $statusCode, statusColor: $statusColor, status: $status, important: $important, active: $active, sadoId: $sadoId, sharepointId: $sharepointId, extra: $extra, disappear: $disappear, created: $created, updated: $updated, fireStatus: $fireStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FireImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.coords, coords) || other.coords == coords) &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.hour, hour) || other.hour == hour) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.aerial, aerial) || other.aerial == aerial) &&
            (identical(other.terrain, terrain) || other.terrain == terrain) &&
            (identical(other.man, man) || other.man == man) &&
            (identical(other.district, district) ||
                other.district == district) &&
            (identical(other.concelho, concelho) ||
                other.concelho == concelho) &&
            (identical(other.freguesia, freguesia) ||
                other.freguesia == freguesia) &&
            (identical(other.dico, dico) || other.dico == dico) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.naturezaCode, naturezaCode) ||
                other.naturezaCode == naturezaCode) &&
            (identical(other.natureza, natureza) ||
                other.natureza == natureza) &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.statusColor, statusColor) ||
                other.statusColor == statusColor) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.important, important) ||
                other.important == important) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.sadoId, sadoId) || other.sadoId == sadoId) &&
            (identical(other.sharepointId, sharepointId) ||
                other.sharepointId == sharepointId) &&
            (identical(other.extra, extra) || other.extra == extra) &&
            (identical(other.disappear, disappear) ||
                other.disappear == disappear) &&
            (identical(other.created, created) || other.created == created) &&
            (identical(other.updated, updated) || other.updated == updated) &&
            (identical(other.fireStatus, fireStatus) ||
                other.fireStatus == fireStatus));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        coords,
        dateTime,
        date,
        hour,
        location,
        aerial,
        terrain,
        man,
        district,
        concelho,
        freguesia,
        dico,
        lat,
        lng,
        naturezaCode,
        natureza,
        statusCode,
        statusColor,
        status,
        important,
        active,
        sadoId,
        sharepointId,
        extra,
        disappear,
        created,
        updated,
        fireStatus
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FireImplCopyWith<_$FireImpl> get copyWith =>
      __$$FireImplCopyWithImpl<_$FireImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FireImplToJson(
      this,
    );
  }
}

abstract class _Fire implements Fire {
  const factory _Fire(
      {required final String id,
      required final bool coords,
      required final Created dateTime,
      required final String date,
      required final String hour,
      required final String location,
      required final int aerial,
      required final int terrain,
      required final int man,
      required final String district,
      required final String concelho,
      required final String freguesia,
      required final String dico,
      required final double lat,
      required final double lng,
      required final String naturezaCode,
      required final String natureza,
      required final int statusCode,
      required final String statusColor,
      required final String status,
      required final bool important,
      required final bool active,
      required final String sadoId,
      required final int sharepointId,
      final String? extra,
      required final bool disappear,
      required final Created created,
      required final Created updated,
      final FireStatus? fireStatus}) = _$FireImpl;

  factory _Fire.fromJson(Map<String, dynamic> json) = _$FireImpl.fromJson;

  @override // @JsonKey(name: "_id") required Id id,
  String get id;
  @override
  bool get coords;
  @override
  Created get dateTime;
  @override
  String get date;
  @override
  String get hour;
  @override
  String get location;
  @override
  int get aerial;
  @override
  int get terrain;
  @override // required int meiosAquaticos,
  int get man;
  @override
  String get district;
  @override
  String get concelho;
  @override
  String get freguesia;
  @override
  String get dico;
  @override
  double get lat;
  @override
  double get lng;
  @override
  String get naturezaCode;
  @override // 3101, 3103, 3105, 3107
  String get natureza;
  @override // required dynamic especieName,
// required dynamic familiaName,
  int get statusCode;
  @override // 3, 4, 5, 6
  String get statusColor;
  @override // Hexadecimal code representing colors, related with statusCode value.
  String get status;
  @override
  bool get important;
  @override // required String localidade,
  bool get active;
  @override
  String get sadoId;
  @override
  int get sharepointId;
  @override
  String? get extra;
  @override
  bool get disappear;
  @override // required Icnf? icnf,
// required String? detailLocation,
// required dynamic kml,
// required dynamic kmlVost,
// required dynamic pco,
// required dynamic cos,
// required int heliFight,
// required int heliCoord,
// required int planeFight,
// required bool anepcDirectUpdate,
// required String regiao,
// required String subRegiao,
  Created get created;
  @override
  Created get updated;
  @override
  FireStatus? get fireStatus;
  @override
  @JsonKey(ignore: true)
  _$$FireImplCopyWith<_$FireImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
