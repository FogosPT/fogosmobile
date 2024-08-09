// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fires_state.dart';

class FiresStateMapper extends ClassMapperBase<FiresState> {
  FiresStateMapper._();

  static FiresStateMapper? _instance;
  static FiresStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FiresStateMapper._());
      FiresStateInitialMapper.ensureInitialized();
      FiresStateLoadingMapper.ensureInitialized();
      FiresStateLoadedMapper.ensureInitialized();
      FiresStateFailedMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FiresState';

  @override
  final MappableFields<FiresState> fields = const {};

  static FiresState _instantiate(DecodingData data) {
    throw MapperException.missingConstructor('FiresState');
  }

  @override
  final Function instantiate = _instantiate;

  static FiresState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FiresState>(map);
  }

  static FiresState fromJson(String json) {
    return ensureInitialized().decodeJson<FiresState>(json);
  }
}

mixin FiresStateMappable {
  String toJson();
  Map<String, dynamic> toMap();
  FiresStateCopyWith<FiresState, FiresState, FiresState> get copyWith;
}

abstract class FiresStateCopyWith<$R, $In extends FiresState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  FiresStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class FiresStateInitialMapper extends ClassMapperBase<FiresStateInitial> {
  FiresStateInitialMapper._();

  static FiresStateInitialMapper? _instance;
  static FiresStateInitialMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FiresStateInitialMapper._());
      FiresStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FiresStateInitial';

  @override
  final MappableFields<FiresStateInitial> fields = const {};

  static FiresStateInitial _instantiate(DecodingData data) {
    return FiresStateInitial();
  }

  @override
  final Function instantiate = _instantiate;

  static FiresStateInitial fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FiresStateInitial>(map);
  }

  static FiresStateInitial fromJson(String json) {
    return ensureInitialized().decodeJson<FiresStateInitial>(json);
  }
}

mixin FiresStateInitialMappable {
  String toJson() {
    return FiresStateInitialMapper.ensureInitialized()
        .encodeJson<FiresStateInitial>(this as FiresStateInitial);
  }

  Map<String, dynamic> toMap() {
    return FiresStateInitialMapper.ensureInitialized()
        .encodeMap<FiresStateInitial>(this as FiresStateInitial);
  }

  FiresStateInitialCopyWith<FiresStateInitial, FiresStateInitial,
          FiresStateInitial>
      get copyWith => _FiresStateInitialCopyWithImpl(
          this as FiresStateInitial, $identity, $identity);
  @override
  String toString() {
    return FiresStateInitialMapper.ensureInitialized()
        .stringifyValue(this as FiresStateInitial);
  }

  @override
  bool operator ==(Object other) {
    return FiresStateInitialMapper.ensureInitialized()
        .equalsValue(this as FiresStateInitial, other);
  }

  @override
  int get hashCode {
    return FiresStateInitialMapper.ensureInitialized()
        .hashValue(this as FiresStateInitial);
  }
}

extension FiresStateInitialValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FiresStateInitial, $Out> {
  FiresStateInitialCopyWith<$R, FiresStateInitial, $Out>
      get $asFiresStateInitial =>
          $base.as((v, t, t2) => _FiresStateInitialCopyWithImpl(v, t, t2));
}

abstract class FiresStateInitialCopyWith<$R, $In extends FiresStateInitial,
    $Out> implements FiresStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  FiresStateInitialCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _FiresStateInitialCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FiresStateInitial, $Out>
    implements FiresStateInitialCopyWith<$R, FiresStateInitial, $Out> {
  _FiresStateInitialCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FiresStateInitial> $mapper =
      FiresStateInitialMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  FiresStateInitial $make(CopyWithData data) => FiresStateInitial();

  @override
  FiresStateInitialCopyWith<$R2, FiresStateInitial, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _FiresStateInitialCopyWithImpl($value, $cast, t);
}

class FiresStateLoadingMapper extends ClassMapperBase<FiresStateLoading> {
  FiresStateLoadingMapper._();

  static FiresStateLoadingMapper? _instance;
  static FiresStateLoadingMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FiresStateLoadingMapper._());
      FiresStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FiresStateLoading';

  @override
  final MappableFields<FiresStateLoading> fields = const {};

  static FiresStateLoading _instantiate(DecodingData data) {
    return FiresStateLoading();
  }

  @override
  final Function instantiate = _instantiate;

  static FiresStateLoading fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FiresStateLoading>(map);
  }

  static FiresStateLoading fromJson(String json) {
    return ensureInitialized().decodeJson<FiresStateLoading>(json);
  }
}

mixin FiresStateLoadingMappable {
  String toJson() {
    return FiresStateLoadingMapper.ensureInitialized()
        .encodeJson<FiresStateLoading>(this as FiresStateLoading);
  }

  Map<String, dynamic> toMap() {
    return FiresStateLoadingMapper.ensureInitialized()
        .encodeMap<FiresStateLoading>(this as FiresStateLoading);
  }

  FiresStateLoadingCopyWith<FiresStateLoading, FiresStateLoading,
          FiresStateLoading>
      get copyWith => _FiresStateLoadingCopyWithImpl(
          this as FiresStateLoading, $identity, $identity);
  @override
  String toString() {
    return FiresStateLoadingMapper.ensureInitialized()
        .stringifyValue(this as FiresStateLoading);
  }

  @override
  bool operator ==(Object other) {
    return FiresStateLoadingMapper.ensureInitialized()
        .equalsValue(this as FiresStateLoading, other);
  }

  @override
  int get hashCode {
    return FiresStateLoadingMapper.ensureInitialized()
        .hashValue(this as FiresStateLoading);
  }
}

