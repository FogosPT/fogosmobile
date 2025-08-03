// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'selected_notifications_state.dart';

class SelectedNotificationsStateMapper
    extends ClassMapperBase<SelectedNotificationsState> {
  SelectedNotificationsStateMapper._();

  static SelectedNotificationsStateMapper? _instance;
  static SelectedNotificationsStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = SelectedNotificationsStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SelectedNotificationsState';

  static Set<String> _$enabledMunicipalityNotifications(
          SelectedNotificationsState v) =>
      v.enabledMunicipalityNotifications;
  static const Field<SelectedNotificationsState, Set<String>>
      _f$enabledMunicipalityNotifications = Field(
          'enabledMunicipalityNotifications',
          _$enabledMunicipalityNotifications,
          opt: true);
  static StateStatus _$status(SelectedNotificationsState v) => v.status;
  static const Field<SelectedNotificationsState, StateStatus> _f$status =
      Field('status', _$status, opt: true, def: StateStatus.initial);

  @override
  final MappableFields<SelectedNotificationsState> fields = const {
    #enabledMunicipalityNotifications: _f$enabledMunicipalityNotifications,
    #status: _f$status,
  };

  static SelectedNotificationsState _instantiate(DecodingData data) {
    return SelectedNotificationsState(
        enabledMunicipalityNotifications:
            data.dec(_f$enabledMunicipalityNotifications),
        status: data.dec(_f$status));
  }

  @override
  final Function instantiate = _instantiate;

  static SelectedNotificationsState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SelectedNotificationsState>(map);
  }

  static SelectedNotificationsState fromJson(String json) {
    return ensureInitialized().decodeJson<SelectedNotificationsState>(json);
  }
}

mixin SelectedNotificationsStateMappable {
  String toJson() {
    return SelectedNotificationsStateMapper.ensureInitialized()
        .encodeJson<SelectedNotificationsState>(
            this as SelectedNotificationsState);
  }

  Map<String, dynamic> toMap() {
    return SelectedNotificationsStateMapper.ensureInitialized()
        .encodeMap<SelectedNotificationsState>(
            this as SelectedNotificationsState);
  }

  SelectedNotificationsStateCopyWith<SelectedNotificationsState,
          SelectedNotificationsState, SelectedNotificationsState>
      get copyWith => _SelectedNotificationsStateCopyWithImpl<
              SelectedNotificationsState, SelectedNotificationsState>(
          this as SelectedNotificationsState, $identity, $identity);
  @override
  String toString() {
    return SelectedNotificationsStateMapper.ensureInitialized()
        .stringifyValue(this as SelectedNotificationsState);
  }

  @override
  bool operator ==(Object other) {
    return SelectedNotificationsStateMapper.ensureInitialized()
        .equalsValue(this as SelectedNotificationsState, other);
  }

  @override
  int get hashCode {
    return SelectedNotificationsStateMapper.ensureInitialized()
        .hashValue(this as SelectedNotificationsState);
  }
}

extension SelectedNotificationsStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SelectedNotificationsState, $Out> {
  SelectedNotificationsStateCopyWith<$R, SelectedNotificationsState, $Out>
      get $asSelectedNotificationsState => $base.as((v, t, t2) =>
          _SelectedNotificationsStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SelectedNotificationsStateCopyWith<
    $R,
    $In extends SelectedNotificationsState,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({Set<String>? enabledMunicipalityNotifications, StateStatus? status});
  SelectedNotificationsStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _SelectedNotificationsStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SelectedNotificationsState, $Out>
    implements
        SelectedNotificationsStateCopyWith<$R, SelectedNotificationsState,
            $Out> {
  _SelectedNotificationsStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SelectedNotificationsState> $mapper =
      SelectedNotificationsStateMapper.ensureInitialized();
  @override
  $R call(
          {Object? enabledMunicipalityNotifications = $none,
          StateStatus? status}) =>
      $apply(FieldCopyWithData({
        if (enabledMunicipalityNotifications != $none)
          #enabledMunicipalityNotifications: enabledMunicipalityNotifications,
        if (status != null) #status: status
      }));
  @override
  SelectedNotificationsState $make(
          CopyWithData data) =>
      SelectedNotificationsState(
          enabledMunicipalityNotifications: data.get(
              #enabledMunicipalityNotifications,
              or: $value.enabledMunicipalityNotifications),
          status: data.get(#status, or: $value.status));

  @override
  SelectedNotificationsStateCopyWith<$R2, SelectedNotificationsState, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _SelectedNotificationsStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
