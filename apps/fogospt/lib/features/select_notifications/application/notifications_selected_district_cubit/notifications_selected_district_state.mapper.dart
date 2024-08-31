// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'notifications_selected_district_state.dart';

class DistrictSelectedStateMapper
    extends ClassMapperBase<DistrictSelectedState> {
  DistrictSelectedStateMapper._();

  static DistrictSelectedStateMapper? _instance;
  static DistrictSelectedStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DistrictSelectedStateMapper._());
      DistrictValueMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DistrictSelectedState';

  static DistrictValue? _$district(DistrictSelectedState v) => v.district;
  static const Field<DistrictSelectedState, DistrictValue> _f$district =
      Field('district', _$district, opt: true);
  static StateStatus _$status(DistrictSelectedState v) => v.status;
  static const Field<DistrictSelectedState, StateStatus> _f$status =
      Field('status', _$status, opt: true, def: StateStatus.initial);

  @override
  final MappableFields<DistrictSelectedState> fields = const {
    #district: _f$district,
    #status: _f$status,
  };

  static DistrictSelectedState _instantiate(DecodingData data) {
    return DistrictSelectedState(
        district: data.dec(_f$district), status: data.dec(_f$status));
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
  String toJson() {
    return DistrictSelectedStateMapper.ensureInitialized()
        .encodeJson<DistrictSelectedState>(this as DistrictSelectedState);
  }

  Map<String, dynamic> toMap() {
    return DistrictSelectedStateMapper.ensureInitialized()
        .encodeMap<DistrictSelectedState>(this as DistrictSelectedState);
  }

  DistrictSelectedStateCopyWith<DistrictSelectedState, DistrictSelectedState,
          DistrictSelectedState>
      get copyWith => _DistrictSelectedStateCopyWithImpl(
          this as DistrictSelectedState, $identity, $identity);
  @override
  String toString() {
    return DistrictSelectedStateMapper.ensureInitialized()
        .stringifyValue(this as DistrictSelectedState);
  }

  @override
  bool operator ==(Object other) {
    return DistrictSelectedStateMapper.ensureInitialized()
        .equalsValue(this as DistrictSelectedState, other);
  }

  @override
  int get hashCode {
    return DistrictSelectedStateMapper.ensureInitialized()
        .hashValue(this as DistrictSelectedState);
  }
}

extension DistrictSelectedStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DistrictSelectedState, $Out> {
  DistrictSelectedStateCopyWith<$R, DistrictSelectedState, $Out>
      get $asDistrictSelectedState =>
          $base.as((v, t, t2) => _DistrictSelectedStateCopyWithImpl(v, t, t2));
}

abstract class DistrictSelectedStateCopyWith<
    $R,
    $In extends DistrictSelectedState,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  DistrictValueCopyWith<$R, DistrictValue, DistrictValue>? get district;
  $R call({DistrictValue? district, StateStatus? status});
  DistrictSelectedStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _DistrictSelectedStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DistrictSelectedState, $Out>
    implements DistrictSelectedStateCopyWith<$R, DistrictSelectedState, $Out> {
  _DistrictSelectedStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DistrictSelectedState> $mapper =
      DistrictSelectedStateMapper.ensureInitialized();
  @override
  DistrictValueCopyWith<$R, DistrictValue, DistrictValue>? get district =>
      $value.district?.copyWith.$chain((v) => call(district: v));
  @override
  $R call({Object? district = $none, StateStatus? status}) =>
      $apply(FieldCopyWithData({
        if (district != $none) #district: district,
        if (status != null) #status: status
      }));
  @override
  DistrictSelectedState $make(CopyWithData data) => DistrictSelectedState(
      district: data.get(#district, or: $value.district),
      status: data.get(#status, or: $value.status));

  @override
  DistrictSelectedStateCopyWith<$R2, DistrictSelectedState, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _DistrictSelectedStateCopyWithImpl($value, $cast, t);
}
