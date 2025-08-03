// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ated.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Ated {

 int get sec;
/// Create a copy of Ated
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AtedCopyWith<Ated> get copyWith => _$AtedCopyWithImpl<Ated>(this as Ated, _$identity);

  /// Serializes this Ated to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Ated&&(identical(other.sec, sec) || other.sec == sec));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sec);

@override
String toString() {
  return 'Ated(sec: $sec)';
}


}

/// @nodoc
abstract mixin class $AtedCopyWith<$Res>  {
  factory $AtedCopyWith(Ated value, $Res Function(Ated) _then) = _$AtedCopyWithImpl;
@useResult
$Res call({
 int sec
});




}
/// @nodoc
class _$AtedCopyWithImpl<$Res>
    implements $AtedCopyWith<$Res> {
  _$AtedCopyWithImpl(this._self, this._then);

  final Ated _self;
  final $Res Function(Ated) _then;

/// Create a copy of Ated
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sec = null,}) {
  return _then(_self.copyWith(
sec: null == sec ? _self.sec : sec // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Ated].
extension AtedPatterns on Ated {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Ated value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Ated() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Ated value)  $default,){
final _that = this;
switch (_that) {
case _Ated():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Ated value)?  $default,){
final _that = this;
switch (_that) {
case _Ated() when $default != null:
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
case _Ated() when $default != null:
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
case _Ated():
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
case _Ated() when $default != null:
return $default(_that.sec);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Ated implements Ated {
  const _Ated({required this.sec});
  factory _Ated.fromJson(Map<String, dynamic> json) => _$AtedFromJson(json);

@override final  int sec;

/// Create a copy of Ated
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AtedCopyWith<_Ated> get copyWith => __$AtedCopyWithImpl<_Ated>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AtedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Ated&&(identical(other.sec, sec) || other.sec == sec));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sec);

@override
String toString() {
  return 'Ated(sec: $sec)';
}


}

/// @nodoc
abstract mixin class _$AtedCopyWith<$Res> implements $AtedCopyWith<$Res> {
  factory _$AtedCopyWith(_Ated value, $Res Function(_Ated) _then) = __$AtedCopyWithImpl;
@override @useResult
$Res call({
 int sec
});




}
/// @nodoc
class __$AtedCopyWithImpl<$Res>
    implements _$AtedCopyWith<$Res> {
  __$AtedCopyWithImpl(this._self, this._then);

  final _Ated _self;
  final $Res Function(_Ated) _then;

/// Create a copy of Ated
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sec = null,}) {
  return _then(_Ated(
sec: null == sec ? _self.sec : sec // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
