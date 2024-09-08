import 'package:dart_mappable/dart_mappable.dart';
import 'package:warnings/state_management/base_state.dart';
import 'package:warnings/state_management/state_status.dart';

part 'generic_selected_notifications_state.mapper.dart';

@MappableClass()
final class GenericSelectedNotificationsState extends BaseState
    with GenericSelectedNotificationsStateMappable {
  final List<String> notifications;

  GenericSelectedNotificationsState({
    this.notifications = const [],
    super.status = StateStatus.initial,
  });
}

extension GenericSelectedNotificationsStateExtension
    on GenericSelectedNotificationsState {
  GenericSelectedNotificationsState loading() =>
      copyWith(status: StateStatus.loading);

  GenericSelectedNotificationsState success({
    required List<String> notifications,
  }) =>
      copyWith(
        status: StateStatus.success,
        notifications: notifications,
      );

  GenericSelectedNotificationsState failure() =>
      copyWith(status: StateStatus.failure);
}
