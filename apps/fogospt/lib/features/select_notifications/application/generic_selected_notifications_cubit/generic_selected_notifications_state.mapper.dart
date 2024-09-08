// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'generic_selected_notifications_state.dart';

class GenericSelectedNotificationsStateMapper
    extends ClassMapperBase<GenericSelectedNotificationsState> {
  GenericSelectedNotificationsStateMapper._();

  static GenericSelectedNotificationsStateMapper? _instance;
  static GenericSelectedNotificationsStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = GenericSelectedNotificationsStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'GenericSelectedNotificationsState';

  static List<String> _$notifications(GenericSelectedNotificationsState v) =>
      v.notifications;
  static const Field<GenericSelectedNotificationsState, List<String>>
      _f$notifications = Field('notifications', _$notifications);
  static const Field<GenericSelectedNotificationsState, dynamic> _f$status =
      Field('status', null,
          mode: FieldMode.param, opt: true, def: StateStatus.initial);

  @override
  final MappableFields<GenericSelectedNotificationsState> fields = const {
    #notifications: _f$notifications,
    #status: _f$status,
  };

  static GenericSelectedNotificationsState _instantiate(DecodingData data) {
    return GenericSelectedNotificationsState(
        notifications: data.dec(_f$notifications), status: data.dec(_f$status));
  }

  @override
  final Function instantiate = _instantiate;

  static GenericSelectedNotificationsState fromMap(Map<String, dynamic> map) {
    return ensureInitialized()
        .decodeMap<GenericSelectedNotificationsState>(map);
  }

  static GenericSelectedNotificationsState fromJson(String json) {
    return ensureInitialized()
        .decodeJson<GenericSelectedNotificationsState>(json);
  }
}

mixin GenericSelectedNotificationsStateMappable {
  String toJson() {
    return GenericSelectedNotificationsStateMapper.ensureInitialized()
        .encodeJson<GenericSelectedNotificationsState>(
            this as GenericSelectedNotificationsState);
  }

  Map<String, dynamic> toMap() {
    return GenericSelectedNotificationsStateMapper.ensureInitialized()
        .encodeMap<GenericSelectedNotificationsState>(
            this as GenericSelectedNotificationsState);
  }

  GenericSelectedNotificationsStateCopyWith<GenericSelectedNotificationsState,
          GenericSelectedNotificationsState, GenericSelectedNotificationsState>
      get copyWith => _GenericSelectedNotificationsStateCopyWithImpl(
          this as GenericSelectedNotificationsState, $identity, $identity);
  @override
  String toString() {
    return GenericSelectedNotificationsStateMapper.ensureInitialized()
        .stringifyValue(this as GenericSelectedNotificationsState);
  }

  @override
  bool operator ==(Object other) {
    return GenericSelectedNotificationsStateMapper.ensureInitialized()
        .equalsValue(this as GenericSelectedNotificationsState, other);
  }

  @override
  int get hashCode {
    return GenericSelectedNotificationsStateMapper.ensureInitialized()
        .hashValue(this as GenericSelectedNotificationsState);
  }
}

extension GenericSelectedNotificationsStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, GenericSelectedNotificationsState, $Out> {
  GenericSelectedNotificationsStateCopyWith<$R,
          GenericSelectedNotificationsState, $Out>
      get $asGenericSelectedNotificationsState => $base.as((v, t, t2) =>
          _GenericSelectedNotificationsStateCopyWithImpl(v, t, t2));
}

abstract class GenericSelectedNotificationsStateCopyWith<
    $R,
    $In extends GenericSelectedNotificationsState,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
      get notifications;
  $R call({List<String>? notifications, required dynamic status});
  GenericSelectedNotificationsStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _GenericSelectedNotificationsStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, GenericSelectedNotificationsState, $Out>
    implements
        GenericSelectedNotificationsStateCopyWith<$R,
            GenericSelectedNotificationsState, $Out> {
  _GenericSelectedNotificationsStateCopyWithImpl(
      super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<GenericSelectedNotificationsState> $mapper =
      GenericSelectedNotificationsStateMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
      get notifications => ListCopyWith(
          $value.notifications,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(notifications: v));
  @override
  $R call({List<String>? notifications, required dynamic status}) =>
      $apply(FieldCopyWithData({
        if (notifications != null) #notifications: notifications,
        #status: status
      }));
  @override
  GenericSelectedNotificationsState $make(CopyWithData data) =>
      GenericSelectedNotificationsState(
          notifications: data.get(#notifications, or: $value.notifications),
          status: data.get(#status));

  @override
  GenericSelectedNotificationsStateCopyWith<$R2,
      GenericSelectedNotificationsState, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _GenericSelectedNotificationsStateCopyWithImpl($value, $cast, t);
}
