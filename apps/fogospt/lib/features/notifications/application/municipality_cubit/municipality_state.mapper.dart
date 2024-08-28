// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'municipality_state.dart';

class MunicipalityStateMapper extends ClassMapperBase<MunicipalityState> {
  MunicipalityStateMapper._();

  static MunicipalityStateMapper? _instance;
  static MunicipalityStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MunicipalityStateMapper._());
      MunicipalityStateInitialMapper.ensureInitialized();
      MunicipalityStateLoadingMapper.ensureInitialized();
      MunicipalityStateLoadedMapper.ensureInitialized();
      MunicipalityStateFailedMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MunicipalityState';

  @override
  final MappableFields<MunicipalityState> fields = const {};

  static MunicipalityState _instantiate(DecodingData data) {
    throw MapperException.missingConstructor('MunicipalityState');
  }

  @override
  final Function instantiate = _instantiate;

  static MunicipalityState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MunicipalityState>(map);
  }

  static MunicipalityState fromJson(String json) {
    return ensureInitialized().decodeJson<MunicipalityState>(json);
  }
}

mixin MunicipalityStateMappable {
  String toJson();
  Map<String, dynamic> toMap();
  MunicipalityStateCopyWith<MunicipalityState, MunicipalityState,
      MunicipalityState> get copyWith;
}

abstract class MunicipalityStateCopyWith<$R, $In extends MunicipalityState,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  MunicipalityStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class MunicipalityStateInitialMapper
    extends ClassMapperBase<MunicipalityStateInitial> {
  MunicipalityStateInitialMapper._();

  static MunicipalityStateInitialMapper? _instance;
  static MunicipalityStateInitialMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = MunicipalityStateInitialMapper._());
      MunicipalityStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MunicipalityStateInitial';

  @override
  final MappableFields<MunicipalityStateInitial> fields = const {};

  static MunicipalityStateInitial _instantiate(DecodingData data) {
    return MunicipalityStateInitial();
  }

  @override
  final Function instantiate = _instantiate;

  static MunicipalityStateInitial fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MunicipalityStateInitial>(map);
  }

  static MunicipalityStateInitial fromJson(String json) {
    return ensureInitialized().decodeJson<MunicipalityStateInitial>(json);
  }
}

mixin MunicipalityStateInitialMappable {
  String toJson() {
    return MunicipalityStateInitialMapper.ensureInitialized()
        .encodeJson<MunicipalityStateInitial>(this as MunicipalityStateInitial);
  }

  Map<String, dynamic> toMap() {
    return MunicipalityStateInitialMapper.ensureInitialized()
        .encodeMap<MunicipalityStateInitial>(this as MunicipalityStateInitial);
  }

  MunicipalityStateInitialCopyWith<MunicipalityStateInitial,
          MunicipalityStateInitial, MunicipalityStateInitial>
      get copyWith => _MunicipalityStateInitialCopyWithImpl(
          this as MunicipalityStateInitial, $identity, $identity);
  @override
  String toString() {
    return MunicipalityStateInitialMapper.ensureInitialized()
        .stringifyValue(this as MunicipalityStateInitial);
  }

  @override
  bool operator ==(Object other) {
    return MunicipalityStateInitialMapper.ensureInitialized()
        .equalsValue(this as MunicipalityStateInitial, other);
  }

  @override
  int get hashCode {
    return MunicipalityStateInitialMapper.ensureInitialized()
        .hashValue(this as MunicipalityStateInitial);
  }
}

extension MunicipalityStateInitialValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MunicipalityStateInitial, $Out> {
  MunicipalityStateInitialCopyWith<$R, MunicipalityStateInitial, $Out>
      get $asMunicipalityStateInitial => $base
          .as((v, t, t2) => _MunicipalityStateInitialCopyWithImpl(v, t, t2));
}

