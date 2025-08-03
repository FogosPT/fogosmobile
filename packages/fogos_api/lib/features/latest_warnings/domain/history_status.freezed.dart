// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HistoryStatus {

 String? get id; int? get sharepointId; String? get location; String get status; int get statusCode; String get label; dynamic get created; Ated? get updated;
/// Create a copy of HistoryStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryStatusCopyWith<HistoryStatus> get copyWith => _$HistoryStatusCopyWithImpl<HistoryStatus>(this as HistoryStatus, _$identity);

  /// Serializes this HistoryStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryStatus&&(identical(other.id, id) || other.id == id)&&(identical(other.sharepointId, sharepointId) || other.sharepointId == sharepointId)&&(identical(other.location, location) || other.location == location)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.label, label) || other.label == label)&&const DeepCollectionEquality().equals(other.created, created)&&(identical(other.updated, updated) || other.updated == updated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sharepointId,location,status,statusCode,label,const DeepCollectionEquality().hash(created),updated);

@override
String toString() {
  return 'HistoryStatus(id: $id, sharepointId: $sharepointId, location: $location, status: $status, statusCode: $statusCode, label: $label, created: $created, updated: $updated)';
}


}

/// @nodoc
abstract mixin class $HistoryStatusCopyWith<$Res>  {
  factory $HistoryStatusCopyWith(HistoryStatus value, $Res Function(HistoryStatus) _then) = _$HistoryStatusCopyWithImpl;
@useResult
$Res call({
 String? id, int? sharepointId, String? location, String status, int statusCode, String label, dynamic created, Ated? updated
});


$AtedCopyWith<$Res>? get updated;

}
/// @nodoc
class _$HistoryStatusCopyWithImpl<$Res>
    implements $HistoryStatusCopyWith<$Res> {
  _$HistoryStatusCopyWithImpl(this._self, this._then);

  final HistoryStatus _self;
  final $Res Function(HistoryStatus) _then;

/// Create a copy of HistoryStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? sharepointId = freezed,Object? location = freezed,Object? status = null,Object? statusCode = null,Object? label = null,Object? created = freezed,Object? updated = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,sharepointId: freezed == sharepointId ? _self.sharepointId : sharepointId // ignore: cast_nullable_to_non_nullable
as int?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,created: freezed == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as dynamic,updated: freezed == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as Ated?,
  ));
}
/// Create a copy of HistoryStatus
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AtedCopyWith<$Res>? get updated {
    if (_self.updated == null) {
    return null;
  }

  return $AtedCopyWith<$Res>(_self.updated!, (value) {
    return _then(_self.copyWith(updated: value));
  });
}
}


/// Adds pattern-matching-related methods to [HistoryStatus].
extension HistoryStatusPatterns on HistoryStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistoryStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistoryStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistoryStatus value)  $default,){
final _that = this;
switch (_that) {
case _HistoryStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistoryStatus value)?  $default,){
final _that = this;
switch (_that) {
case _HistoryStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  int? sharepointId,  String? location,  String status,  int statusCode,  String label,  dynamic created,  Ated? updated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistoryStatus() when $default != null:
return $default(_that.id,_that.sharepointId,_that.location,_that.status,_that.statusCode,_that.label,_that.created,_that.updated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  int? sharepointId,  String? location,  String status,  int statusCode,  String label,  dynamic created,  Ated? updated)  $default,) {final _that = this;
switch (_that) {
case _HistoryStatus():
return $default(_that.id,_that.sharepointId,_that.location,_that.status,_that.statusCode,_that.label,_that.created,_that.updated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  int? sharepointId,  String? location,  String status,  int statusCode,  String label,  dynamic created,  Ated? updated)?  $default,) {final _that = this;
switch (_that) {
case _HistoryStatus() when $default != null:
return $default(_that.id,_that.sharepointId,_that.location,_that.status,_that.statusCode,_that.label,_that.created,_that.updated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HistoryStatus implements HistoryStatus {
  const _HistoryStatus({this.id, this.sharepointId, this.location, required this.status, required this.statusCode, required this.label, required this.created, this.updated});
  factory _HistoryStatus.fromJson(Map<String, dynamic> json) => _$HistoryStatusFromJson(json);

@override final  String? id;
@override final  int? sharepointId;
@override final  String? location;
@override final  String status;
@override final  int statusCode;
@override final  String label;
@override final  dynamic created;
@override final  Ated? updated;

/// Create a copy of HistoryStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoryStatusCopyWith<_HistoryStatus> get copyWith => __$HistoryStatusCopyWithImpl<_HistoryStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HistoryStatusToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryStatus&&(identical(other.id, id) || other.id == id)&&(identical(other.sharepointId, sharepointId) || other.sharepointId == sharepointId)&&(identical(other.location, location) || other.location == location)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.label, label) || other.label == label)&&const DeepCollectionEquality().equals(other.created, created)&&(identical(other.updated, updated) || other.updated == updated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sharepointId,location,status,statusCode,label,const DeepCollectionEquality().hash(created),updated);

@override
String toString() {
  return 'HistoryStatus(id: $id, sharepointId: $sharepointId, location: $location, status: $status, statusCode: $statusCode, label: $label, created: $created, updated: $updated)';
}


}

/// @nodoc
abstract mixin class _$HistoryStatusCopyWith<$Res> implements $HistoryStatusCopyWith<$Res> {
  factory _$HistoryStatusCopyWith(_HistoryStatus value, $Res Function(_HistoryStatus) _then) = __$HistoryStatusCopyWithImpl;
@override @useResult
$Res call({
 String? id, int? sharepointId, String? location, String status, int statusCode, String label, dynamic created, Ated? updated
});


@override $AtedCopyWith<$Res>? get updated;

}
/// @nodoc
class __$HistoryStatusCopyWithImpl<$Res>
    implements _$HistoryStatusCopyWith<$Res> {
  __$HistoryStatusCopyWithImpl(this._self, this._then);

  final _HistoryStatus _self;
  final $Res Function(_HistoryStatus) _then;

/// Create a copy of HistoryStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? sharepointId = freezed,Object? location = freezed,Object? status = null,Object? statusCode = null,Object? label = null,Object? created = freezed,Object? updated = freezed,}) {
  return _then(_HistoryStatus(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,sharepointId: freezed == sharepointId ? _self.sharepointId : sharepointId // ignore: cast_nullable_to_non_nullable
as int?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,created: freezed == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as dynamic,updated: freezed == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as Ated?,
  ));
}

/// Create a copy of HistoryStatus
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AtedCopyWith<$Res>? get updated {
    if (_self.updated == null) {
    return null;
  }

  return $AtedCopyWith<$Res>(_self.updated!, (value) {
    return _then(_self.copyWith(updated: value));
  });
}
}

// dart format on
