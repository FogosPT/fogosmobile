// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'notification_state.dart';

class NotificationStateMapper extends ClassMapperBase<NotificationState> {
  NotificationStateMapper._();

  static NotificationStateMapper? _instance;
  static NotificationStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NotificationStateMapper._());
      NotificationStartedMapper.ensureInitialized();
      NotificationLoadingMapper.ensureInitialized();
      NotificationSuccessfulMapper.ensureInitialized();
      NotificationFailedMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'NotificationState';

  @override
  final MappableFields<NotificationState> fields = const {};

  static NotificationState _instantiate(DecodingData data) {
    throw MapperException.missingConstructor('NotificationState');
  }

  @override
  final Function instantiate = _instantiate;

  static NotificationState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NotificationState>(map);
  }

  static NotificationState fromJson(String json) {
    return ensureInitialized().decodeJson<NotificationState>(json);
  }
}

mixin NotificationStateMappable {
  String toJson();
  Map<String, dynamic> toMap();
  NotificationStateCopyWith<NotificationState, NotificationState,
      NotificationState> get copyWith;
}

abstract class NotificationStateCopyWith<$R, $In extends NotificationState,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  NotificationStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class NotificationStartedMapper extends ClassMapperBase<NotificationStarted> {
  NotificationStartedMapper._();

  static NotificationStartedMapper? _instance;
  static NotificationStartedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NotificationStartedMapper._());
      NotificationStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'NotificationStarted';

  @override
  final MappableFields<NotificationStarted> fields = const {};

  static NotificationStarted _instantiate(DecodingData data) {
    return NotificationStarted();
  }

  @override
  final Function instantiate = _instantiate;

  static NotificationStarted fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NotificationStarted>(map);
  }

  static NotificationStarted fromJson(String json) {
    return ensureInitialized().decodeJson<NotificationStarted>(json);
  }
}

mixin NotificationStartedMappable {
  String toJson() {
    return NotificationStartedMapper.ensureInitialized()
        .encodeJson<NotificationStarted>(this as NotificationStarted);
  }

  Map<String, dynamic> toMap() {
    return NotificationStartedMapper.ensureInitialized()
        .encodeMap<NotificationStarted>(this as NotificationStarted);
  }

  NotificationStartedCopyWith<NotificationStarted, NotificationStarted,
          NotificationStarted>
      get copyWith => _NotificationStartedCopyWithImpl(
          this as NotificationStarted, $identity, $identity);
  @override
  String toString() {
    return NotificationStartedMapper.ensureInitialized()
        .stringifyValue(this as NotificationStarted);
  }

  @override
  bool operator ==(Object other) {
    return NotificationStartedMapper.ensureInitialized()
        .equalsValue(this as NotificationStarted, other);
  }

  @override
  int get hashCode {
    return NotificationStartedMapper.ensureInitialized()
        .hashValue(this as NotificationStarted);
  }
}

extension NotificationStartedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, NotificationStarted, $Out> {
  NotificationStartedCopyWith<$R, NotificationStarted, $Out>
      get $asNotificationStarted =>
          $base.as((v, t, t2) => _NotificationStartedCopyWithImpl(v, t, t2));
}

abstract class NotificationStartedCopyWith<$R, $In extends NotificationStarted,
    $Out> implements NotificationStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  NotificationStartedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _NotificationStartedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, NotificationStarted, $Out>
    implements NotificationStartedCopyWith<$R, NotificationStarted, $Out> {
  _NotificationStartedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<NotificationStarted> $mapper =
      NotificationStartedMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  NotificationStarted $make(CopyWithData data) => NotificationStarted();

  @override
  NotificationStartedCopyWith<$R2, NotificationStarted, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _NotificationStartedCopyWithImpl($value, $cast, t);
}

class NotificationLoadingMapper extends ClassMapperBase<NotificationLoading> {
  NotificationLoadingMapper._();

  static NotificationLoadingMapper? _instance;
  static NotificationLoadingMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NotificationLoadingMapper._());
      NotificationStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'NotificationLoading';

  @override
  final MappableFields<NotificationLoading> fields = const {};

  static NotificationLoading _instantiate(DecodingData data) {
    return NotificationLoading();
  }

  @override
  final Function instantiate = _instantiate;

  static NotificationLoading fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NotificationLoading>(map);
  }

  static NotificationLoading fromJson(String json) {
    return ensureInitialized().decodeJson<NotificationLoading>(json);
  }
}

