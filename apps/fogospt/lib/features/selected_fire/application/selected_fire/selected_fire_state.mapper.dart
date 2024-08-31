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
      SelectedFireInitialStateMapper.ensureInitialized();
      SelectedFireLoadingStateMapper.ensureInitialized();
      SelectedFireLoadedStateMapper.ensureInitialized();
      SelectedFireFailedStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SelectedFireState';

  @override
  final MappableFields<SelectedFireState> fields = const {};

  static SelectedFireState _instantiate(DecodingData data) {
    throw MapperException.missingConstructor('SelectedFireState');
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
  String toJson();
  Map<String, dynamic> toMap();
  SelectedFireStateCopyWith<SelectedFireState, SelectedFireState,
      SelectedFireState> get copyWith;
}

abstract class SelectedFireStateCopyWith<$R, $In extends SelectedFireState,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  SelectedFireStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class SelectedFireInitialStateMapper
    extends ClassMapperBase<SelectedFireInitialState> {
  SelectedFireInitialStateMapper._();

  static SelectedFireInitialStateMapper? _instance;
  static SelectedFireInitialStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = SelectedFireInitialStateMapper._());
      SelectedFireStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SelectedFireInitialState';

  @override
  final MappableFields<SelectedFireInitialState> fields = const {};

  static SelectedFireInitialState _instantiate(DecodingData data) {
    return SelectedFireInitialState();
  }

  @override
  final Function instantiate = _instantiate;

  static SelectedFireInitialState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SelectedFireInitialState>(map);
  }

  static SelectedFireInitialState fromJson(String json) {
    return ensureInitialized().decodeJson<SelectedFireInitialState>(json);
  }
}

mixin SelectedFireInitialStateMappable {
  String toJson() {
    return SelectedFireInitialStateMapper.ensureInitialized()
        .encodeJson<SelectedFireInitialState>(this as SelectedFireInitialState);
  }

  Map<String, dynamic> toMap() {
    return SelectedFireInitialStateMapper.ensureInitialized()
        .encodeMap<SelectedFireInitialState>(this as SelectedFireInitialState);
  }

  SelectedFireInitialStateCopyWith<SelectedFireInitialState,
          SelectedFireInitialState, SelectedFireInitialState>
      get copyWith => _SelectedFireInitialStateCopyWithImpl(
          this as SelectedFireInitialState, $identity, $identity);
  @override
  String toString() {
    return SelectedFireInitialStateMapper.ensureInitialized()
        .stringifyValue(this as SelectedFireInitialState);
  }

  @override
  bool operator ==(Object other) {
    return SelectedFireInitialStateMapper.ensureInitialized()
        .equalsValue(this as SelectedFireInitialState, other);
  }

  @override
  int get hashCode {
    return SelectedFireInitialStateMapper.ensureInitialized()
        .hashValue(this as SelectedFireInitialState);
  }
}

extension SelectedFireInitialStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SelectedFireInitialState, $Out> {
  SelectedFireInitialStateCopyWith<$R, SelectedFireInitialState, $Out>
      get $asSelectedFireInitialState => $base
          .as((v, t, t2) => _SelectedFireInitialStateCopyWithImpl(v, t, t2));
}

abstract class SelectedFireInitialStateCopyWith<
    $R,
    $In extends SelectedFireInitialState,
    $Out> implements SelectedFireStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  SelectedFireInitialStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _SelectedFireInitialStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SelectedFireInitialState, $Out>
    implements
        SelectedFireInitialStateCopyWith<$R, SelectedFireInitialState, $Out> {
  _SelectedFireInitialStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SelectedFireInitialState> $mapper =
      SelectedFireInitialStateMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  SelectedFireInitialState $make(CopyWithData data) =>
      SelectedFireInitialState();

  @override
  SelectedFireInitialStateCopyWith<$R2, SelectedFireInitialState, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _SelectedFireInitialStateCopyWithImpl($value, $cast, t);
}

class SelectedFireLoadingStateMapper
    extends ClassMapperBase<SelectedFireLoadingState> {
  SelectedFireLoadingStateMapper._();

  static SelectedFireLoadingStateMapper? _instance;
  static SelectedFireLoadingStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = SelectedFireLoadingStateMapper._());
      SelectedFireStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SelectedFireLoadingState';

  @override
  final MappableFields<SelectedFireLoadingState> fields = const {};

  static SelectedFireLoadingState _instantiate(DecodingData data) {
    return SelectedFireLoadingState();
  }

  @override
  final Function instantiate = _instantiate;

  static SelectedFireLoadingState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SelectedFireLoadingState>(map);
  }

  static SelectedFireLoadingState fromJson(String json) {
    return ensureInitialized().decodeJson<SelectedFireLoadingState>(json);
  }
}

