// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'amendoins.dart';

class AmendoinsStateMapper extends ClassMapperBase<AmendoinsState> {
  AmendoinsStateMapper._();

  static AmendoinsStateMapper? _instance;
  static AmendoinsStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AmendoinsStateMapper._());
      AmendoinsStateInitialMapper.ensureInitialized();
      AmendoinsStateLoadingMapper.ensureInitialized();
      AmendoinsStateLoadedMapper.ensureInitialized();
      AmendoinsStateFailedMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AmendoinsState';

  @override
  final MappableFields<AmendoinsState> fields = const {};

  static AmendoinsState _instantiate(DecodingData data) {
    throw MapperException.missingConstructor('AmendoinsState');
  }

  @override
  final Function instantiate = _instantiate;

  static AmendoinsState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AmendoinsState>(map);
  }

  static AmendoinsState fromJson(String json) {
    return ensureInitialized().decodeJson<AmendoinsState>(json);
  }
}

mixin AmendoinsStateMappable {
  String toJson();
  Map<String, dynamic> toMap();
  AmendoinsStateCopyWith<AmendoinsState, AmendoinsState, AmendoinsState>
      get copyWith;
}

abstract class AmendoinsStateCopyWith<$R, $In extends AmendoinsState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  AmendoinsStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class AmendoinsStateInitialMapper
    extends ClassMapperBase<AmendoinsStateInitial> {
  AmendoinsStateInitialMapper._();

  static AmendoinsStateInitialMapper? _instance;
  static AmendoinsStateInitialMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AmendoinsStateInitialMapper._());
      AmendoinsStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AmendoinsStateInitial';

  @override
  final MappableFields<AmendoinsStateInitial> fields = const {};

  static AmendoinsStateInitial _instantiate(DecodingData data) {
    return AmendoinsStateInitial();
  }

  @override
  final Function instantiate = _instantiate;

  static AmendoinsStateInitial fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AmendoinsStateInitial>(map);
  }

  static AmendoinsStateInitial fromJson(String json) {
    return ensureInitialized().decodeJson<AmendoinsStateInitial>(json);
  }
}

mixin AmendoinsStateInitialMappable {
  String toJson() {
    return AmendoinsStateInitialMapper.ensureInitialized()
        .encodeJson<AmendoinsStateInitial>(this as AmendoinsStateInitial);
  }

  Map<String, dynamic> toMap() {
    return AmendoinsStateInitialMapper.ensureInitialized()
        .encodeMap<AmendoinsStateInitial>(this as AmendoinsStateInitial);
  }

  AmendoinsStateInitialCopyWith<AmendoinsStateInitial, AmendoinsStateInitial,
          AmendoinsStateInitial>
      get copyWith => _AmendoinsStateInitialCopyWithImpl(
          this as AmendoinsStateInitial, $identity, $identity);
  @override
  String toString() {
    return AmendoinsStateInitialMapper.ensureInitialized()
        .stringifyValue(this as AmendoinsStateInitial);
  }

  @override
  bool operator ==(Object other) {
    return AmendoinsStateInitialMapper.ensureInitialized()
        .equalsValue(this as AmendoinsStateInitial, other);
  }

  @override
  int get hashCode {
    return AmendoinsStateInitialMapper.ensureInitialized()
        .hashValue(this as AmendoinsStateInitial);
  }
}

extension AmendoinsStateInitialValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AmendoinsStateInitial, $Out> {
  AmendoinsStateInitialCopyWith<$R, AmendoinsStateInitial, $Out>
      get $asAmendoinsStateInitial =>
          $base.as((v, t, t2) => _AmendoinsStateInitialCopyWithImpl(v, t, t2));
}

abstract class AmendoinsStateInitialCopyWith<
    $R,
    $In extends AmendoinsStateInitial,
    $Out> implements AmendoinsStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  AmendoinsStateInitialCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _AmendoinsStateInitialCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AmendoinsStateInitial, $Out>
    implements AmendoinsStateInitialCopyWith<$R, AmendoinsStateInitial, $Out> {
  _AmendoinsStateInitialCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AmendoinsStateInitial> $mapper =
      AmendoinsStateInitialMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  AmendoinsStateInitial $make(CopyWithData data) => AmendoinsStateInitial();

  @override
  AmendoinsStateInitialCopyWith<$R2, AmendoinsStateInitial, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _AmendoinsStateInitialCopyWithImpl($value, $cast, t);
}

