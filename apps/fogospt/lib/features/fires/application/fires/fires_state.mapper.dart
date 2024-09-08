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
    }
    return _instance!;
  }

  @override
  final String id = 'FiresState';

  static StateStatus _$status(FiresState v) => v.status;
  static const Field<FiresState, StateStatus> _f$status =
      Field('status', _$status, opt: true, def: StateStatus.initial);
  static Fire? _$fire(FiresState v) => v.fire;
  static const Field<FiresState, Fire> _f$fire =
      Field('fire', _$fire, opt: true);
  static List<Resources> _$resources(FiresState v) => v.resources;
  static const Field<FiresState, List<Resources>> _f$resources =
      Field('resources', _$resources, opt: true);
  static List<HistoryStatus> _$historyStatuses(FiresState v) =>
      v.historyStatuses;
  static const Field<FiresState, List<HistoryStatus>> _f$historyStatuses =
      Field('historyStatuses', _$historyStatuses, opt: true);
  static List<RCM> _$rcm(FiresState v) => v.rcm;
  static const Field<FiresState, List<RCM>> _f$rcm =
      Field('rcm', _$rcm, opt: true);
  static const Field<FiresState, String> _f$errorMessage =
      Field('errorMessage', null, mode: FieldMode.param, opt: true);

  @override
  final MappableFields<FiresState> fields = const {
    #status: _f$status,
    #fire: _f$fire,
    #resources: _f$resources,
    #historyStatuses: _f$historyStatuses,
    #rcm: _f$rcm,
    #errorMessage: _f$errorMessage,
  };

  static FiresState _instantiate(DecodingData data) {
    return FiresState(
        status: data.dec(_f$status),
        fire: data.dec(_f$fire),
        resources: data.dec(_f$resources),
        historyStatuses: data.dec(_f$historyStatuses),
        rcm: data.dec(_f$rcm),
        errorMessage: data.dec(_f$errorMessage));
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
  String toJson() {
    return FiresStateMapper.ensureInitialized()
        .encodeJson<FiresState>(this as FiresState);
  }

  Map<String, dynamic> toMap() {
    return FiresStateMapper.ensureInitialized()
        .encodeMap<FiresState>(this as FiresState);
  }

  FiresStateCopyWith<FiresState, FiresState, FiresState> get copyWith =>
      _FiresStateCopyWithImpl(this as FiresState, $identity, $identity);
  @override
  String toString() {
    return FiresStateMapper.ensureInitialized()
        .stringifyValue(this as FiresState);
  }

  @override
  bool operator ==(Object other) {
    return FiresStateMapper.ensureInitialized()
        .equalsValue(this as FiresState, other);
  }

  @override
  int get hashCode {
    return FiresStateMapper.ensureInitialized().hashValue(this as FiresState);
  }
}

extension FiresStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FiresState, $Out> {
  FiresStateCopyWith<$R, FiresState, $Out> get $asFiresState =>
      $base.as((v, t, t2) => _FiresStateCopyWithImpl(v, t, t2));
}

abstract class FiresStateCopyWith<$R, $In extends FiresState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Resources, ObjectCopyWith<$R, Resources, Resources>>
      get resources;
  ListCopyWith<$R, HistoryStatus,
      ObjectCopyWith<$R, HistoryStatus, HistoryStatus>> get historyStatuses;
  ListCopyWith<$R, RCM, ObjectCopyWith<$R, RCM, RCM>> get rcm;
  $R call(
      {StateStatus? status,
      Fire? fire,
      List<Resources>? resources,
      List<HistoryStatus>? historyStatuses,
      List<RCM>? rcm,
      String? errorMessage});
  FiresStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FiresStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FiresState, $Out>
    implements FiresStateCopyWith<$R, FiresState, $Out> {
  _FiresStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FiresState> $mapper =
      FiresStateMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Resources, ObjectCopyWith<$R, Resources, Resources>>
      get resources => ListCopyWith($value.resources,
          (v, t) => ObjectCopyWith(v, $identity, t), (v) => call(resources: v));
  @override
  ListCopyWith<$R, HistoryStatus,
          ObjectCopyWith<$R, HistoryStatus, HistoryStatus>>
      get historyStatuses => ListCopyWith(
          $value.historyStatuses,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(historyStatuses: v));
  @override
  ListCopyWith<$R, RCM, ObjectCopyWith<$R, RCM, RCM>> get rcm => ListCopyWith(
      $value.rcm,
      (v, t) => ObjectCopyWith(v, $identity, t),
      (v) => call(rcm: v));
  @override
  $R call(
          {StateStatus? status,
          Object? fire = $none,
          Object? resources = $none,
          Object? historyStatuses = $none,
          Object? rcm = $none,
          String? errorMessage}) =>
      $apply(FieldCopyWithData({
        if (status != null) #status: status,
        if (fire != $none) #fire: fire,
        if (resources != $none) #resources: resources,
        if (historyStatuses != $none) #historyStatuses: historyStatuses,
        if (rcm != $none) #rcm: rcm,
        #errorMessage: errorMessage
      }));
  @override
  FiresState $make(CopyWithData data) => FiresState(
      status: data.get(#status, or: $value.status),
      fire: data.get(#fire, or: $value.fire),
      resources: data.get(#resources, or: $value.resources),
      historyStatuses: data.get(#historyStatuses, or: $value.historyStatuses),
      rcm: data.get(#rcm, or: $value.rcm),
      errorMessage: data.get(#errorMessage));

  @override
  FiresStateCopyWith<$R2, FiresState, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _FiresStateCopyWithImpl($value, $cast, t);
}