mixin SelectedFireLoadingStateMappable {
  String toJson() {
    return SelectedFireLoadingStateMapper.ensureInitialized()
        .encodeJson<SelectedFireLoadingState>(this as SelectedFireLoadingState);
  }

  Map<String, dynamic> toMap() {
    return SelectedFireLoadingStateMapper.ensureInitialized()
        .encodeMap<SelectedFireLoadingState>(this as SelectedFireLoadingState);
  }

  SelectedFireLoadingStateCopyWith<SelectedFireLoadingState,
          SelectedFireLoadingState, SelectedFireLoadingState>
      get copyWith => _SelectedFireLoadingStateCopyWithImpl(
          this as SelectedFireLoadingState, $identity, $identity);
  @override
  String toString() {
    return SelectedFireLoadingStateMapper.ensureInitialized()
        .stringifyValue(this as SelectedFireLoadingState);
  }

  @override
  bool operator ==(Object other) {
    return SelectedFireLoadingStateMapper.ensureInitialized()
        .equalsValue(this as SelectedFireLoadingState, other);
  }

  @override
  int get hashCode {
    return SelectedFireLoadingStateMapper.ensureInitialized()
        .hashValue(this as SelectedFireLoadingState);
  }
}

extension SelectedFireLoadingStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SelectedFireLoadingState, $Out> {
  SelectedFireLoadingStateCopyWith<$R, SelectedFireLoadingState, $Out>
      get $asSelectedFireLoadingState => $base
          .as((v, t, t2) => _SelectedFireLoadingStateCopyWithImpl(v, t, t2));
}

abstract class SelectedFireLoadingStateCopyWith<
    $R,
    $In extends SelectedFireLoadingState,
    $Out> implements SelectedFireStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  SelectedFireLoadingStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _SelectedFireLoadingStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SelectedFireLoadingState, $Out>
    implements
        SelectedFireLoadingStateCopyWith<$R, SelectedFireLoadingState, $Out> {
  _SelectedFireLoadingStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SelectedFireLoadingState> $mapper =
      SelectedFireLoadingStateMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  SelectedFireLoadingState $make(CopyWithData data) =>
      SelectedFireLoadingState();

  @override
  SelectedFireLoadingStateCopyWith<$R2, SelectedFireLoadingState, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _SelectedFireLoadingStateCopyWithImpl($value, $cast, t);
}

class SelectedFireLoadedStateMapper
    extends ClassMapperBase<SelectedFireLoadedState> {
  SelectedFireLoadedStateMapper._();

  static SelectedFireLoadedStateMapper? _instance;
  static SelectedFireLoadedStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = SelectedFireLoadedStateMapper._());
      SelectedFireStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SelectedFireLoadedState';

  static Fire _$fire(SelectedFireLoadedState v) => v.fire;
  static const Field<SelectedFireLoadedState, Fire> _f$fire =
      Field('fire', _$fire);

  @override
  final MappableFields<SelectedFireLoadedState> fields = const {
    #fire: _f$fire,
  };

  static SelectedFireLoadedState _instantiate(DecodingData data) {
    return SelectedFireLoadedState(data.dec(_f$fire));
  }

  @override
  final Function instantiate = _instantiate;

  static SelectedFireLoadedState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SelectedFireLoadedState>(map);
  }

  static SelectedFireLoadedState fromJson(String json) {
    return ensureInitialized().decodeJson<SelectedFireLoadedState>(json);
  }
}

mixin SelectedFireLoadedStateMappable {
  String toJson() {
    return SelectedFireLoadedStateMapper.ensureInitialized()
        .encodeJson<SelectedFireLoadedState>(this as SelectedFireLoadedState);
  }

  Map<String, dynamic> toMap() {
    return SelectedFireLoadedStateMapper.ensureInitialized()
        .encodeMap<SelectedFireLoadedState>(this as SelectedFireLoadedState);
  }

  SelectedFireLoadedStateCopyWith<SelectedFireLoadedState,
          SelectedFireLoadedState, SelectedFireLoadedState>
      get copyWith => _SelectedFireLoadedStateCopyWithImpl(
          this as SelectedFireLoadedState, $identity, $identity);
  @override
  String toString() {
    return SelectedFireLoadedStateMapper.ensureInitialized()
        .stringifyValue(this as SelectedFireLoadedState);
  }

  @override
  bool operator ==(Object other) {
    return SelectedFireLoadedStateMapper.ensureInitialized()
        .equalsValue(this as SelectedFireLoadedState, other);
  }

  @override
  int get hashCode {
    return SelectedFireLoadedStateMapper.ensureInitialized()
        .hashValue(this as SelectedFireLoadedState);
  }
}

