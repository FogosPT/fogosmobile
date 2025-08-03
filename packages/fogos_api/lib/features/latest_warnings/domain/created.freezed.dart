// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'created.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Created {

 int get sec;
/// Create a copy of Created
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreatedCopyWith<Created> get copyWith => _$CreatedCopyWithImpl<Created>(this as Created, _$identity);

  /// Serializes this Created to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Created&&(identical(other.sec, sec) || other.sec == sec));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sec);

@override
String toString() {
  return 'Created(sec: $sec)';
}


}

/// @nodoc
abstract mixin class $CreatedCopyWith<$Res>  {
  factory $CreatedCopyWith(Created value, $Res Function(Created) _then) = _$CreatedCopyWithImpl;
@useResult
$Res call({
 int sec
});




}
/// @nodoc
class _$CreatedCopyWithImpl<$Res>
    implements $CreatedCopyWith<$Res> {
  _$CreatedCopyWithImpl(this._self, this._then);

  final Created _self;
  final $Res Function(Created) _then;

/// Create a copy of Created
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sec = null,}) {
  return _then(_self.copyWith(
sec: null == sec ? _self.sec : sec // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Created].
extension CreatedPatterns on Created {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Created value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Created() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Created value)  $default,){
final _that = this;
switch (_that) {
case _Created():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Created value)?  $default,){
final _that = this;
switch (_that) {
case _Created() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int sec)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Created() when $default != null:
return $default(_that.sec);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int sec)  $default,) {final _that = this;
switch (_that) {
case _Created():
return $default(_that.sec);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int sec)?  $default,) {final _that = this;
switch (_that) {
case _Created() when $default != null:
return $default(_that.sec);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Created implements Created {
   _Created({required this.sec});
  factory _Created.fromJson(Map<String, dynamic> json) => _$CreatedFromJson(json);

@override final  int sec;

/// Create a copy of Created
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatedCopyWith<_Created> get copyWith => __$CreatedCopyWithImpl<_Created>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreatedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Created&&(identical(other.sec, sec) || other.sec == sec));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sec);

@override
String toString() {
  return 'Created(sec: $sec)';
}


}

/// @nodoc
abstract mixin class _$CreatedCopyWith<$Res> implements $CreatedCopyWith<$Res> {
  factory _$CreatedCopyWith(_Created value, $Res Function(_Created) _then) = __$CreatedCopyWithImpl;
@override @useResult
$Res call({
 int sec
});




}
/// @nodoc
class __$CreatedCopyWithImpl<$Res>
    implements _$CreatedCopyWith<$Res> {
  __$CreatedCopyWithImpl(this._self, this._then);

  final _Created _self;
  final $Res Function(_Created) _then;

/// Create a copy of Created
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sec = null,}) {
  return _then(_Created(
sec: null == sec ? _self.sec : sec // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
