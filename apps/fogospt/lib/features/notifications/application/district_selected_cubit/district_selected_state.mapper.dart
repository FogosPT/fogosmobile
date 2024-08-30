// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'district_selected_state.dart';

class DistrictSelectedStateMapper
    extends ClassMapperBase<DistrictSelectedState> {
  DistrictSelectedStateMapper._();

  static DistrictSelectedStateMapper? _instance;
  static DistrictSelectedStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DistrictSelectedStateMapper._());
      DistrictSelectedStartedMapper.ensureInitialized();
      DistrictSelectedLoadingMapper.ensureInitialized();
      DistrictSelectedMapper.ensureInitialized();
      DistrictUnselectedMapper.ensureInitialized();
      DistrictSelectedFailedMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DistrictSelectedState';

  @override
  final MappableFields<DistrictSelectedState> fields = const {};

  static DistrictSelectedState _instantiate(DecodingData data) {
    throw MapperException.missingConstructor('DistrictSelectedState');
  }

  @override
  final Function instantiate = _instantiate;

  static DistrictSelectedState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DistrictSelectedState>(map);
  }

  static DistrictSelectedState fromJson(String json) {
    return ensureInitialized().decodeJson<DistrictSelectedState>(json);
  }
}

mixin DistrictSelectedStateMappable {
  String toJson();
  Map<String, dynamic> toMap();
  DistrictSelectedStateCopyWith<DistrictSelectedState, DistrictSelectedState,
      DistrictSelectedState> get copyWith;
}

abstract class DistrictSelectedStateCopyWith<
    $R,
    $In extends DistrictSelectedState,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  DistrictSelectedStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class DistrictSelectedStartedMapper
    extends ClassMapperBase<DistrictSelectedStarted> {
  DistrictSelectedStartedMapper._();

  static DistrictSelectedStartedMapper? _instance;
  static DistrictSelectedStartedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = DistrictSelectedStartedMapper._());
      DistrictSelectedStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DistrictSelectedStarted';

  @override
  final MappableFields<DistrictSelectedStarted> fields = const {};

  static DistrictSelectedStarted _instantiate(DecodingData data) {
    return DistrictSelectedStarted();
  }

  @override
  final Function instantiate = _instantiate;

  static DistrictSelectedStarted fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DistrictSelectedStarted>(map);
  }

  static DistrictSelectedStarted fromJson(String json) {
    return ensureInitialized().decodeJson<DistrictSelectedStarted>(json);
  }
}

mixin DistrictSelectedStartedMappable {
  String toJson() {
    return DistrictSelectedStartedMapper.ensureInitialized()
        .encodeJson<DistrictSelectedStarted>(this as DistrictSelectedStarted);
  }

  Map<String, dynamic> toMap() {
    return DistrictSelectedStartedMapper.ensureInitialized()
        .encodeMap<DistrictSelectedStarted>(this as DistrictSelectedStarted);
  }

  DistrictSelectedStartedCopyWith<DistrictSelectedStarted,
          DistrictSelectedStarted, DistrictSelectedStarted>
      get copyWith => _DistrictSelectedStartedCopyWithImpl(
          this as DistrictSelectedStarted, $identity, $identity);
  @override
  String toString() {
    return DistrictSelectedStartedMapper.ensureInitialized()
        .stringifyValue(this as DistrictSelectedStarted);
  }

  @override
  bool operator ==(Object other) {
    return DistrictSelectedStartedMapper.ensureInitialized()
        .equalsValue(this as DistrictSelectedStarted, other);
  }

  @override
  int get hashCode {
    return DistrictSelectedStartedMapper.ensureInitialized()
        .hashValue(this as DistrictSelectedStarted);
  }
}

extension DistrictSelectedStartedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DistrictSelectedStarted, $Out> {
  DistrictSelectedStartedCopyWith<$R, DistrictSelectedStarted, $Out>
      get $asDistrictSelectedStarted => $base
          .as((v, t, t2) => _DistrictSelectedStartedCopyWithImpl(v, t, t2));
}

