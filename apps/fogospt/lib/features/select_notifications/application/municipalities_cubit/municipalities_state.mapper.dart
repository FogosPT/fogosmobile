// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'municipalities_state.dart';

class MunicipalitiesStateMapper extends ClassMapperBase<MunicipalitiesState> {
  MunicipalitiesStateMapper._();

  static MunicipalitiesStateMapper? _instance;
  static MunicipalitiesStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MunicipalitiesStateMapper._());
      DistrictValueMapper.ensureInitialized();
      MunicipalityValueMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MunicipalitiesState';

  static Map<DistrictValue, List<MunicipalityValue>>
      _$municipalitiesPerDistrict(MunicipalitiesState v) =>
          v.municipalitiesPerDistrict;
  static const Field<MunicipalitiesState,
          Map<DistrictValue, List<MunicipalityValue>>>
      _f$municipalitiesPerDistrict = Field(
          'municipalitiesPerDistrict', _$municipalitiesPerDistrict,
          opt: true);
  static StateStatus _$status(MunicipalitiesState v) => v.status;
  static const Field<MunicipalitiesState, StateStatus> _f$status =
      Field('status', _$status, opt: true, def: StateStatus.initial);

  @override
  final MappableFields<MunicipalitiesState> fields = const {
    #municipalitiesPerDistrict: _f$municipalitiesPerDistrict,
    #status: _f$status,
  };

  static MunicipalitiesState _instantiate(DecodingData data) {
    return MunicipalitiesState(
        municipalitiesPerDistrict: data.dec(_f$municipalitiesPerDistrict),
        status: data.dec(_f$status));
  }

  @override
  final Function instantiate = _instantiate;

  static MunicipalitiesState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MunicipalitiesState>(map);
  }

  static MunicipalitiesState fromJson(String json) {
    return ensureInitialized().decodeJson<MunicipalitiesState>(json);
  }
}

mixin MunicipalitiesStateMappable {
  String toJson() {
    return MunicipalitiesStateMapper.ensureInitialized()
        .encodeJson<MunicipalitiesState>(this as MunicipalitiesState);
  }

  Map<String, dynamic> toMap() {
    return MunicipalitiesStateMapper.ensureInitialized()
        .encodeMap<MunicipalitiesState>(this as MunicipalitiesState);
  }

  MunicipalitiesStateCopyWith<MunicipalitiesState, MunicipalitiesState,
          MunicipalitiesState>
      get copyWith => _MunicipalitiesStateCopyWithImpl(
          this as MunicipalitiesState, $identity, $identity);
  @override
  String toString() {
    return MunicipalitiesStateMapper.ensureInitialized()
        .stringifyValue(this as MunicipalitiesState);
  }

  @override
  bool operator ==(Object other) {
    return MunicipalitiesStateMapper.ensureInitialized()
        .equalsValue(this as MunicipalitiesState, other);
  }

  @override
  int get hashCode {
    return MunicipalitiesStateMapper.ensureInitialized()
        .hashValue(this as MunicipalitiesState);
  }
}

extension MunicipalitiesStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MunicipalitiesState, $Out> {
  MunicipalitiesStateCopyWith<$R, MunicipalitiesState, $Out>
      get $asMunicipalitiesState =>
          $base.as((v, t, t2) => _MunicipalitiesStateCopyWithImpl(v, t, t2));
}

abstract class MunicipalitiesStateCopyWith<$R, $In extends MunicipalitiesState,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, DistrictValue, List<MunicipalityValue>,
          ObjectCopyWith<$R, List<MunicipalityValue>, List<MunicipalityValue>>>
      get municipalitiesPerDistrict;
  $R call(
      {Map<DistrictValue, List<MunicipalityValue>>? municipalitiesPerDistrict,
      StateStatus? status});
  MunicipalitiesStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _MunicipalitiesStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MunicipalitiesState, $Out>
    implements MunicipalitiesStateCopyWith<$R, MunicipalitiesState, $Out> {
  _MunicipalitiesStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MunicipalitiesState> $mapper =
      MunicipalitiesStateMapper.ensureInitialized();
  @override
  MapCopyWith<$R, DistrictValue, List<MunicipalityValue>,
          ObjectCopyWith<$R, List<MunicipalityValue>, List<MunicipalityValue>>>
      get municipalitiesPerDistrict => MapCopyWith(
          $value.municipalitiesPerDistrict,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(municipalitiesPerDistrict: v));
  @override
  $R call({Object? municipalitiesPerDistrict = $none, StateStatus? status}) =>
      $apply(FieldCopyWithData({
        if (municipalitiesPerDistrict != $none)
          #municipalitiesPerDistrict: municipalitiesPerDistrict,
        if (status != null) #status: status
      }));
  @override
  MunicipalitiesState $make(CopyWithData data) => MunicipalitiesState(
      municipalitiesPerDistrict: data.get(#municipalitiesPerDistrict,
          or: $value.municipalitiesPerDistrict),
      status: data.get(#status, or: $value.status));

  @override
  MunicipalitiesStateCopyWith<$R2, MunicipalitiesState, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _MunicipalitiesStateCopyWithImpl($value, $cast, t);
}