class AmendoinsStateLoadingMapper
    extends ClassMapperBase<AmendoinsStateLoading> {
  AmendoinsStateLoadingMapper._();

  static AmendoinsStateLoadingMapper? _instance;
  static AmendoinsStateLoadingMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AmendoinsStateLoadingMapper._());
      AmendoinsStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AmendoinsStateLoading';

  @override
  final MappableFields<AmendoinsStateLoading> fields = const {};

  static AmendoinsStateLoading _instantiate(DecodingData data) {
    return AmendoinsStateLoading();
  }

  @override
  final Function instantiate = _instantiate;

  static AmendoinsStateLoading fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AmendoinsStateLoading>(map);
  }

  static AmendoinsStateLoading fromJson(String json) {
    return ensureInitialized().decodeJson<AmendoinsStateLoading>(json);
  }
}

mixin AmendoinsStateLoadingMappable {
  String toJson() {
    return AmendoinsStateLoadingMapper.ensureInitialized()
        .encodeJson<AmendoinsStateLoading>(this as AmendoinsStateLoading);
  }

  Map<String, dynamic> toMap() {
    return AmendoinsStateLoadingMapper.ensureInitialized()
        .encodeMap<AmendoinsStateLoading>(this as AmendoinsStateLoading);
  }

  AmendoinsStateLoadingCopyWith<AmendoinsStateLoading, AmendoinsStateLoading,
          AmendoinsStateLoading>
      get copyWith => _AmendoinsStateLoadingCopyWithImpl(
          this as AmendoinsStateLoading, $identity, $identity);
  @override
  String toString() {
    return AmendoinsStateLoadingMapper.ensureInitialized()
        .stringifyValue(this as AmendoinsStateLoading);
  }

  @override
  bool operator ==(Object other) {
    return AmendoinsStateLoadingMapper.ensureInitialized()
        .equalsValue(this as AmendoinsStateLoading, other);
  }

  @override
  int get hashCode {
    return AmendoinsStateLoadingMapper.ensureInitialized()
        .hashValue(this as AmendoinsStateLoading);
  }
}

extension AmendoinsStateLoadingValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AmendoinsStateLoading, $Out> {
  AmendoinsStateLoadingCopyWith<$R, AmendoinsStateLoading, $Out>
      get $asAmendoinsStateLoading =>
          $base.as((v, t, t2) => _AmendoinsStateLoadingCopyWithImpl(v, t, t2));
}

abstract class AmendoinsStateLoadingCopyWith<
    $R,
    $In extends AmendoinsStateLoading,
    $Out> implements AmendoinsStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  AmendoinsStateLoadingCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _AmendoinsStateLoadingCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AmendoinsStateLoading, $Out>
    implements AmendoinsStateLoadingCopyWith<$R, AmendoinsStateLoading, $Out> {
  _AmendoinsStateLoadingCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AmendoinsStateLoading> $mapper =
      AmendoinsStateLoadingMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  AmendoinsStateLoading $make(CopyWithData data) => AmendoinsStateLoading();

  @override
  AmendoinsStateLoadingCopyWith<$R2, AmendoinsStateLoading, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _AmendoinsStateLoadingCopyWithImpl($value, $cast, t);
}

class AmendoinsStateLoadedMapper extends ClassMapperBase<AmendoinsStateLoaded> {
  AmendoinsStateLoadedMapper._();

  static AmendoinsStateLoadedMapper? _instance;
  static AmendoinsStateLoadedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AmendoinsStateLoadedMapper._());
      AmendoinsStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AmendoinsStateLoaded';

  @override
  final MappableFields<AmendoinsStateLoaded> fields = const {};

  static AmendoinsStateLoaded _instantiate(DecodingData data) {
    return AmendoinsStateLoaded();
  }

  @override
  final Function instantiate = _instantiate;

  static AmendoinsStateLoaded fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AmendoinsStateLoaded>(map);
  }

  static AmendoinsStateLoaded fromJson(String json) {
    return ensureInitialized().decodeJson<AmendoinsStateLoaded>(json);
  }
}

mixin AmendoinsStateLoadedMappable {
  String toJson() {
    return AmendoinsStateLoadedMapper.ensureInitialized()
        .encodeJson<AmendoinsStateLoaded>(this as AmendoinsStateLoaded);
  }

  Map<String, dynamic> toMap() {
    return AmendoinsStateLoadedMapper.ensureInitialized()
        .encodeMap<AmendoinsStateLoaded>(this as AmendoinsStateLoaded);
  }

  AmendoinsStateLoadedCopyWith<AmendoinsStateLoaded, AmendoinsStateLoaded,
          AmendoinsStateLoaded>
      get copyWith => _AmendoinsStateLoadedCopyWithImpl(
          this as AmendoinsStateLoaded, $identity, $identity);
  @override
  String toString() {
    return AmendoinsStateLoadedMapper.ensureInitialized()
        .stringifyValue(this as AmendoinsStateLoaded);
  }

  @override
  bool operator ==(Object other) {
    return AmendoinsStateLoadedMapper.ensureInitialized()
        .equalsValue(this as AmendoinsStateLoaded, other);
  }

  @override
  int get hashCode {
    return AmendoinsStateLoadedMapper.ensureInitialized()
        .hashValue(this as AmendoinsStateLoaded);
  }
}