abstract class DistrictSelectedStartedCopyWith<
    $R,
    $In extends DistrictSelectedStarted,
    $Out> implements DistrictSelectedStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  DistrictSelectedStartedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _DistrictSelectedStartedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DistrictSelectedStarted, $Out>
    implements
        DistrictSelectedStartedCopyWith<$R, DistrictSelectedStarted, $Out> {
  _DistrictSelectedStartedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DistrictSelectedStarted> $mapper =
      DistrictSelectedStartedMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  DistrictSelectedStarted $make(CopyWithData data) => DistrictSelectedStarted();

  @override
  DistrictSelectedStartedCopyWith<$R2, DistrictSelectedStarted, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _DistrictSelectedStartedCopyWithImpl($value, $cast, t);
}

class DistrictSelectedLoadingMapper
    extends ClassMapperBase<DistrictSelectedLoading> {
  DistrictSelectedLoadingMapper._();

  static DistrictSelectedLoadingMapper? _instance;
  static DistrictSelectedLoadingMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = DistrictSelectedLoadingMapper._());
      DistrictSelectedStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DistrictSelectedLoading';

  @override
  final MappableFields<DistrictSelectedLoading> fields = const {};

  static DistrictSelectedLoading _instantiate(DecodingData data) {
    return DistrictSelectedLoading();
  }

  @override
  final Function instantiate = _instantiate;

  static DistrictSelectedLoading fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DistrictSelectedLoading>(map);
  }

  static DistrictSelectedLoading fromJson(String json) {
    return ensureInitialized().decodeJson<DistrictSelectedLoading>(json);
  }
}

mixin DistrictSelectedLoadingMappable {
  String toJson() {
    return DistrictSelectedLoadingMapper.ensureInitialized()
        .encodeJson<DistrictSelectedLoading>(this as DistrictSelectedLoading);
  }

  Map<String, dynamic> toMap() {
    return DistrictSelectedLoadingMapper.ensureInitialized()
        .encodeMap<DistrictSelectedLoading>(this as DistrictSelectedLoading);
  }

  DistrictSelectedLoadingCopyWith<DistrictSelectedLoading,
          DistrictSelectedLoading, DistrictSelectedLoading>
      get copyWith => _DistrictSelectedLoadingCopyWithImpl(
          this as DistrictSelectedLoading, $identity, $identity);
  @override
  String toString() {
    return DistrictSelectedLoadingMapper.ensureInitialized()
        .stringifyValue(this as DistrictSelectedLoading);
  }

  @override
  bool operator ==(Object other) {
    return DistrictSelectedLoadingMapper.ensureInitialized()
        .equalsValue(this as DistrictSelectedLoading, other);
  }

  @override
  int get hashCode {
    return DistrictSelectedLoadingMapper.ensureInitialized()
        .hashValue(this as DistrictSelectedLoading);
  }
}

extension DistrictSelectedLoadingValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DistrictSelectedLoading, $Out> {
  DistrictSelectedLoadingCopyWith<$R, DistrictSelectedLoading, $Out>
      get $asDistrictSelectedLoading => $base
          .as((v, t, t2) => _DistrictSelectedLoadingCopyWithImpl(v, t, t2));
}

abstract class DistrictSelectedLoadingCopyWith<
    $R,
    $In extends DistrictSelectedLoading,
    $Out> implements DistrictSelectedStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  DistrictSelectedLoadingCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _DistrictSelectedLoadingCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DistrictSelectedLoading, $Out>
    implements
        DistrictSelectedLoadingCopyWith<$R, DistrictSelectedLoading, $Out> {
  _DistrictSelectedLoadingCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DistrictSelectedLoading> $mapper =
      DistrictSelectedLoadingMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  DistrictSelectedLoading $make(CopyWithData data) => DistrictSelectedLoading();

  @override
  DistrictSelectedLoadingCopyWith<$R2, DistrictSelectedLoading, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _DistrictSelectedLoadingCopyWithImpl($value, $cast, t);
}

class DistrictSelectedMapper extends ClassMapperBase<DistrictSelected> {
  DistrictSelectedMapper._();

  static DistrictSelectedMapper? _instance;
  static DistrictSelectedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DistrictSelectedMapper._());
      DistrictSelectedStateMapper.ensureInitialized();
      DistrictMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DistrictSelected';

  static District _$district(DistrictSelected v) => v.district;
  static const Field<DistrictSelected, District> _f$district =
      Field('district', _$district);

  @override
  final MappableFields<DistrictSelected> fields = const {
    #district: _f$district,
  };

  static DistrictSelected _instantiate(DecodingData data) {
    return DistrictSelected(district: data.dec(_f$district));
  }

  @override
  final Function instantiate = _instantiate;

  static DistrictSelected fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DistrictSelected>(map);
  }

  static DistrictSelected fromJson(String json) {
    return ensureInitialized().decodeJson<DistrictSelected>(json);
  }
}