extension SelectedFireLoadedStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SelectedFireLoadedState, $Out> {
  SelectedFireLoadedStateCopyWith<$R, SelectedFireLoadedState, $Out>
      get $asSelectedFireLoadedState => $base
          .as((v, t, t2) => _SelectedFireLoadedStateCopyWithImpl(v, t, t2));
}

abstract class SelectedFireLoadedStateCopyWith<
    $R,
    $In extends SelectedFireLoadedState,
    $Out> implements SelectedFireStateCopyWith<$R, $In, $Out> {
  @override
  $R call({Fire? fire});
  SelectedFireLoadedStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _SelectedFireLoadedStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SelectedFireLoadedState, $Out>
    implements
        SelectedFireLoadedStateCopyWith<$R, SelectedFireLoadedState, $Out> {
  _SelectedFireLoadedStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SelectedFireLoadedState> $mapper =
      SelectedFireLoadedStateMapper.ensureInitialized();
  @override
  $R call({Fire? fire}) =>
      $apply(FieldCopyWithData({if (fire != null) #fire: fire}));
  @override
  SelectedFireLoadedState $make(CopyWithData data) =>
      SelectedFireLoadedState(data.get(#fire, or: $value.fire));

  @override
  SelectedFireLoadedStateCopyWith<$R2, SelectedFireLoadedState, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _SelectedFireLoadedStateCopyWithImpl($value, $cast, t);
}

class SelectedFireFailedStateMapper
    extends ClassMapperBase<SelectedFireFailedState> {
  SelectedFireFailedStateMapper._();

  static SelectedFireFailedStateMapper? _instance;
  static SelectedFireFailedStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = SelectedFireFailedStateMapper._());
      SelectedFireStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SelectedFireFailedState';

  @override
  final MappableFields<SelectedFireFailedState> fields = const {};

  static SelectedFireFailedState _instantiate(DecodingData data) {
    return SelectedFireFailedState();
  }

  @override
  final Function instantiate = _instantiate;

  static SelectedFireFailedState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SelectedFireFailedState>(map);
  }

  static SelectedFireFailedState fromJson(String json) {
    return ensureInitialized().decodeJson<SelectedFireFailedState>(json);
  }
}

mixin SelectedFireFailedStateMappable {
  String toJson() {
    return SelectedFireFailedStateMapper.ensureInitialized()
        .encodeJson<SelectedFireFailedState>(this as SelectedFireFailedState);
  }

  Map<String, dynamic> toMap() {
    return SelectedFireFailedStateMapper.ensureInitialized()
        .encodeMap<SelectedFireFailedState>(this as SelectedFireFailedState);
  }

  SelectedFireFailedStateCopyWith<SelectedFireFailedState,
          SelectedFireFailedState, SelectedFireFailedState>
      get copyWith => _SelectedFireFailedStateCopyWithImpl(
          this as SelectedFireFailedState, $identity, $identity);
  @override
  String toString() {
    return SelectedFireFailedStateMapper.ensureInitialized()
        .stringifyValue(this as SelectedFireFailedState);
  }

  @override
  bool operator ==(Object other) {
    return SelectedFireFailedStateMapper.ensureInitialized()
        .equalsValue(this as SelectedFireFailedState, other);
  }

  @override
  int get hashCode {
    return SelectedFireFailedStateMapper.ensureInitialized()
        .hashValue(this as SelectedFireFailedState);
  }
}

extension SelectedFireFailedStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SelectedFireFailedState, $Out> {
  SelectedFireFailedStateCopyWith<$R, SelectedFireFailedState, $Out>
      get $asSelectedFireFailedState => $base
          .as((v, t, t2) => _SelectedFireFailedStateCopyWithImpl(v, t, t2));
}

abstract class SelectedFireFailedStateCopyWith<
    $R,
    $In extends SelectedFireFailedState,
    $Out> implements SelectedFireStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  SelectedFireFailedStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _SelectedFireFailedStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SelectedFireFailedState, $Out>
    implements
        SelectedFireFailedStateCopyWith<$R, SelectedFireFailedState, $Out> {
  _SelectedFireFailedStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SelectedFireFailedState> $mapper =
      SelectedFireFailedStateMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  SelectedFireFailedState $make(CopyWithData data) => SelectedFireFailedState();

  @override
  SelectedFireFailedStateCopyWith<$R2, SelectedFireFailedState, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _SelectedFireFailedStateCopyWithImpl($value, $cast, t);
}
