// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fire.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Fire {

// @JsonKey(name: "_id") required Id id,
 String get id; bool get coords; Created get dateTime; String get date; String get hour; String get location; int get aerial; int get terrain;// required int meiosAquaticos,
 int get man; String get district; String get concelho; String get freguesia; String get dico; double get lat; double get lng; String get naturezaCode;// 3101, 3103, 3105, 3107
 String get natureza;// required dynamic especieName,
// required dynamic familiaName,
 int get statusCode;// 3, 4, 5, 6
 String get statusColor;// Hexadecimal code representing colors, related with statusCode value.
 String get status; bool get important;// required String localidade,
 bool get active; String get sadoId; int get sharepointId; String? get extra; bool get disappear;// required Icnf? icnf,
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
 Created get created; Created get updated; FireStatus? get fireStatus;
/// Create a copy of Fire
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FireCopyWith<Fire> get copyWith => _$FireCopyWithImpl<Fire>(this as Fire, _$identity);

  /// Serializes this Fire to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Fire&&(identical(other.id, id) || other.id == id)&&(identical(other.coords, coords) || other.coords == coords)&&(identical(other.dateTime, dateTime) || other.dateTime == dateTime)&&(identical(other.date, date) || other.date == date)&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.location, location) || other.location == location)&&(identical(other.aerial, aerial) || other.aerial == aerial)&&(identical(other.terrain, terrain) || other.terrain == terrain)&&(identical(other.man, man) || other.man == man)&&(identical(other.district, district) || other.district == district)&&(identical(other.concelho, concelho) || other.concelho == concelho)&&(identical(other.freguesia, freguesia) || other.freguesia == freguesia)&&(identical(other.dico, dico) || other.dico == dico)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.naturezaCode, naturezaCode) || other.naturezaCode == naturezaCode)&&(identical(other.natureza, natureza) || other.natureza == natureza)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.statusColor, statusColor) || other.statusColor == statusColor)&&(identical(other.status, status) || other.status == status)&&(identical(other.important, important) || other.important == important)&&(identical(other.active, active) || other.active == active)&&(identical(other.sadoId, sadoId) || other.sadoId == sadoId)&&(identical(other.sharepointId, sharepointId) || other.sharepointId == sharepointId)&&(identical(other.extra, extra) || other.extra == extra)&&(identical(other.disappear, disappear) || other.disappear == disappear)&&(identical(other.created, created) || other.created == created)&&(identical(other.updated, updated) || other.updated == updated)&&(identical(other.fireStatus, fireStatus) || other.fireStatus == fireStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,coords,dateTime,date,hour,location,aerial,terrain,man,district,concelho,freguesia,dico,lat,lng,naturezaCode,natureza,statusCode,statusColor,status,important,active,sadoId,sharepointId,extra,disappear,created,updated,fireStatus]);

@override
String toString() {
  return 'Fire(id: $id, coords: $coords, dateTime: $dateTime, date: $date, hour: $hour, location: $location, aerial: $aerial, terrain: $terrain, man: $man, district: $district, concelho: $concelho, freguesia: $freguesia, dico: $dico, lat: $lat, lng: $lng, naturezaCode: $naturezaCode, natureza: $natureza, statusCode: $statusCode, statusColor: $statusColor, status: $status, important: $important, active: $active, sadoId: $sadoId, sharepointId: $sharepointId, extra: $extra, disappear: $disappear, created: $created, updated: $updated, fireStatus: $fireStatus)';
}


}