extension FiresStateLoadingValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FiresStateLoading, $Out> {
  FiresStateLoadingCopyWith<$R, FiresStateLoading, $Out>
      get $asFiresStateLoading =>
          $base.as((v, t, t2) => _FiresStateLoadingCopyWithImpl(v, t, t2));
}

abstract class FiresStateLoadingCopyWith<$R, $In extends FiresStateLoading,
    $Out> implements FiresStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  FiresStateLoadingCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _FiresStateLoadingCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FiresStateLoading, $Out>
    implements FiresStateLoadingCopyWith<$R, FiresStateLoading, $Out> {
  _FiresStateLoadingCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FiresStateLoading> $mapper =
      FiresStateLoadingMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  FiresStateLoading $make(CopyWithData data) => FiresStateLoading();

  @override
  FiresStateLoadingCopyWith<$R2, FiresStateLoading, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _FiresStateLoadingCopyWithImpl($value, $cast, t);
}

class FiresStateLoadedMapper extends ClassMapperBase<FiresStateLoaded> {
  FiresStateLoadedMapper._();

  static FiresStateLoadedMapper? _instance;
  static FiresStateLoadedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FiresStateLoadedMapper._());
      FiresStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FiresStateLoaded';

  static Fire? _$fire(FiresStateLoaded v) => v.fire;
  static const Field<FiresStateLoaded, Fire> _f$fire =
      Field('fire', _$fire, opt: true);
  static List<Resources>? _$resources(FiresStateLoaded v) => v.resources;
  static const Field<FiresStateLoaded, List<Resources>> _f$resources =
      Field('resources', _$resources, opt: true);
  static List<HistoryStatus>? _$historyStatuses(FiresStateLoaded v) =>
      v.historyStatuses;
  static const Field<FiresStateLoaded, List<HistoryStatus>> _f$historyStatuses =
      Field('historyStatuses', _$historyStatuses, opt: true);
  static List<RCM>? _$rcm(FiresStateLoaded v) => v.rcm;
  static const Field<FiresStateLoaded, List<RCM>> _f$rcm =
      Field('rcm', _$rcm, opt: true);

  @override
  final MappableFields<FiresStateLoaded> fields = const {
    #fire: _f$fire,
    #resources: _f$resources,
    #historyStatuses: _f$historyStatuses,
    #rcm: _f$rcm,
  };

  static FiresStateLoaded _instantiate(DecodingData data) {
    return FiresStateLoaded(
        fire: data.dec(_f$fire),
        resources: data.dec(_f$resources),
        historyStatuses: data.dec(_f$historyStatuses),
        rcm: data.dec(_f$rcm));
  }

  @override
  final Function instantiate = _instantiate;

  static FiresStateLoaded fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FiresStateLoaded>(map);
  }

  static FiresStateLoaded fromJson(String json) {
    return ensureInitialized().decodeJson<FiresStateLoaded>(json);
  }
}

mixin FiresStateLoadedMappable {
  String toJson() {
    return FiresStateLoadedMapper.ensureInitialized()
        .encodeJson<FiresStateLoaded>(this as FiresStateLoaded);
  }

  Map<String, dynamic> toMap() {
    return FiresStateLoadedMapper.ensureInitialized()
        .encodeMap<FiresStateLoaded>(this as FiresStateLoaded);
  }

  FiresStateLoadedCopyWith<FiresStateLoaded, FiresStateLoaded, FiresStateLoaded>
      get copyWith => _FiresStateLoadedCopyWithImpl(
          this as FiresStateLoaded, $identity, $identity);
  @override
  String toString() {
    return FiresStateLoadedMapper.ensureInitialized()
        .stringifyValue(this as FiresStateLoaded);
  }

  @override
  bool operator ==(Object other) {
    return FiresStateLoadedMapper.ensureInitialized()
        .equalsValue(this as FiresStateLoaded, other);
  }

  @override
  int get hashCode {
    return FiresStateLoadedMapper.ensureInitialized()
        .hashValue(this as FiresStateLoaded);
  }
}

extension FiresStateLoadedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FiresStateLoaded, $Out> {
  FiresStateLoadedCopyWith<$R, FiresStateLoaded, $Out>
      get $asFiresStateLoaded =>
          $base.as((v, t, t2) => _FiresStateLoadedCopyWithImpl(v, t, t2));
}

