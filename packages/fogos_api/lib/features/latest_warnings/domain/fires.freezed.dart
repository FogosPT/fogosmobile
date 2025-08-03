// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fires.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Fires {

 bool get success; List<Fire> get data;
/// Create a copy of Fires
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FiresCopyWith<Fires> get copyWith => _$FiresCopyWithImpl<Fires>(this as Fires, _$identity);

  /// Serializes this Fires to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Fires&&(identical(other.success, success) || other.success == success)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'Fires(success: $success, data: $data)';
}


}

/// @nodoc
abstract mixin class $FiresCopyWith<$Res>  {
  factory $FiresCopyWith(Fires value, $Res Function(Fires) _then) = _$FiresCopyWithImpl;
@useResult
$Res call({
 bool success, List<Fire> data
});




}
/// @nodoc
class _$FiresCopyWithImpl<$Res>
    implements $FiresCopyWith<$Res> {
  _$FiresCopyWithImpl(this._self, this._then);

  final Fires _self;
  final $Res Function(Fires) _then;

/// Create a copy of Fires
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? data = null,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<Fire>,
  ));
}

}


/// Adds pattern-matching-related methods to [Fires].
extension FiresPatterns on Fires {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Fires value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Fires() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Fires value)  $default,){
final _that = this;
switch (_that) {
case _Fires():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Fires value)?  $default,){
final _that = this;
switch (_that) {
case _Fires() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  List<Fire> data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Fires() when $default != null:
return $default(_that.success,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  List<Fire> data)  $default,) {final _that = this;
switch (_that) {
case _Fires():
return $default(_that.success,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  List<Fire> data)?  $default,) {final _that = this;
switch (_that) {
case _Fires() when $default != null:
return $default(_that.success,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Fires implements Fires {
  const _Fires({required this.success, required final  List<Fire> data}): _data = data;
  factory _Fires.fromJson(Map<String, dynamic> json) => _$FiresFromJson(json);

@override final  bool success;
 final  List<Fire> _data;
@override List<Fire> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of Fires
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FiresCopyWith<_Fires> get copyWith => __$FiresCopyWithImpl<_Fires>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FiresToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Fires&&(identical(other.success, success) || other.success == success)&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'Fires(success: $success, data: $data)';
}


}

/// @nodoc
abstract mixin class _$FiresCopyWith<$Res> implements $FiresCopyWith<$Res> {
  factory _$FiresCopyWith(_Fires value, $Res Function(_Fires) _then) = __$FiresCopyWithImpl;
@override @useResult
$Res call({
 bool success, List<Fire> data
});




}
/// @nodoc
class __$FiresCopyWithImpl<$Res>
    implements _$FiresCopyWith<$Res> {
  __$FiresCopyWithImpl(this._self, this._then);

  final _Fires _self;
  final $Res Function(_Fires) _then;

/// Create a copy of Fires
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? data = null,}) {
  return _then(_Fires(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<Fire>,
  ));
}


}

// dart format on