mixin NotificationLoadingMappable {
  String toJson() {
    return NotificationLoadingMapper.ensureInitialized()
        .encodeJson<NotificationLoading>(this as NotificationLoading);
  }

  Map<String, dynamic> toMap() {
    return NotificationLoadingMapper.ensureInitialized()
        .encodeMap<NotificationLoading>(this as NotificationLoading);
  }

  NotificationLoadingCopyWith<NotificationLoading, NotificationLoading,
          NotificationLoading>
      get copyWith => _NotificationLoadingCopyWithImpl(
          this as NotificationLoading, $identity, $identity);
  @override
  String toString() {
    return NotificationLoadingMapper.ensureInitialized()
        .stringifyValue(this as NotificationLoading);
  }

  @override
  bool operator ==(Object other) {
    return NotificationLoadingMapper.ensureInitialized()
        .equalsValue(this as NotificationLoading, other);
  }

  @override
  int get hashCode {
    return NotificationLoadingMapper.ensureInitialized()
        .hashValue(this as NotificationLoading);
  }
}

extension NotificationLoadingValueCopy<$R, $Out>
    on ObjectCopyWith<$R, NotificationLoading, $Out> {
  NotificationLoadingCopyWith<$R, NotificationLoading, $Out>
      get $asNotificationLoading =>
          $base.as((v, t, t2) => _NotificationLoadingCopyWithImpl(v, t, t2));
}

abstract class NotificationLoadingCopyWith<$R, $In extends NotificationLoading,
    $Out> implements NotificationStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  NotificationLoadingCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _NotificationLoadingCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, NotificationLoading, $Out>
    implements NotificationLoadingCopyWith<$R, NotificationLoading, $Out> {
  _NotificationLoadingCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<NotificationLoading> $mapper =
      NotificationLoadingMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  NotificationLoading $make(CopyWithData data) => NotificationLoading();

  @override
  NotificationLoadingCopyWith<$R2, NotificationLoading, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _NotificationLoadingCopyWithImpl($value, $cast, t);
}

class NotificationSuccessfulMapper
    extends ClassMapperBase<NotificationSuccessful> {
  NotificationSuccessfulMapper._();

  static NotificationSuccessfulMapper? _instance;
  static NotificationSuccessfulMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NotificationSuccessfulMapper._());
      NotificationStateMapper.ensureInitialized();
      MunicipalityMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'NotificationSuccessful';

  static List<Municipality> _$municipalities(NotificationSuccessful v) =>
      v.municipalities;
  static const Field<NotificationSuccessful, List<Municipality>>
      _f$municipalities = Field('municipalities', _$municipalities);

  @override
  final MappableFields<NotificationSuccessful> fields = const {
    #municipalities: _f$municipalities,
  };

  static NotificationSuccessful _instantiate(DecodingData data) {
    return NotificationSuccessful(data.dec(_f$municipalities));
  }

  @override
  final Function instantiate = _instantiate;

  static NotificationSuccessful fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NotificationSuccessful>(map);
  }

  static NotificationSuccessful fromJson(String json) {
    return ensureInitialized().decodeJson<NotificationSuccessful>(json);
  }
}

mixin NotificationSuccessfulMappable {
  String toJson() {
    return NotificationSuccessfulMapper.ensureInitialized()
        .encodeJson<NotificationSuccessful>(this as NotificationSuccessful);
  }

  Map<String, dynamic> toMap() {
    return NotificationSuccessfulMapper.ensureInitialized()
        .encodeMap<NotificationSuccessful>(this as NotificationSuccessful);
  }

  NotificationSuccessfulCopyWith<NotificationSuccessful, NotificationSuccessful,
          NotificationSuccessful>
      get copyWith => _NotificationSuccessfulCopyWithImpl(
          this as NotificationSuccessful, $identity, $identity);
  @override
  String toString() {
    return NotificationSuccessfulMapper.ensureInitialized()
        .stringifyValue(this as NotificationSuccessful);
  }

  @override
  bool operator ==(Object other) {
    return NotificationSuccessfulMapper.ensureInitialized()
        .equalsValue(this as NotificationSuccessful, other);
  }

  @override
  int get hashCode {
    return NotificationSuccessfulMapper.ensureInitialized()
        .hashValue(this as NotificationSuccessful);
  }
}

extension NotificationSuccessfulValueCopy<$R, $Out>
    on ObjectCopyWith<$R, NotificationSuccessful, $Out> {
  NotificationSuccessfulCopyWith<$R, NotificationSuccessful, $Out>
      get $asNotificationSuccessful =>
          $base.as((v, t, t2) => _NotificationSuccessfulCopyWithImpl(v, t, t2));
}

