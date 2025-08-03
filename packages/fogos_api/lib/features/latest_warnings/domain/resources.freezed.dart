// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resources.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Resources {

 String get label; int get man; int get terrain; int get aerial; int get created; String? get location; String? get personId; String? get id;
/// Create a copy of Resources
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResourcesCopyWith<Resources> get copyWith => _$ResourcesCopyWithImpl<Resources>(this as Resources, _$identity);

  /// Serializes this Resources to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Resources&&(identical(other.label, label) || other.label == label)&&(identical(other.man, man) || other.man == man)&&(identical(other.terrain, terrain) || other.terrain == terrain)&&(identical(other.aerial, aerial) || other.aerial == aerial)&&(identical(other.created, created) || other.created == created)&&(identical(other.location, location) || other.location == location)&&(identical(other.personId, personId) || other.personId == personId)&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,man,terrain,aerial,created,location,personId,id);

@override
String toString() {
  return 'Resources(label: $label, man: $man, terrain: $terrain, aerial: $aerial, created: $created, location: $location, personId: $personId, id: $id)';
}


}

/// @nodoc
abstract mixin class $ResourcesCopyWith<$Res>  {
  factory $ResourcesCopyWith(Resources value, $Res Function(Resources) _then) = _$ResourcesCopyWithImpl;
@useResult
$Res call({
 String label, int man, int terrain, int aerial, int created, String? location, String? personId, String? id
});




}
/// @nodoc
class _$ResourcesCopyWithImpl<$Res>
    implements $ResourcesCopyWith<$Res> {
  _$ResourcesCopyWithImpl(this._self, this._then);

  final Resources _self;
  final $Res Function(Resources) _then;

/// Create a copy of Resources
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? man = null,Object? terrain = null,Object? aerial = null,Object? created = null,Object? location = freezed,Object? personId = freezed,Object? id = freezed,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,man: null == man ? _self.man : man // ignore: cast_nullable_to_non_nullable
as int,terrain: null == terrain ? _self.terrain : terrain // ignore: cast_nullable_to_non_nullable
as int,aerial: null == aerial ? _self.aerial : aerial // ignore: cast_nullable_to_non_nullable
as int,created: null == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as int,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,personId: freezed == personId ? _self.personId : personId // ignore: cast_nullable_to_non_nullable
as String?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Resources].
extension ResourcesPatterns on Resources {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Resources value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Resources() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Resources value)  $default,){
final _that = this;
switch (_that) {
case _Resources():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Resources value)?  $default,){
final _that = this;
switch (_that) {
case _Resources() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  int man,  int terrain,  int aerial,  int created,  String? location,  String? personId,  String? id)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Resources() when $default != null:
return $default(_that.label,_that.man,_that.terrain,_that.aerial,_that.created,_that.location,_that.personId,_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  int man,  int terrain,  int aerial,  int created,  String? location,  String? personId,  String? id)  $default,) {final _that = this;
switch (_that) {
case _Resources():
return $default(_that.label,_that.man,_that.terrain,_that.aerial,_that.created,_that.location,_that.personId,_that.id);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  int man,  int terrain,  int aerial,  int created,  String? location,  String? personId,  String? id)?  $default,) {final _that = this;
switch (_that) {
case _Resources() when $default != null:
return $default(_that.label,_that.man,_that.terrain,_that.aerial,_that.created,_that.location,_that.personId,_that.id);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Resources implements Resources {
  const _Resources({required this.label, required this.man, required this.terrain, required this.aerial, required this.created, this.location, this.personId, this.id});
  factory _Resources.fromJson(Map<String, dynamic> json) => _$ResourcesFromJson(json);

@override final  String label;
@override final  int man;
@override final  int terrain;
@override final  int aerial;
@override final  int created;
@override final  String? location;
@override final  String? personId;
@override final  String? id;

/// Create a copy of Resources
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResourcesCopyWith<_Resources> get copyWith => __$ResourcesCopyWithImpl<_Resources>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResourcesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Resources&&(identical(other.label, label) || other.label == label)&&(identical(other.man, man) || other.man == man)&&(identical(other.terrain, terrain) || other.terrain == terrain)&&(identical(other.aerial, aerial) || other.aerial == aerial)&&(identical(other.created, created) || other.created == created)&&(identical(other.location, location) || other.location == location)&&(identical(other.personId, personId) || other.personId == personId)&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,man,terrain,aerial,created,location,personId,id);

@override
String toString() {
  return 'Resources(label: $label, man: $man, terrain: $terrain, aerial: $aerial, created: $created, location: $location, personId: $personId, id: $id)';
}


}

/// @nodoc
abstract mixin class _$ResourcesCopyWith<$Res> implements $ResourcesCopyWith<$Res> {
  factory _$ResourcesCopyWith(_Resources value, $Res Function(_Resources) _then) = __$ResourcesCopyWithImpl;
@override @useResult
$Res call({
 String label, int man, int terrain, int aerial, int created, String? location, String? personId, String? id
});




}
/// @nodoc
class __$ResourcesCopyWithImpl<$Res>
    implements _$ResourcesCopyWith<$Res> {
  __$ResourcesCopyWithImpl(this._self, this._then);

  final _Resources _self;
  final $Res Function(_Resources) _then;

/// Create a copy of Resources
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? man = null,Object? terrain = null,Object? aerial = null,Object? created = null,Object? location = freezed,Object? personId = freezed,Object? id = freezed,}) {
  return _then(_Resources(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,man: null == man ? _self.man : man // ignore: cast_nullable_to_non_nullable
as int,terrain: null == terrain ? _self.terrain : terrain // ignore: cast_nullable_to_non_nullable
as int,aerial: null == aerial ? _self.aerial : aerial // ignore: cast_nullable_to_non_nullable
as int,created: null == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as int,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,personId: freezed == personId ? _self.personId : personId // ignore: cast_nullable_to_non_nullable
as String?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
