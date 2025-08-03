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
      DistrictValueMapper.ensureInitialized();
      MunicipalityValueMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MunicipalityState';

  static StateStatus _$status(MunicipalityState v) => v.status;
  static const Field<MunicipalityState, StateStatus> _f$status =
      Field('status', _$status, opt: true, def: StateStatus.initial);
  static Map<DistrictValue, List<MunicipalityValue>>
      _$municipalitiesPerDistrict(MunicipalityState v) =>
          v.municipalitiesPerDistrict;
  static const Field<MunicipalityState,
          Map<DistrictValue, List<MunicipalityValue>>>
      _f$municipalitiesPerDistrict = Field(
          'municipalitiesPerDistrict', _$municipalitiesPerDistrict,
          opt: true);

  @override
  final MappableFields<MunicipalityState> fields = const {
    #status: _f$status,
    #municipalitiesPerDistrict: _f$municipalitiesPerDistrict,
  };

  static MunicipalityState _instantiate(DecodingData data) {
    return MunicipalityState(
        status: data.dec(_f$status),
        municipalitiesPerDistrict: data.dec(_f$municipalitiesPerDistrict));
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
  String toJson() {
    return MunicipalityStateMapper.ensureInitialized()
        .encodeJson<MunicipalityState>(this as MunicipalityState);
  }

  Map<String, dynamic> toMap() {
    return MunicipalityStateMapper.ensureInitialized()
        .encodeMap<MunicipalityState>(this as MunicipalityState);
  }

  MunicipalityStateCopyWith<MunicipalityState, MunicipalityState,
          MunicipalityState>
      get copyWith =>
          _MunicipalityStateCopyWithImpl<MunicipalityState, MunicipalityState>(
              this as MunicipalityState, $identity, $identity);
  @override
  String toString() {
    return MunicipalityStateMapper.ensureInitialized()
        .stringifyValue(this as MunicipalityState);
  }

  @override
  bool operator ==(Object other) {
    return MunicipalityStateMapper.ensureInitialized()
        .equalsValue(this as MunicipalityState, other);
  }

  @override
  int get hashCode {
    return MunicipalityStateMapper.ensureInitialized()
        .hashValue(this as MunicipalityState);
  }
}

extension MunicipalityStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MunicipalityState, $Out> {
  MunicipalityStateCopyWith<$R, MunicipalityState, $Out>
      get $asMunicipalityState => $base
          .as((v, t, t2) => _MunicipalityStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MunicipalityStateCopyWith<$R, $In extends MunicipalityState,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, DistrictValue, List<MunicipalityValue>,
          ObjectCopyWith<$R, List<MunicipalityValue>, List<MunicipalityValue>>>
      get municipalitiesPerDistrict;
  $R call(
      {StateStatus? status,
      Map<DistrictValue, List<MunicipalityValue>>? municipalitiesPerDistrict});
  MunicipalityStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _MunicipalityStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MunicipalityState, $Out>
    implements MunicipalityStateCopyWith<$R, MunicipalityState, $Out> {
  _MunicipalityStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MunicipalityState> $mapper =
      MunicipalityStateMapper.ensureInitialized();
  @override
  MapCopyWith<$R, DistrictValue, List<MunicipalityValue>,
          ObjectCopyWith<$R, List<MunicipalityValue>, List<MunicipalityValue>>>
      get municipalitiesPerDistrict => MapCopyWith(
          $value.municipalitiesPerDistrict,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(municipalitiesPerDistrict: v));
  @override
  $R call({StateStatus? status, Object? municipalitiesPerDistrict = $none}) =>
      $apply(FieldCopyWithData({
        if (status != null) #status: status,
        if (municipalitiesPerDistrict != $none)
          #municipalitiesPerDistrict: municipalitiesPerDistrict
      }));
  @override
  MunicipalityState $make(CopyWithData data) => MunicipalityState(
      status: data.get(#status, or: $value.status),
      municipalitiesPerDistrict: data.get(#municipalitiesPerDistrict,
          or: $value.municipalitiesPerDistrict));

  @override
  MunicipalityStateCopyWith<$R2, MunicipalityState, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _MunicipalityStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
