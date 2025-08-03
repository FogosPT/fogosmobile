// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rcm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RCM {

// ignore: invalid_annotation_target
@JsonKey(name: '_id') String get id; String get concelho; DateTime get date; String get hoje; String get amanha; String get depois; String get depois2; String get depois3; String get dico; Ated get updated; Ated get created;
/// Create a copy of RCM
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RCMCopyWith<RCM> get copyWith => _$RCMCopyWithImpl<RCM>(this as RCM, _$identity);

  /// Serializes this RCM to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RCM&&(identical(other.id, id) || other.id == id)&&(identical(other.concelho, concelho) || other.concelho == concelho)&&(identical(other.date, date) || other.date == date)&&(identical(other.hoje, hoje) || other.hoje == hoje)&&(identical(other.amanha, amanha) || other.amanha == amanha)&&(identical(other.depois, depois) || other.depois == depois)&&(identical(other.depois2, depois2) || other.depois2 == depois2)&&(identical(other.depois3, depois3) || other.depois3 == depois3)&&(identical(other.dico, dico) || other.dico == dico)&&(identical(other.updated, updated) || other.updated == updated)&&(identical(other.created, created) || other.created == created));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,concelho,date,hoje,amanha,depois,depois2,depois3,dico,updated,created);

@override
String toString() {
  return 'RCM(id: $id, concelho: $concelho, date: $date, hoje: $hoje, amanha: $amanha, depois: $depois, depois2: $depois2, depois3: $depois3, dico: $dico, updated: $updated, created: $created)';
}


}

/// @nodoc
abstract mixin class $RCMCopyWith<$Res>  {
  factory $RCMCopyWith(RCM value, $Res Function(RCM) _then) = _$RCMCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '_id') String id, String concelho, DateTime date, String hoje, String amanha, String depois, String depois2, String depois3, String dico, Ated updated, Ated created
});


$AtedCopyWith<$Res> get updated;$AtedCopyWith<$Res> get created;

}
/// @nodoc
class _$RCMCopyWithImpl<$Res>
    implements $RCMCopyWith<$Res> {
  _$RCMCopyWithImpl(this._self, this._then);

  final RCM _self;
  final $Res Function(RCM) _then;

/// Create a copy of RCM
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? concelho = null,Object? date = null,Object? hoje = null,Object? amanha = null,Object? depois = null,Object? depois2 = null,Object? depois3 = null,Object? dico = null,Object? updated = null,Object? created = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,concelho: null == concelho ? _self.concelho : concelho // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,hoje: null == hoje ? _self.hoje : hoje // ignore: cast_nullable_to_non_nullable
as String,amanha: null == amanha ? _self.amanha : amanha // ignore: cast_nullable_to_non_nullable
as String,depois: null == depois ? _self.depois : depois // ignore: cast_nullable_to_non_nullable
as String,depois2: null == depois2 ? _self.depois2 : depois2 // ignore: cast_nullable_to_non_nullable
as String,depois3: null == depois3 ? _self.depois3 : depois3 // ignore: cast_nullable_to_non_nullable
as String,dico: null == dico ? _self.dico : dico // ignore: cast_nullable_to_non_nullable
as String,updated: null == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as Ated,created: null == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as Ated,
  ));
}
/// Create a copy of RCM
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AtedCopyWith<$Res> get updated {
  
  return $AtedCopyWith<$Res>(_self.updated, (value) {
    return _then(_self.copyWith(updated: value));
  });
}/// Create a copy of RCM
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AtedCopyWith<$Res> get created {
  
  return $AtedCopyWith<$Res>(_self.created, (value) {
    return _then(_self.copyWith(created: value));
  });
}
}