/// @nodoc
abstract mixin class $FireCopyWith<$Res>  {
  factory $FireCopyWith(Fire value, $Res Function(Fire) _then) = _$FireCopyWithImpl;
@useResult
$Res call({
 String id, bool coords, Created dateTime, String date, String hour, String location, int aerial, int terrain, int man, String district, String concelho, String freguesia, String dico, double lat, double lng, String naturezaCode, String natureza, int statusCode, String statusColor, String status, bool important, bool active, String sadoId, int sharepointId, String? extra, bool disappear, Created created, Created updated, FireStatus? fireStatus
});


$CreatedCopyWith<$Res> get dateTime;$CreatedCopyWith<$Res> get created;$CreatedCopyWith<$Res> get updated;

}
/// @nodoc
class _$FireCopyWithImpl<$Res>
    implements $FireCopyWith<$Res> {
  _$FireCopyWithImpl(this._self, this._then);

  final Fire _self;
  final $Res Function(Fire) _then;

/// Create a copy of Fire
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? coords = null,Object? dateTime = null,Object? date = null,Object? hour = null,Object? location = null,Object? aerial = null,Object? terrain = null,Object? man = null,Object? district = null,Object? concelho = null,Object? freguesia = null,Object? dico = null,Object? lat = null,Object? lng = null,Object? naturezaCode = null,Object? natureza = null,Object? statusCode = null,Object? statusColor = null,Object? status = null,Object? important = null,Object? active = null,Object? sadoId = null,Object? sharepointId = null,Object? extra = freezed,Object? disappear = null,Object? created = null,Object? updated = null,Object? fireStatus = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,coords: null == coords ? _self.coords : coords // ignore: cast_nullable_to_non_nullable
as bool,dateTime: null == dateTime ? _self.dateTime : dateTime // ignore: cast_nullable_to_non_nullable
as Created,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,aerial: null == aerial ? _self.aerial : aerial // ignore: cast_nullable_to_non_nullable
as int,terrain: null == terrain ? _self.terrain : terrain // ignore: cast_nullable_to_non_nullable
as int,man: null == man ? _self.man : man // ignore: cast_nullable_to_non_nullable
as int,district: null == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String,concelho: null == concelho ? _self.concelho : concelho // ignore: cast_nullable_to_non_nullable
as String,freguesia: null == freguesia ? _self.freguesia : freguesia // ignore: cast_nullable_to_non_nullable
as String,dico: null == dico ? _self.dico : dico // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,naturezaCode: null == naturezaCode ? _self.naturezaCode : naturezaCode // ignore: cast_nullable_to_non_nullable
as String,natureza: null == natureza ? _self.natureza : natureza // ignore: cast_nullable_to_non_nullable
as String,statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,statusColor: null == statusColor ? _self.statusColor : statusColor // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,important: null == important ? _self.important : important // ignore: cast_nullable_to_non_nullable
as bool,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,sadoId: null == sadoId ? _self.sadoId : sadoId // ignore: cast_nullable_to_non_nullable
as String,sharepointId: null == sharepointId ? _self.sharepointId : sharepointId // ignore: cast_nullable_to_non_nullable
as int,extra: freezed == extra ? _self.extra : extra // ignore: cast_nullable_to_non_nullable
as String?,disappear: null == disappear ? _self.disappear : disappear // ignore: cast_nullable_to_non_nullable
as bool,created: null == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as Created,updated: null == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as Created,fireStatus: freezed == fireStatus ? _self.fireStatus : fireStatus // ignore: cast_nullable_to_non_nullable
as FireStatus?,
  ));
}
/// Create a copy of Fire
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CreatedCopyWith<$Res> get dateTime {
  
  return $CreatedCopyWith<$Res>(_self.dateTime, (value) {
    return _then(_self.copyWith(dateTime: value));
  });
}/// Create a copy of Fire
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CreatedCopyWith<$Res> get created {
  
  return $CreatedCopyWith<$Res>(_self.created, (value) {
    return _then(_self.copyWith(created: value));
  });
}/// Create a copy of Fire
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CreatedCopyWith<$Res> get updated {
  
  return $CreatedCopyWith<$Res>(_self.updated, (value) {
    return _then(_self.copyWith(updated: value));
  });
}
}


