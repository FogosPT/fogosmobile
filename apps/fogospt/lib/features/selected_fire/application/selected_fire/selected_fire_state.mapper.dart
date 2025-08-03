// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'selected_fire_state.dart';

class SelectedFireStateMapper extends ClassMapperBase<SelectedFireState> {
  SelectedFireStateMapper._();

  static SelectedFireStateMapper? _instance;
  static SelectedFireStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SelectedFireStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SelectedFireState';

  static StateStatus _$status(SelectedFireState v) => v.status;
  static const Field<SelectedFireState, StateStatus> _f$status =
      Field('status', _$status, opt: true, def: StateStatus.initial);
  static Fire? _$fire(SelectedFireState v) => v.fire;
  static const Field<SelectedFireState, Fire> _f$fire =
      Field('fire', _$fire, opt: true);

  @override
  final MappableFields<SelectedFireState> fields = const {
    #status: _f$status,
    #fire: _f$fire,
  };

  static SelectedFireState _instantiate(DecodingData data) {
    return SelectedFireState(
        status: data.dec(_f$status), fire: data.dec(_f$fire));
  }

  @override
  final Function instantiate = _instantiate;

  static SelectedFireState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SelectedFireState>(map);
  }

  static SelectedFireState fromJson(String json) {
    return ensureInitialized().decodeJson<SelectedFireState>(json);
  }
}

mixin SelectedFireStateMappable {
  String toJson() {
    return SelectedFireStateMapper.ensureInitialized()
        .encodeJson<SelectedFireState>(this as SelectedFireState);
  }

  Map<String, dynamic> toMap() {
    return SelectedFireStateMapper.ensureInitialized()
        .encodeMap<SelectedFireState>(this as SelectedFireState);
  }

  SelectedFireStateCopyWith<SelectedFireState, SelectedFireState,
          SelectedFireState>
      get copyWith =>
          _SelectedFireStateCopyWithImpl<SelectedFireState, SelectedFireState>(
              this as SelectedFireState, $identity, $identity);
  @override
  String toString() {
    return SelectedFireStateMapper.ensureInitialized()
        .stringifyValue(this as SelectedFireState);
  }

  @override
  bool operator ==(Object other) {
    return SelectedFireStateMapper.ensureInitialized()
        .equalsValue(this as SelectedFireState, other);
  }

  @override
  int get hashCode {
    return SelectedFireStateMapper.ensureInitialized()
        .hashValue(this as SelectedFireState);
  }
}

extension SelectedFireStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SelectedFireState, $Out> {
  SelectedFireStateCopyWith<$R, SelectedFireState, $Out>
      get $asSelectedFireState => $base
          .as((v, t, t2) => _SelectedFireStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SelectedFireStateCopyWith<$R, $In extends SelectedFireState,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({StateStatus? status, Fire? fire});
  SelectedFireStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _SelectedFireStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SelectedFireState, $Out>
    implements SelectedFireStateCopyWith<$R, SelectedFireState, $Out> {
  _SelectedFireStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SelectedFireState> $mapper =
      SelectedFireStateMapper.ensureInitialized();
  @override
  $R call({StateStatus? status, Object? fire = $none}) =>
      $apply(FieldCopyWithData({
        if (status != null) #status: status,
        if (fire != $none) #fire: fire
      }));
  @override
  SelectedFireState $make(CopyWithData data) => SelectedFireState(
      status: data.get(#status, or: $value.status),
      fire: data.get(#fire, or: $value.fire));

  @override
  SelectedFireStateCopyWith<$R2, SelectedFireState, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _SelectedFireStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