abstract class MunicipalityStateInitialCopyWith<
    $R,
    $In extends MunicipalityStateInitial,
    $Out> implements MunicipalityStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  MunicipalityStateInitialCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _MunicipalityStateInitialCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MunicipalityStateInitial, $Out>
    implements
        MunicipalityStateInitialCopyWith<$R, MunicipalityStateInitial, $Out> {
  _MunicipalityStateInitialCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MunicipalityStateInitial> $mapper =
      MunicipalityStateInitialMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  MunicipalityStateInitial $make(CopyWithData data) =>
      MunicipalityStateInitial();

  @override
  MunicipalityStateInitialCopyWith<$R2, MunicipalityStateInitial, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _MunicipalityStateInitialCopyWithImpl($value, $cast, t);
}

class MunicipalityStateLoadingMapper
    extends ClassMapperBase<MunicipalityStateLoading> {
  MunicipalityStateLoadingMapper._();

  static MunicipalityStateLoadingMapper? _instance;
  static MunicipalityStateLoadingMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = MunicipalityStateLoadingMapper._());
      MunicipalityStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MunicipalityStateLoading';

  @override
  final MappableFields<MunicipalityStateLoading> fields = const {};

  static MunicipalityStateLoading _instantiate(DecodingData data) {
    return MunicipalityStateLoading();
  }

  @override
  final Function instantiate = _instantiate;

  static MunicipalityStateLoading fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MunicipalityStateLoading>(map);
  }

  static MunicipalityStateLoading fromJson(String json) {
    return ensureInitialized().decodeJson<MunicipalityStateLoading>(json);
  }
}

mixin MunicipalityStateLoadingMappable {
  String toJson() {
    return MunicipalityStateLoadingMapper.ensureInitialized()
        .encodeJson<MunicipalityStateLoading>(this as MunicipalityStateLoading);
  }

  Map<String, dynamic> toMap() {
    return MunicipalityStateLoadingMapper.ensureInitialized()
        .encodeMap<MunicipalityStateLoading>(this as MunicipalityStateLoading);
  }

  MunicipalityStateLoadingCopyWith<MunicipalityStateLoading,
          MunicipalityStateLoading, MunicipalityStateLoading>
      get copyWith => _MunicipalityStateLoadingCopyWithImpl(
          this as MunicipalityStateLoading, $identity, $identity);
  @override
  String toString() {
    return MunicipalityStateLoadingMapper.ensureInitialized()
        .stringifyValue(this as MunicipalityStateLoading);
  }

  @override
  bool operator ==(Object other) {
    return MunicipalityStateLoadingMapper.ensureInitialized()
        .equalsValue(this as MunicipalityStateLoading, other);
  }

  @override
  int get hashCode {
    return MunicipalityStateLoadingMapper.ensureInitialized()
        .hashValue(this as MunicipalityStateLoading);
  }
}

extension MunicipalityStateLoadingValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MunicipalityStateLoading, $Out> {
  MunicipalityStateLoadingCopyWith<$R, MunicipalityStateLoading, $Out>
      get $asMunicipalityStateLoading => $base
          .as((v, t, t2) => _MunicipalityStateLoadingCopyWithImpl(v, t, t2));
}

abstract class MunicipalityStateLoadingCopyWith<
    $R,
    $In extends MunicipalityStateLoading,
    $Out> implements MunicipalityStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  MunicipalityStateLoadingCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _MunicipalityStateLoadingCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MunicipalityStateLoading, $Out>
    implements
        MunicipalityStateLoadingCopyWith<$R, MunicipalityStateLoading, $Out> {
  _MunicipalityStateLoadingCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MunicipalityStateLoading> $mapper =
      MunicipalityStateLoadingMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  MunicipalityStateLoading $make(CopyWithData data) =>
      MunicipalityStateLoading();

  @override
  MunicipalityStateLoadingCopyWith<$R2, MunicipalityStateLoading, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _MunicipalityStateLoadingCopyWithImpl($value, $cast, t);
}