/// Adds pattern-matching-related methods to [RCM].
extension RCMPatterns on RCM {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RCM value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RCM() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RCM value)  $default,){
final _that = this;
switch (_that) {
case _RCM():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RCM value)?  $default,){
final _that = this;
switch (_that) {
case _RCM() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String concelho,  DateTime date,  String hoje,  String amanha,  String depois,  String depois2,  String depois3,  String dico,  Ated updated,  Ated created)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RCM() when $default != null:
return $default(_that.id,_that.concelho,_that.date,_that.hoje,_that.amanha,_that.depois,_that.depois2,_that.depois3,_that.dico,_that.updated,_that.created);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String concelho,  DateTime date,  String hoje,  String amanha,  String depois,  String depois2,  String depois3,  String dico,  Ated updated,  Ated created)  $default,) {final _that = this;
switch (_that) {
case _RCM():
return $default(_that.id,_that.concelho,_that.date,_that.hoje,_that.amanha,_that.depois,_that.depois2,_that.depois3,_that.dico,_that.updated,_that.created);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '_id')  String id,  String concelho,  DateTime date,  String hoje,  String amanha,  String depois,  String depois2,  String depois3,  String dico,  Ated updated,  Ated created)?  $default,) {final _that = this;
switch (_that) {
case _RCM() when $default != null:
return $default(_that.id,_that.concelho,_that.date,_that.hoje,_that.amanha,_that.depois,_that.depois2,_that.depois3,_that.dico,_that.updated,_that.created);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RCM implements RCM {
  const _RCM({@JsonKey(name: '_id') required this.id, required this.concelho, required this.date, required this.hoje, required this.amanha, required this.depois, required this.depois2, required this.depois3, required this.dico, required this.updated, required this.created});
  factory _RCM.fromJson(Map<String, dynamic> json) => _$RCMFromJson(json);

// ignore: invalid_annotation_target
@override@JsonKey(name: '_id') final  String id;
@override final  String concelho;
@override final  DateTime date;
@override final  String hoje;
@override final  String amanha;
@override final  String depois;
@override final  String depois2;
@override final  String depois3;
@override final  String dico;
@override final  Ated updated;
@override final  Ated created;

/// Create a copy of RCM
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RCMCopyWith<_RCM> get copyWith => __$RCMCopyWithImpl<_RCM>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RCMToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RCM&&(identical(other.id, id) || other.id == id)&&(identical(other.concelho, concelho) || other.concelho == concelho)&&(identical(other.date, date) || other.date == date)&&(identical(other.hoje, hoje) || other.hoje == hoje)&&(identical(other.amanha, amanha) || other.amanha == amanha)&&(identical(other.depois, depois) || other.depois == depois)&&(identical(other.depois2, depois2) || other.depois2 == depois2)&&(identical(other.depois3, depois3) || other.depois3 == depois3)&&(identical(other.dico, dico) || other.dico == dico)&&(identical(other.updated, updated) || other.updated == updated)&&(identical(other.created, created) || other.created == created));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,concelho,date,hoje,amanha,depois,depois2,depois3,dico,updated,created);

@override
String toString() {
  return 'RCM(id: $id, concelho: $concelho, date: $date, hoje: $hoje, amanha: $amanha, depois: $depois, depois2: $depois2, depois3: $depois3, dico: $dico, updated: $updated, created: $created)';
}


}

/// @nodoc
abstract mixin class _$RCMCopyWith<$Res> implements $RCMCopyWith<$Res> {
  factory _$RCMCopyWith(_RCM value, $Res Function(_RCM) _then) = __$RCMCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '_id') String id, String concelho, DateTime date, String hoje, String amanha, String depois, String depois2, String depois3, String dico, Ated updated, Ated created
});


@override $AtedCopyWith<$Res> get updated;@override $AtedCopyWith<$Res> get created;

}
/// @nodoc
class __$RCMCopyWithImpl<$Res>
    implements _$RCMCopyWith<$Res> {
  __$RCMCopyWithImpl(this._self, this._then);

  final _RCM _self;
  final $Res Function(_RCM) _then;

/// Create a copy of RCM
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? concelho = null,Object? date = null,Object? hoje = null,Object? amanha = null,Object? depois = null,Object? depois2 = null,Object? depois3 = null,Object? dico = null,Object? updated = null,Object? created = null,}) {
  return _then(_RCM(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,concelho: null == concelho ? _self.concelho : concelho // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,hoje: null == hoje ? _self.hoje : hoje // ignore: cast_nullable_to_non_nullable
as String,amanha: null == amanha ? _self.amanha : amanha // ignore: cast_nullable_to_non_nullable
as String,depois: null == depois ? _self.depois : depois // ignore: cast_nullable_to_non_nullable
as String,depois2: null == depois2 ? _self.depois2 : depois2 // ignore: cast_nullable_to_non_nullable
as String,depois3: null == depois3 ? _self.depois3 : depois3 // ignore: cast_nullable_to_non_nullable
as String,dico: null == dico ? _self.dico : dico // ignore: cast_nullable_to_non_nullable
as String,updated: null == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as Ated,created: null == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as Ated,
  ));
}

/// Create a copy of RCM
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AtedCopyWith<$Res> get updated {
  
  return $AtedCopyWith<$Res>(_self.updated, (value) {
    return _then(_self.copyWith(updated: value));
  });
}/// Create a copy of RCM
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AtedCopyWith<$Res> get created {
  
  return $AtedCopyWith<$Res>(_self.created, (value) {
    return _then(_self.copyWith(created: value));
  });
}
}

// dart format on