mixin DistrictSelectedMappable {
  String toJson() {
    return DistrictSelectedMapper.ensureInitialized()
        .encodeJson<DistrictSelected>(this as DistrictSelected);
  }

  Map<String, dynamic> toMap() {
    return DistrictSelectedMapper.ensureInitialized()
        .encodeMap<DistrictSelected>(this as DistrictSelected);
  }

  DistrictSelectedCopyWith<DistrictSelected, DistrictSelected, DistrictSelected>
      get copyWith => _DistrictSelectedCopyWithImpl(
          this as DistrictSelected, $identity, $identity);
  @override
  String toString() {
    return DistrictSelectedMapper.ensureInitialized()
        .stringifyValue(this as DistrictSelected);
  }

  @override
  bool operator ==(Object other) {
    return DistrictSelectedMapper.ensureInitialized()
        .equalsValue(this as DistrictSelected, other);
  }

  @override
  int get hashCode {
    return DistrictSelectedMapper.ensureInitialized()
        .hashValue(this as DistrictSelected);
  }
}

extension DistrictSelectedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DistrictSelected, $Out> {
  DistrictSelectedCopyWith<$R, DistrictSelected, $Out>
      get $asDistrictSelected =>
          $base.as((v, t, t2) => _DistrictSelectedCopyWithImpl(v, t, t2));
}