class MunicipalityStateLoadedMapper
    extends ClassMapperBase<MunicipalityStateLoaded> {
  MunicipalityStateLoadedMapper._();

  static MunicipalityStateLoadedMapper? _instance;
  static MunicipalityStateLoadedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = MunicipalityStateLoadedMapper._());
      MunicipalityStateMapper.ensureInitialized();
      MunicipalityMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MunicipalityStateLoaded';

  static Map<String, List<Municipality>> _$municipalitiesPerDistrict(
          MunicipalityStateLoaded v) =>
      v.municipalitiesPerDistrict;
  static const Field<MunicipalityStateLoaded, Map<String, List<Municipality>>>
      _f$municipalitiesPerDistrict =
      Field('municipalitiesPerDistrict', _$municipalitiesPerDistrict);

  @override
  final MappableFields<MunicipalityStateLoaded> fields = const {
    #municipalitiesPerDistrict: _f$municipalitiesPerDistrict,
  };

  static MunicipalityStateLoaded _instantiate(DecodingData data) {
    return MunicipalityStateLoaded(
        municipalitiesPerDistrict: data.dec(_f$municipalitiesPerDistrict));
  }

  @override
  final Function instantiate = _instantiate;

  static MunicipalityStateLoaded fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MunicipalityStateLoaded>(map);
  }

  static MunicipalityStateLoaded fromJson(String json) {
    return ensureInitialized().decodeJson<MunicipalityStateLoaded>(json);
  }
}

mixin MunicipalityStateLoadedMappable {
  String toJson() {
    return MunicipalityStateLoadedMapper.ensureInitialized()
        .encodeJson<MunicipalityStateLoaded>(this as MunicipalityStateLoaded);
  }

  Map<String, dynamic> toMap() {
    return MunicipalityStateLoadedMapper.ensureInitialized()
        .encodeMap<MunicipalityStateLoaded>(this as MunicipalityStateLoaded);
  }

  MunicipalityStateLoadedCopyWith<MunicipalityStateLoaded,
          MunicipalityStateLoaded, MunicipalityStateLoaded>
      get copyWith => _MunicipalityStateLoadedCopyWithImpl(
          this as MunicipalityStateLoaded, $identity, $identity);
  @override
  String toString() {
    return MunicipalityStateLoadedMapper.ensureInitialized()
        .stringifyValue(this as MunicipalityStateLoaded);
  }

  @override
  bool operator ==(Object other) {
    return MunicipalityStateLoadedMapper.ensureInitialized()
        .equalsValue(this as MunicipalityStateLoaded, other);
  }

  @override
  int get hashCode {
    return MunicipalityStateLoadedMapper.ensureInitialized()
        .hashValue(this as MunicipalityStateLoaded);
  }
}

extension MunicipalityStateLoadedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MunicipalityStateLoaded, $Out> {
  MunicipalityStateLoadedCopyWith<$R, MunicipalityStateLoaded, $Out>
      get $asMunicipalityStateLoaded => $base
          .as((v, t, t2) => _MunicipalityStateLoadedCopyWithImpl(v, t, t2));
}

abstract class MunicipalityStateLoadedCopyWith<
    $R,
    $In extends MunicipalityStateLoaded,
    $Out> implements MunicipalityStateCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, List<Municipality>,
          ObjectCopyWith<$R, List<Municipality>, List<Municipality>>>
      get municipalitiesPerDistrict;
  @override
  $R call({Map<String, List<Municipality>>? municipalitiesPerDistrict});
  MunicipalityStateLoadedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _MunicipalityStateLoadedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MunicipalityStateLoaded, $Out>
    implements
        MunicipalityStateLoadedCopyWith<$R, MunicipalityStateLoaded, $Out> {
  _MunicipalityStateLoadedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MunicipalityStateLoaded> $mapper =
      MunicipalityStateLoadedMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, List<Municipality>,
          ObjectCopyWith<$R, List<Municipality>, List<Municipality>>>
      get municipalitiesPerDistrict => MapCopyWith(
          $value.municipalitiesPerDistrict,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(municipalitiesPerDistrict: v));
  @override
  $R call({Map<String, List<Municipality>>? municipalitiesPerDistrict}) =>
      $apply(FieldCopyWithData({
        if (municipalitiesPerDistrict != null)
          #municipalitiesPerDistrict: municipalitiesPerDistrict
      }));
  @override
  MunicipalityStateLoaded $make(CopyWithData data) => MunicipalityStateLoaded(
      municipalitiesPerDistrict: data.get(#municipalitiesPerDistrict,
          or: $value.municipalitiesPerDistrict));

  @override
  MunicipalityStateLoadedCopyWith<$R2, MunicipalityStateLoaded, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _MunicipalityStateLoadedCopyWithImpl($value, $cast, t);
}

