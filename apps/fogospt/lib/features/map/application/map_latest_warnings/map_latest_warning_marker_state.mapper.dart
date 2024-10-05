// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'map_latest_warning_marker_state.dart';

class MapLatestWarningMarkerStateMapper
    extends ClassMapperBase<MapLatestWarningMarkerState> {
  MapLatestWarningMarkerStateMapper._();

  static MapLatestWarningMarkerStateMapper? _instance;
  static MapLatestWarningMarkerStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = MapLatestWarningMarkerStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'MapLatestWarningMarkerState';

  static StateStatus _$status(MapLatestWarningMarkerState v) => v.status;
  static const Field<MapLatestWarningMarkerState, StateStatus> _f$status =
      Field('status', _$status, opt: true, def: StateStatus.initial);
  static Set<Fire> _$warnings(MapLatestWarningMarkerState v) => v.warnings;
  static const Field<MapLatestWarningMarkerState, Set<Fire>> _f$warnings =
      Field('warnings', _$warnings, opt: true);
  static Set<Fire> _$activeWarnings(MapLatestWarningMarkerState v) =>
      v.activeWarnings;
  static const Field<MapLatestWarningMarkerState, Set<Fire>> _f$activeWarnings =
      Field('activeWarnings', _$activeWarnings, opt: true);

  @override
  final MappableFields<MapLatestWarningMarkerState> fields = const {
    #status: _f$status,
    #warnings: _f$warnings,
    #activeWarnings: _f$activeWarnings,
  };

  static MapLatestWarningMarkerState _instantiate(DecodingData data) {
    return MapLatestWarningMarkerState(
        status: data.dec(_f$status),
        warnings: data.dec(_f$warnings),
        activeWarnings: data.dec(_f$activeWarnings));
  }

  @override
  final Function instantiate = _instantiate;

  static MapLatestWarningMarkerState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MapLatestWarningMarkerState>(map);
  }

  static MapLatestWarningMarkerState fromJson(String json) {
    return ensureInitialized().decodeJson<MapLatestWarningMarkerState>(json);
  }
}

mixin MapLatestWarningMarkerStateMappable {
  String toJson() {
    return MapLatestWarningMarkerStateMapper.ensureInitialized()
        .encodeJson<MapLatestWarningMarkerState>(
            this as MapLatestWarningMarkerState);
  }

  Map<String, dynamic> toMap() {
    return MapLatestWarningMarkerStateMapper.ensureInitialized()
        .encodeMap<MapLatestWarningMarkerState>(
            this as MapLatestWarningMarkerState);
  }

  MapLatestWarningMarkerStateCopyWith<MapLatestWarningMarkerState,
          MapLatestWarningMarkerState, MapLatestWarningMarkerState>
      get copyWith => _MapLatestWarningMarkerStateCopyWithImpl(
          this as MapLatestWarningMarkerState, $identity, $identity);
  @override
  String toString() {
    return MapLatestWarningMarkerStateMapper.ensureInitialized()
        .stringifyValue(this as MapLatestWarningMarkerState);
  }

  @override
  bool operator ==(Object other) {
    return MapLatestWarningMarkerStateMapper.ensureInitialized()
        .equalsValue(this as MapLatestWarningMarkerState, other);
  }

  @override
  int get hashCode {
    return MapLatestWarningMarkerStateMapper.ensureInitialized()
        .hashValue(this as MapLatestWarningMarkerState);
  }
}

extension MapLatestWarningMarkerStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MapLatestWarningMarkerState, $Out> {
  MapLatestWarningMarkerStateCopyWith<$R, MapLatestWarningMarkerState, $Out>
      get $asMapLatestWarningMarkerState => $base
          .as((v, t, t2) => _MapLatestWarningMarkerStateCopyWithImpl(v, t, t2));
}

abstract class MapLatestWarningMarkerStateCopyWith<
    $R,
    $In extends MapLatestWarningMarkerState,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {StateStatus? status, Set<Fire>? warnings, Set<Fire>? activeWarnings});
  MapLatestWarningMarkerStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _MapLatestWarningMarkerStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MapLatestWarningMarkerState, $Out>
    implements
        MapLatestWarningMarkerStateCopyWith<$R, MapLatestWarningMarkerState,
            $Out> {
  _MapLatestWarningMarkerStateCopyWithImpl(
      super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MapLatestWarningMarkerState> $mapper =
      MapLatestWarningMarkerStateMapper.ensureInitialized();
  @override
  $R call(
          {StateStatus? status,
          Object? warnings = $none,
          Object? activeWarnings = $none}) =>
      $apply(FieldCopyWithData({
        if (status != null) #status: status,
        if (warnings != $none) #warnings: warnings,
        if (activeWarnings != $none) #activeWarnings: activeWarnings
      }));
  @override
  MapLatestWarningMarkerState $make(CopyWithData data) =>
      MapLatestWarningMarkerState(
          status: data.get(#status, or: $value.status),
          warnings: data.get(#warnings, or: $value.warnings),
          activeWarnings: data.get(#activeWarnings, or: $value.activeWarnings));

  @override
  MapLatestWarningMarkerStateCopyWith<$R2, MapLatestWarningMarkerState, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _MapLatestWarningMarkerStateCopyWithImpl($value, $cast, t);
}