extension AmendoinsStateLoadedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AmendoinsStateLoaded, $Out> {
  AmendoinsStateLoadedCopyWith<$R, AmendoinsStateLoaded, $Out>
      get $asAmendoinsStateLoaded =>
          $base.as((v, t, t2) => _AmendoinsStateLoadedCopyWithImpl(v, t, t2));
}

abstract class AmendoinsStateLoadedCopyWith<
    $R,
    $In extends AmendoinsStateLoaded,
    $Out> implements AmendoinsStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  AmendoinsStateLoadedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _AmendoinsStateLoadedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AmendoinsStateLoaded, $Out>
    implements AmendoinsStateLoadedCopyWith<$R, AmendoinsStateLoaded, $Out> {
  _AmendoinsStateLoadedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AmendoinsStateLoaded> $mapper =
      AmendoinsStateLoadedMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  AmendoinsStateLoaded $make(CopyWithData data) => AmendoinsStateLoaded();

  @override
  AmendoinsStateLoadedCopyWith<$R2, AmendoinsStateLoaded, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _AmendoinsStateLoadedCopyWithImpl($value, $cast, t);
}

class AmendoinsStateFailedMapper extends ClassMapperBase<AmendoinsStateFailed> {
  AmendoinsStateFailedMapper._();

  static AmendoinsStateFailedMapper? _instance;
  static AmendoinsStateFailedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AmendoinsStateFailedMapper._());
      AmendoinsStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AmendoinsStateFailed';

  @override
  final MappableFields<AmendoinsStateFailed> fields = const {};

  static AmendoinsStateFailed _instantiate(DecodingData data) {
    return AmendoinsStateFailed();
  }

  @override
  final Function instantiate = _instantiate;

  static AmendoinsStateFailed fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AmendoinsStateFailed>(map);
  }

  static AmendoinsStateFailed fromJson(String json) {
    return ensureInitialized().decodeJson<AmendoinsStateFailed>(json);
  }
}

mixin AmendoinsStateFailedMappable {
  String toJson() {
    return AmendoinsStateFailedMapper.ensureInitialized()
        .encodeJson<AmendoinsStateFailed>(this as AmendoinsStateFailed);
  }

  Map<String, dynamic> toMap() {
    return AmendoinsStateFailedMapper.ensureInitialized()
        .encodeMap<AmendoinsStateFailed>(this as AmendoinsStateFailed);
  }

  AmendoinsStateFailedCopyWith<AmendoinsStateFailed, AmendoinsStateFailed,
          AmendoinsStateFailed>
      get copyWith => _AmendoinsStateFailedCopyWithImpl(
          this as AmendoinsStateFailed, $identity, $identity);
  @override
  String toString() {
    return AmendoinsStateFailedMapper.ensureInitialized()
        .stringifyValue(this as AmendoinsStateFailed);
  }

  @override
  bool operator ==(Object other) {
    return AmendoinsStateFailedMapper.ensureInitialized()
        .equalsValue(this as AmendoinsStateFailed, other);
  }

  @override
  int get hashCode {
    return AmendoinsStateFailedMapper.ensureInitialized()
        .hashValue(this as AmendoinsStateFailed);
  }
}

extension AmendoinsStateFailedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AmendoinsStateFailed, $Out> {
  AmendoinsStateFailedCopyWith<$R, AmendoinsStateFailed, $Out>
      get $asAmendoinsStateFailed =>
          $base.as((v, t, t2) => _AmendoinsStateFailedCopyWithImpl(v, t, t2));
}

abstract class AmendoinsStateFailedCopyWith<
    $R,
    $In extends AmendoinsStateFailed,
    $Out> implements AmendoinsStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  AmendoinsStateFailedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _AmendoinsStateFailedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AmendoinsStateFailed, $Out>
    implements AmendoinsStateFailedCopyWith<$R, AmendoinsStateFailed, $Out> {
  _AmendoinsStateFailedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AmendoinsStateFailed> $mapper =
      AmendoinsStateFailedMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  AmendoinsStateFailed $make(CopyWithData data) => AmendoinsStateFailed();

  @override
  AmendoinsStateFailedCopyWith<$R2, AmendoinsStateFailed, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _AmendoinsStateFailedCopyWithImpl($value, $cast, t);
}