abstract class NotificationSuccessfulCopyWith<
    $R,
    $In extends NotificationSuccessful,
    $Out> implements NotificationStateCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Municipality,
      MunicipalityCopyWith<$R, Municipality, Municipality>> get municipalities;
  @override
  $R call({List<Municipality>? municipalities});
  NotificationSuccessfulCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _NotificationSuccessfulCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, NotificationSuccessful, $Out>
    implements
        NotificationSuccessfulCopyWith<$R, NotificationSuccessful, $Out> {
  _NotificationSuccessfulCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<NotificationSuccessful> $mapper =
      NotificationSuccessfulMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Municipality,
          MunicipalityCopyWith<$R, Municipality, Municipality>>
      get municipalities => ListCopyWith($value.municipalities,
          (v, t) => v.copyWith.$chain(t), (v) => call(municipalities: v));
  @override
  $R call({List<Municipality>? municipalities}) => $apply(FieldCopyWithData(
      {if (municipalities != null) #municipalities: municipalities}));
  @override
  NotificationSuccessful $make(CopyWithData data) => NotificationSuccessful(
      data.get(#municipalities, or: $value.municipalities));

  @override
  NotificationSuccessfulCopyWith<$R2, NotificationSuccessful, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _NotificationSuccessfulCopyWithImpl($value, $cast, t);
}

class NotificationFailedMapper extends ClassMapperBase<NotificationFailed> {
  NotificationFailedMapper._();

  static NotificationFailedMapper? _instance;
  static NotificationFailedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NotificationFailedMapper._());
      NotificationStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'NotificationFailed';

  static String _$error(NotificationFailed v) => v.error;
  static const Field<NotificationFailed, String> _f$error =
      Field('error', _$error);

  @override
  final MappableFields<NotificationFailed> fields = const {
    #error: _f$error,
  };

  static NotificationFailed _instantiate(DecodingData data) {
    return NotificationFailed(error: data.dec(_f$error));
  }

  @override
  final Function instantiate = _instantiate;

  static NotificationFailed fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NotificationFailed>(map);
  }

  static NotificationFailed fromJson(String json) {
    return ensureInitialized().decodeJson<NotificationFailed>(json);
  }
}

mixin NotificationFailedMappable {
  String toJson() {
    return NotificationFailedMapper.ensureInitialized()
        .encodeJson<NotificationFailed>(this as NotificationFailed);
  }

  Map<String, dynamic> toMap() {
    return NotificationFailedMapper.ensureInitialized()
        .encodeMap<NotificationFailed>(this as NotificationFailed);
  }

  NotificationFailedCopyWith<NotificationFailed, NotificationFailed,
          NotificationFailed>
      get copyWith => _NotificationFailedCopyWithImpl(
          this as NotificationFailed, $identity, $identity);
  @override
  String toString() {
    return NotificationFailedMapper.ensureInitialized()
        .stringifyValue(this as NotificationFailed);
  }

  @override
  bool operator ==(Object other) {
    return NotificationFailedMapper.ensureInitialized()
        .equalsValue(this as NotificationFailed, other);
  }

  @override
  int get hashCode {
    return NotificationFailedMapper.ensureInitialized()
        .hashValue(this as NotificationFailed);
  }
}

extension NotificationFailedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, NotificationFailed, $Out> {
  NotificationFailedCopyWith<$R, NotificationFailed, $Out>
      get $asNotificationFailed =>
          $base.as((v, t, t2) => _NotificationFailedCopyWithImpl(v, t, t2));
}

abstract class NotificationFailedCopyWith<$R, $In extends NotificationFailed,
    $Out> implements NotificationStateCopyWith<$R, $In, $Out> {
  @override
  $R call({String? error});
  NotificationFailedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _NotificationFailedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, NotificationFailed, $Out>
    implements NotificationFailedCopyWith<$R, NotificationFailed, $Out> {
  _NotificationFailedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<NotificationFailed> $mapper =
      NotificationFailedMapper.ensureInitialized();
  @override
  $R call({String? error}) =>
      $apply(FieldCopyWithData({if (error != null) #error: error}));
  @override
  NotificationFailed $make(CopyWithData data) =>
      NotificationFailed(error: data.get(#error, or: $value.error));

  @override
  NotificationFailedCopyWith<$R2, NotificationFailed, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _NotificationFailedCopyWithImpl($value, $cast, t);
}