abstract class FiresStateLoadedCopyWith<$R, $In extends FiresStateLoaded, $Out>
    implements FiresStateCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Resources, ObjectCopyWith<$R, Resources, Resources>>?
      get resources;
  ListCopyWith<$R, HistoryStatus,
      ObjectCopyWith<$R, HistoryStatus, HistoryStatus>>? get historyStatuses;
  ListCopyWith<$R, RCM, ObjectCopyWith<$R, RCM, RCM>>? get rcm;
  @override
  $R call(
      {Fire? fire,
      List<Resources>? resources,
      List<HistoryStatus>? historyStatuses,
      List<RCM>? rcm});
  FiresStateLoadedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _FiresStateLoadedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FiresStateLoaded, $Out>
    implements FiresStateLoadedCopyWith<$R, FiresStateLoaded, $Out> {
  _FiresStateLoadedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FiresStateLoaded> $mapper =
      FiresStateLoadedMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Resources, ObjectCopyWith<$R, Resources, Resources>>?
      get resources => $value.resources != null
          ? ListCopyWith(
              $value.resources!,
              (v, t) => ObjectCopyWith(v, $identity, t),
              (v) => call(resources: v))
          : null;
  @override
  ListCopyWith<$R, HistoryStatus,
          ObjectCopyWith<$R, HistoryStatus, HistoryStatus>>?
      get historyStatuses => $value.historyStatuses != null
          ? ListCopyWith(
              $value.historyStatuses!,
              (v, t) => ObjectCopyWith(v, $identity, t),
              (v) => call(historyStatuses: v))
          : null;
  @override
  ListCopyWith<$R, RCM, ObjectCopyWith<$R, RCM, RCM>>? get rcm => $value.rcm !=
          null
      ? ListCopyWith($value.rcm!, (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(rcm: v))
      : null;
  @override
  $R call(
          {Object? fire = $none,
          Object? resources = $none,
          Object? historyStatuses = $none,
          Object? rcm = $none}) =>
      $apply(FieldCopyWithData({
        if (fire != $none) #fire: fire,
        if (resources != $none) #resources: resources,
        if (historyStatuses != $none) #historyStatuses: historyStatuses,
        if (rcm != $none) #rcm: rcm
      }));
  @override
  FiresStateLoaded $make(CopyWithData data) => FiresStateLoaded(
      fire: data.get(#fire, or: $value.fire),
      resources: data.get(#resources, or: $value.resources),
      historyStatuses: data.get(#historyStatuses, or: $value.historyStatuses),
      rcm: data.get(#rcm, or: $value.rcm));

  @override
  FiresStateLoadedCopyWith<$R2, FiresStateLoaded, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _FiresStateLoadedCopyWithImpl($value, $cast, t);
}

class FiresStateFailedMapper extends ClassMapperBase<FiresStateFailed> {
  FiresStateFailedMapper._();

  static FiresStateFailedMapper? _instance;
  static FiresStateFailedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FiresStateFailedMapper._());
      FiresStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FiresStateFailed';

  @override
  final MappableFields<FiresStateFailed> fields = const {};

  static FiresStateFailed _instantiate(DecodingData data) {
    return FiresStateFailed();
  }

  @override
  final Function instantiate = _instantiate;

  static FiresStateFailed fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FiresStateFailed>(map);
  }

  static FiresStateFailed fromJson(String json) {
    return ensureInitialized().decodeJson<FiresStateFailed>(json);
  }
}

mixin FiresStateFailedMappable {
  String toJson() {
    return FiresStateFailedMapper.ensureInitialized()
        .encodeJson<FiresStateFailed>(this as FiresStateFailed);
  }

  Map<String, dynamic> toMap() {
    return FiresStateFailedMapper.ensureInitialized()
        .encodeMap<FiresStateFailed>(this as FiresStateFailed);
  }

  FiresStateFailedCopyWith<FiresStateFailed, FiresStateFailed, FiresStateFailed>
      get copyWith => _FiresStateFailedCopyWithImpl(
          this as FiresStateFailed, $identity, $identity);
  @override
  String toString() {
    return FiresStateFailedMapper.ensureInitialized()
        .stringifyValue(this as FiresStateFailed);
  }

  @override
  bool operator ==(Object other) {
    return FiresStateFailedMapper.ensureInitialized()
        .equalsValue(this as FiresStateFailed, other);
  }

  @override
  int get hashCode {
    return FiresStateFailedMapper.ensureInitialized()
        .hashValue(this as FiresStateFailed);
  }
}

extension FiresStateFailedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FiresStateFailed, $Out> {
  FiresStateFailedCopyWith<$R, FiresStateFailed, $Out>
      get $asFiresStateFailed =>
          $base.as((v, t, t2) => _FiresStateFailedCopyWithImpl(v, t, t2));
}

abstract class FiresStateFailedCopyWith<$R, $In extends FiresStateFailed, $Out>
    implements FiresStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  FiresStateFailedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _FiresStateFailedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FiresStateFailed, $Out>
    implements FiresStateFailedCopyWith<$R, FiresStateFailed, $Out> {
  _FiresStateFailedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FiresStateFailed> $mapper =
      FiresStateFailedMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  FiresStateFailed $make(CopyWithData data) => FiresStateFailed();

  @override
  FiresStateFailedCopyWith<$R2, FiresStateFailed, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _FiresStateFailedCopyWithImpl($value, $cast, t);
}