/// Adds pattern-matching-related methods to [Fire].
extension FirePatterns on Fire {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Fire value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Fire() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Fire value)  $default,){
final _that = this;
switch (_that) {
case _Fire():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Fire value)?  $default,){
final _that = this;
switch (_that) {
case _Fire() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  bool coords,  Created dateTime,  String date,  String hour,  String location,  int aerial,  int terrain,  int man,  String district,  String concelho,  String freguesia,  String dico,  double lat,  double lng,  String naturezaCode,  String natureza,  int statusCode,  String statusColor,  String status,  bool important,  bool active,  String sadoId,  int sharepointId,  String? extra,  bool disappear,  Created created,  Created updated,  FireStatus? fireStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Fire() when $default != null:
return $default(_that.id,_that.coords,_that.dateTime,_that.date,_that.hour,_that.location,_that.aerial,_that.terrain,_that.man,_that.district,_that.concelho,_that.freguesia,_that.dico,_that.lat,_that.lng,_that.naturezaCode,_that.natureza,_that.statusCode,_that.statusColor,_that.status,_that.important,_that.active,_that.sadoId,_that.sharepointId,_that.extra,_that.disappear,_that.created,_that.updated,_that.fireStatus);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  bool coords,  Created dateTime,  String date,  String hour,  String location,  int aerial,  int terrain,  int man,  String district,  String concelho,  String freguesia,  String dico,  double lat,  double lng,  String naturezaCode,  String natureza,  int statusCode,  String statusColor,  String status,  bool important,  bool active,  String sadoId,  int sharepointId,  String? extra,  bool disappear,  Created created,  Created updated,  FireStatus? fireStatus)  $default,) {final _that = this;
switch (_that) {
case _Fire():
return $default(_that.id,_that.coords,_that.dateTime,_that.date,_that.hour,_that.location,_that.aerial,_that.terrain,_that.man,_that.district,_that.concelho,_that.freguesia,_that.dico,_that.lat,_that.lng,_that.naturezaCode,_that.natureza,_that.statusCode,_that.statusColor,_that.status,_that.important,_that.active,_that.sadoId,_that.sharepointId,_that.extra,_that.disappear,_that.created,_that.updated,_that.fireStatus);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  bool coords,  Created dateTime,  String date,  String hour,  String location,  int aerial,  int terrain,  int man,  String district,  String concelho,  String freguesia,  String dico,  double lat,  double lng,  String naturezaCode,  String natureza,  int statusCode,  String statusColor,  String status,  bool important,  bool active,  String sadoId,  int sharepointId,  String? extra,  bool disappear,  Created created,  Created updated,  FireStatus? fireStatus)?  $default,) {final _that = this;
switch (_that) {
case _Fire() when $default != null:
return $default(_that.id,_that.coords,_that.dateTime,_that.date,_that.hour,_that.location,_that.aerial,_that.terrain,_that.man,_that.district,_that.concelho,_that.freguesia,_that.dico,_that.lat,_that.lng,_that.naturezaCode,_that.natureza,_that.statusCode,_that.statusColor,_that.status,_that.important,_that.active,_that.sadoId,_that.sharepointId,_that.extra,_that.disappear,_that.created,_that.updated,_that.fireStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Fire implements Fire {
  const _Fire({required this.id, required this.coords, required this.dateTime, required this.date, required this.hour, required this.location, required this.aerial, required this.terrain, required this.man, required this.district, required this.concelho, required this.freguesia, required this.dico, required this.lat, required this.lng, required this.naturezaCode, required this.natureza, required this.statusCode, required this.statusColor, required this.status, required this.important, required this.active, required this.sadoId, required this.sharepointId, this.extra, required this.disappear, required this.created, required this.updated, this.fireStatus});
  factory _Fire.fromJson(Map<String, dynamic> json) => _$FireFromJson(json);

// @JsonKey(name: "_id") required Id id,
@override final  String id;
@override final  bool coords;
@override final  Created dateTime;
@override final  String date;
@override final  String hour;
@override final  String location;
@override final  int aerial;
@override final  int terrain;
// required int meiosAquaticos,
@override final  int man;
@override final  String district;
@override final  String concelho;
@override final  String freguesia;
@override final  String dico;
@override final  double lat;
@override final  double lng;
@override final  String naturezaCode;
// 3101, 3103, 3105, 3107
@override final  String natureza;
// required dynamic especieName,
// required dynamic familiaName,
@override final  int statusCode;
// 3, 4, 5, 6
@override final  String statusColor;
// Hexadecimal code representing colors, related with statusCode value.
@override final  String status;
@override final  bool important;
// required String localidade,
@override final  bool active;
@override final  String sadoId;
@override final  int sharepointId;
@override final  String? extra;
@override final  bool disappear;
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
@override final  Created created;
@override final  Created updated;
@override final  FireStatus? fireStatus;

/// Create a copy of Fire
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FireCopyWith<_Fire> get copyWith => __$FireCopyWithImpl<_Fire>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FireToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Fire&&(identical(other.id, id) || other.id == id)&&(identical(other.coords, coords) || other.coords == coords)&&(identical(other.dateTime, dateTime) || other.dateTime == dateTime)&&(identical(other.date, date) || other.date == date)&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.location, location) || other.location == location)&&(identical(other.aerial, aerial) || other.aerial == aerial)&&(identical(other.terrain, terrain) || other.terrain == terrain)&&(identical(other.man, man) || other.man == man)&&(identical(other.district, district) || other.district == district)&&(identical(other.concelho, concelho) || other.concelho == concelho)&&(identical(other.freguesia, freguesia) || other.freguesia == freguesia)&&(identical(other.dico, dico) || other.dico == dico)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.naturezaCode, naturezaCode) || other.naturezaCode == naturezaCode)&&(identical(other.natureza, natureza) || other.natureza == natureza)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.statusColor, statusColor) || other.statusColor == statusColor)&&(identical(other.status, status) || other.status == status)&&(identical(other.important, important) || other.important == important)&&(identical(other.active, active) || other.active == active)&&(identical(other.sadoId, sadoId) || other.sadoId == sadoId)&&(identical(other.sharepointId, sharepointId) || other.sharepointId == sharepointId)&&(identical(other.extra, extra) || other.extra == extra)&&(identical(other.disappear, disappear) || other.disappear == disappear)&&(identical(other.created, created) || other.created == created)&&(identical(other.updated, updated) || other.updated == updated)&&(identical(other.fireStatus, fireStatus) || other.fireStatus == fireStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,coords,dateTime,date,hour,location,aerial,terrain,man,district,concelho,freguesia,dico,lat,lng,naturezaCode,natureza,statusCode,statusColor,status,important,active,sadoId,sharepointId,extra,disappear,created,updated,fireStatus]);

