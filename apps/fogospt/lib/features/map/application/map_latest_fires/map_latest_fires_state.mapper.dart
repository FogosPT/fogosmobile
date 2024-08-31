// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'map_latest_fires_state.dart';

class MapLatestFiresStateMapper extends ClassMapperBase<MapLatestFiresState> {
  MapLatestFiresStateMapper._();

  static MapLatestFiresStateMapper? _instance;
  static MapLatestFiresStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MapLatestFiresStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'MapLatestFiresState';

  static StateStatus _$status(MapLatestFiresState v) => v.status;
  static const Field<MapLatestFiresState, StateStatus> _f$status =
      Field('status', _$status, opt: true, def: StateStatus.initial);
  static List<Fire> _$fires(MapLatestFiresState v) => v.fires;
  static const Field<MapLatestFiresState, List<Fire>> _f$fires =
      Field('fires', _$fires, opt: true, def: const []);

  @override
  final MappableFields<MapLatestFiresState> fields = const {
    #status: _f$status,
    #fires: _f$fires,
  };

  static MapLatestFiresState _instantiate(DecodingData data) {
    return MapLatestFiresState(
        status: data.dec(_f$status), fires: data.dec(_f$fires));
  }

  @override
  final Function instantiate = _instantiate;

  static MapLatestFiresState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MapLatestFiresState>(map);
  }

  static MapLatestFiresState fromJson(String json) {
    return ensureInitialized().decodeJson<MapLatestFiresState>(json);
  }
}

mixin MapLatestFiresStateMappable {
  String toJson() {
    return MapLatestFiresStateMapper.ensureInitialized()
        .encodeJson<MapLatestFiresState>(this as MapLatestFiresState);
  }

  Map<String, dynamic> toMap() {
    return MapLatestFiresStateMapper.ensureInitialized()
        .encodeMap<MapLatestFiresState>(this as MapLatestFiresState);
  }

  MapLatestFiresStateCopyWith<MapLatestFiresState, MapLatestFiresState,
          MapLatestFiresState>
      get copyWith => _MapLatestFiresStateCopyWithImpl(
          this as MapLatestFiresState, $identity, $identity);
  @override
  String toString() {
    return MapLatestFiresStateMapper.ensureInitialized()
        .stringifyValue(this as MapLatestFiresState);
  }

  @override
  bool operator ==(Object other) {
    return MapLatestFiresStateMapper.ensureInitialized()
        .equalsValue(this as MapLatestFiresState, other);
  }

  @override
  int get hashCode {
    return MapLatestFiresStateMapper.ensureInitialized()
        .hashValue(this as MapLatestFiresState);
  }
}

extension MapLatestFiresStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MapLatestFiresState, $Out> {
  MapLatestFiresStateCopyWith<$R, MapLatestFiresState, $Out>
      get $asMapLatestFiresState =>
          $base.as((v, t, t2) => _MapLatestFiresStateCopyWithImpl(v, t, t2));
}

abstract class MapLatestFiresStateCopyWith<$R, $In extends MapLatestFiresState,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Fire, ObjectCopyWith<$R, Fire, Fire>> get fires;
  $R call({StateStatus? status, List<Fire>? fires});
  MapLatestFiresStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _MapLatestFiresStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MapLatestFiresState, $Out>
    implements MapLatestFiresStateCopyWith<$R, MapLatestFiresState, $Out> {
  _MapLatestFiresStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MapLatestFiresState> $mapper =
      MapLatestFiresStateMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Fire, ObjectCopyWith<$R, Fire, Fire>> get fires =>
      ListCopyWith($value.fires, (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(fires: v));
  @override
  $R call({StateStatus? status, List<Fire>? fires}) => $apply(FieldCopyWithData(
      {if (status != null) #status: status, if (fires != null) #fires: fires}));
  @override
  MapLatestFiresState $make(CopyWithData data) => MapLatestFiresState(
      status: data.get(#status, or: $value.status),
      fires: data.get(#fires, or: $value.fires));

  @override
  MapLatestFiresStateCopyWith<$R2, MapLatestFiresState, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _MapLatestFiresStateCopyWithImpl($value, $cast, t);
}