class MunicipalityStateFailedMapper
    extends ClassMapperBase<MunicipalityStateFailed> {
  MunicipalityStateFailedMapper._();

  static MunicipalityStateFailedMapper? _instance;
  static MunicipalityStateFailedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = MunicipalityStateFailedMapper._());
      MunicipalityStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MunicipalityStateFailed';

  @override
  final MappableFields<MunicipalityStateFailed> fields = const {};

  static MunicipalityStateFailed _instantiate(DecodingData data) {
    return MunicipalityStateFailed();
  }

  @override
  final Function instantiate = _instantiate;

  static MunicipalityStateFailed fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MunicipalityStateFailed>(map);
  }

  static MunicipalityStateFailed fromJson(String json) {
    return ensureInitialized().decodeJson<MunicipalityStateFailed>(json);
  }
}

mixin MunicipalityStateFailedMappable {
  String toJson() {
    return MunicipalityStateFailedMapper.ensureInitialized()
        .encodeJson<MunicipalityStateFailed>(this as MunicipalityStateFailed);
  }

  Map<String, dynamic> toMap() {
    return MunicipalityStateFailedMapper.ensureInitialized()
        .encodeMap<MunicipalityStateFailed>(this as MunicipalityStateFailed);
  }

  MunicipalityStateFailedCopyWith<MunicipalityStateFailed,
          MunicipalityStateFailed, MunicipalityStateFailed>
      get copyWith => _MunicipalityStateFailedCopyWithImpl(
          this as MunicipalityStateFailed, $identity, $identity);
  @override
  String toString() {
    return MunicipalityStateFailedMapper.ensureInitialized()
        .stringifyValue(this as MunicipalityStateFailed);
  }

  @override
  bool operator ==(Object other) {
    return MunicipalityStateFailedMapper.ensureInitialized()
        .equalsValue(this as MunicipalityStateFailed, other);
  }

  @override
  int get hashCode {
    return MunicipalityStateFailedMapper.ensureInitialized()
        .hashValue(this as MunicipalityStateFailed);
  }
}

extension MunicipalityStateFailedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MunicipalityStateFailed, $Out> {
  MunicipalityStateFailedCopyWith<$R, MunicipalityStateFailed, $Out>
      get $asMunicipalityStateFailed => $base
          .as((v, t, t2) => _MunicipalityStateFailedCopyWithImpl(v, t, t2));
}

abstract class MunicipalityStateFailedCopyWith<
    $R,
    $In extends MunicipalityStateFailed,
    $Out> implements MunicipalityStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  MunicipalityStateFailedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _MunicipalityStateFailedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MunicipalityStateFailed, $Out>
    implements
        MunicipalityStateFailedCopyWith<$R, MunicipalityStateFailed, $Out> {
  _MunicipalityStateFailedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MunicipalityStateFailed> $mapper =
      MunicipalityStateFailedMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  MunicipalityStateFailed $make(CopyWithData data) => MunicipalityStateFailed();

  @override
  MunicipalityStateFailedCopyWith<$R2, MunicipalityStateFailed, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _MunicipalityStateFailedCopyWithImpl($value, $cast, t);
}