abstract class DistrictSelectedCopyWith<$R, $In extends DistrictSelected, $Out>
    implements DistrictSelectedStateCopyWith<$R, $In, $Out> {
  DistrictCopyWith<$R, District, District> get district;
  @override
  $R call({District? district});
  DistrictSelectedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _DistrictSelectedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DistrictSelected, $Out>
    implements DistrictSelectedCopyWith<$R, DistrictSelected, $Out> {
  _DistrictSelectedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DistrictSelected> $mapper =
      DistrictSelectedMapper.ensureInitialized();
  @override
  DistrictCopyWith<$R, District, District> get district =>
      $value.district.copyWith.$chain((v) => call(district: v));
  @override
  $R call({District? district}) =>
      $apply(FieldCopyWithData({if (district != null) #district: district}));
  @override
  DistrictSelected $make(CopyWithData data) =>
      DistrictSelected(district: data.get(#district, or: $value.district));

  @override
  DistrictSelectedCopyWith<$R2, DistrictSelected, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _DistrictSelectedCopyWithImpl($value, $cast, t);
}

class DistrictUnselectedMapper extends ClassMapperBase<DistrictUnselected> {
  DistrictUnselectedMapper._();

  static DistrictUnselectedMapper? _instance;
  static DistrictUnselectedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DistrictUnselectedMapper._());
      DistrictSelectedStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DistrictUnselected';

  @override
  final MappableFields<DistrictUnselected> fields = const {};

  static DistrictUnselected _instantiate(DecodingData data) {
    return DistrictUnselected();
  }

  @override
  final Function instantiate = _instantiate;

  static DistrictUnselected fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DistrictUnselected>(map);
  }

  static DistrictUnselected fromJson(String json) {
    return ensureInitialized().decodeJson<DistrictUnselected>(json);
  }
}

mixin DistrictUnselectedMappable {
  String toJson() {
    return DistrictUnselectedMapper.ensureInitialized()
        .encodeJson<DistrictUnselected>(this as DistrictUnselected);
  }

  Map<String, dynamic> toMap() {
    return DistrictUnselectedMapper.ensureInitialized()
        .encodeMap<DistrictUnselected>(this as DistrictUnselected);
  }

  DistrictUnselectedCopyWith<DistrictUnselected, DistrictUnselected,
          DistrictUnselected>
      get copyWith => _DistrictUnselectedCopyWithImpl(
          this as DistrictUnselected, $identity, $identity);
  @override
  String toString() {
    return DistrictUnselectedMapper.ensureInitialized()
        .stringifyValue(this as DistrictUnselected);
  }

  @override
  bool operator ==(Object other) {
    return DistrictUnselectedMapper.ensureInitialized()
        .equalsValue(this as DistrictUnselected, other);
  }

  @override
  int get hashCode {
    return DistrictUnselectedMapper.ensureInitialized()
        .hashValue(this as DistrictUnselected);
  }
}

extension DistrictUnselectedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DistrictUnselected, $Out> {
  DistrictUnselectedCopyWith<$R, DistrictUnselected, $Out>
      get $asDistrictUnselected =>
          $base.as((v, t, t2) => _DistrictUnselectedCopyWithImpl(v, t, t2));
}

abstract class DistrictUnselectedCopyWith<$R, $In extends DistrictUnselected,
    $Out> implements DistrictSelectedStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  DistrictUnselectedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _DistrictUnselectedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DistrictUnselected, $Out>
    implements DistrictUnselectedCopyWith<$R, DistrictUnselected, $Out> {
  _DistrictUnselectedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DistrictUnselected> $mapper =
      DistrictUnselectedMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  DistrictUnselected $make(CopyWithData data) => DistrictUnselected();

  @override
  DistrictUnselectedCopyWith<$R2, DistrictUnselected, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _DistrictUnselectedCopyWithImpl($value, $cast, t);
}

class DistrictSelectedFailedMapper
    extends ClassMapperBase<DistrictSelectedFailed> {
  DistrictSelectedFailedMapper._();

  static DistrictSelectedFailedMapper? _instance;
  static DistrictSelectedFailedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DistrictSelectedFailedMapper._());
      DistrictSelectedStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DistrictSelectedFailed';

  @override
  final MappableFields<DistrictSelectedFailed> fields = const {};

  static DistrictSelectedFailed _instantiate(DecodingData data) {
    return DistrictSelectedFailed();
  }

  @override
  final Function instantiate = _instantiate;

  static DistrictSelectedFailed fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DistrictSelectedFailed>(map);
  }

  static DistrictSelectedFailed fromJson(String json) {
    return ensureInitialized().decodeJson<DistrictSelectedFailed>(json);
  }
}

mixin DistrictSelectedFailedMappable {
  String toJson() {
    return DistrictSelectedFailedMapper.ensureInitialized()
        .encodeJson<DistrictSelectedFailed>(this as DistrictSelectedFailed);
  }

  Map<String, dynamic> toMap() {
    return DistrictSelectedFailedMapper.ensureInitialized()
        .encodeMap<DistrictSelectedFailed>(this as DistrictSelectedFailed);
  }

  DistrictSelectedFailedCopyWith<DistrictSelectedFailed, DistrictSelectedFailed,
          DistrictSelectedFailed>
      get copyWith => _DistrictSelectedFailedCopyWithImpl(
          this as DistrictSelectedFailed, $identity, $identity);
  @override
  String toString() {
    return DistrictSelectedFailedMapper.ensureInitialized()
        .stringifyValue(this as DistrictSelectedFailed);
  }

  @override
  bool operator ==(Object other) {
    return DistrictSelectedFailedMapper.ensureInitialized()
        .equalsValue(this as DistrictSelectedFailed, other);
  }

  @override
  int get hashCode {
    return DistrictSelectedFailedMapper.ensureInitialized()
        .hashValue(this as DistrictSelectedFailed);
  }
}

extension DistrictSelectedFailedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DistrictSelectedFailed, $Out> {
  DistrictSelectedFailedCopyWith<$R, DistrictSelectedFailed, $Out>
      get $asDistrictSelectedFailed =>
          $base.as((v, t, t2) => _DistrictSelectedFailedCopyWithImpl(v, t, t2));
}

abstract class DistrictSelectedFailedCopyWith<
    $R,
    $In extends DistrictSelectedFailed,
    $Out> implements DistrictSelectedStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  DistrictSelectedFailedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _DistrictSelectedFailedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DistrictSelectedFailed, $Out>
    implements
        DistrictSelectedFailedCopyWith<$R, DistrictSelectedFailed, $Out> {
  _DistrictSelectedFailedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DistrictSelectedFailed> $mapper =
      DistrictSelectedFailedMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  DistrictSelectedFailed $make(CopyWithData data) => DistrictSelectedFailed();

  @override
  DistrictSelectedFailedCopyWith<$R2, DistrictSelectedFailed, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _DistrictSelectedFailedCopyWithImpl($value, $cast, t);
}