@override
String toString() {
  return 'Fire(id: $id, coords: $coords, dateTime: $dateTime, date: $date, hour: $hour, location: $location, aerial: $aerial, terrain: $terrain, man: $man, district: $district, concelho: $concelho, freguesia: $freguesia, dico: $dico, lat: $lat, lng: $lng, naturezaCode: $naturezaCode, natureza: $natureza, statusCode: $statusCode, statusColor: $statusColor, status: $status, important: $important, active: $active, sadoId: $sadoId, sharepointId: $sharepointId, extra: $extra, disappear: $disappear, created: $created, updated: $updated, fireStatus: $fireStatus)';
}


}

/// @nodoc
abstract mixin class _$FireCopyWith<$Res> implements $FireCopyWith<$Res> {
  factory _$FireCopyWith(_Fire value, $Res Function(_Fire) _then) = __$FireCopyWithImpl;
@override @useResult
$Res call({
 String id, bool coords, Created dateTime, String date, String hour, String location, int aerial, int terrain, int man, String district, String concelho, String freguesia, String dico, double lat, double lng, String naturezaCode, String natureza, int statusCode, String statusColor, String status, bool important, bool active, String sadoId, int sharepointId, String? extra, bool disappear, Created created, Created updated, FireStatus? fireStatus
});


@override $CreatedCopyWith<$Res> get dateTime;@override $CreatedCopyWith<$Res> get created;@override $CreatedCopyWith<$Res> get updated;

}
/// @nodoc
class __$FireCopyWithImpl<$Res>
    implements _$FireCopyWith<$Res> {
  __$FireCopyWithImpl(this._self, this._then);

  final _Fire _self;
  final $Res Function(_Fire) _then;

/// Create a copy of Fire
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? coords = null,Object? dateTime = null,Object? date = null,Object? hour = null,Object? location = null,Object? aerial = null,Object? terrain = null,Object? man = null,Object? district = null,Object? concelho = null,Object? freguesia = null,Object? dico = null,Object? lat = null,Object? lng = null,Object? naturezaCode = null,Object? natureza = null,Object? statusCode = null,Object? statusColor = null,Object? status = null,Object? important = null,Object? active = null,Object? sadoId = null,Object? sharepointId = null,Object? extra = freezed,Object? disappear = null,Object? created = null,Object? updated = null,Object? fireStatus = freezed,}) {
  return _then(_Fire(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,coords: null == coords ? _self.coords : coords // ignore: cast_nullable_to_non_nullable
as bool,dateTime: null == dateTime ? _self.dateTime : dateTime // ignore: cast_nullable_to_non_nullable
as Created,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,aerial: null == aerial ? _self.aerial : aerial // ignore: cast_nullable_to_non_nullable
as int,terrain: null == terrain ? _self.terrain : terrain // ignore: cast_nullable_to_non_nullable
as int,man: null == man ? _self.man : man // ignore: cast_nullable_to_non_nullable
as int,district: null == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String,concelho: null == concelho ? _self.concelho : concelho // ignore: cast_nullable_to_non_nullable
as String,freguesia: null == freguesia ? _self.freguesia : freguesia // ignore: cast_nullable_to_non_nullable
as String,dico: null == dico ? _self.dico : dico // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,naturezaCode: null == naturezaCode ? _self.naturezaCode : naturezaCode // ignore: cast_nullable_to_non_nullable
as String,natureza: null == natureza ? _self.natureza : natureza // ignore: cast_nullable_to_non_nullable
as String,statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,statusColor: null == statusColor ? _self.statusColor : statusColor // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,important: null == important ? _self.important : important // ignore: cast_nullable_to_non_nullable
as bool,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,sadoId: null == sadoId ? _self.sadoId : sadoId // ignore: cast_nullable_to_non_nullable
as String,sharepointId: null == sharepointId ? _self.sharepointId : sharepointId // ignore: cast_nullable_to_non_nullable
as int,extra: freezed == extra ? _self.extra : extra // ignore: cast_nullable_to_non_nullable
as String?,disappear: null == disappear ? _self.disappear : disappear // ignore: cast_nullable_to_non_nullable
as bool,created: null == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as Created,updated: null == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as Created,fireStatus: freezed == fireStatus ? _self.fireStatus : fireStatus // ignore: cast_nullable_to_non_nullable
as FireStatus?,
  ));
}

/// Create a copy of Fire
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CreatedCopyWith<$Res> get dateTime {
  
  return $CreatedCopyWith<$Res>(_self.dateTime, (value) {
    return _then(_self.copyWith(dateTime: value));
  });
}/// Create a copy of Fire
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CreatedCopyWith<$Res> get created {
  
  return $CreatedCopyWith<$Res>(_self.created, (value) {
    return _then(_self.copyWith(created: value));
  });
}/// Create a copy of Fire
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CreatedCopyWith<$Res> get updated {
  
  return $CreatedCopyWith<$Res>(_self.updated, (value) {
    return _then(_self.copyWith(updated: value));
  });
}
}

// dart format on
