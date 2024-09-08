import 'package:dart_mappable/dart_mappable.dart';
import 'package:warnings/state_management/state_status.dart';
import 'package:warnings/warnings.dart';

part 'generic_selected_notifications_state.mapper.dart';

/// Base State for the GenericSelectedNotificationsCubit.
///
/// Extends the StateStatus.loading to include a useful id of what is loading.
///
class GenericSelectedNotificationsBaseState extends StateStatus {}

@MappableClass()
final class GenericSelectedNotificationsState extends BaseState
    with GenericSelectedNotificationsStateMappable {
  final Map<String, bool> notificationsStatus;

  GenericSelectedNotificationsState({
    this.notificationsStatus = const {},
    super.status = StateStatus.initial,
  });
}

extension GenericSelectedNotificationsStateExtension
    on GenericSelectedNotificationsState {
  GenericSelectedNotificationsState loading() =>
      copyWith(status: StateStatus.loading);

  GenericSelectedNotificationsState success({
    required Map<String, bool> notificationsStatus,
  }) =>
      copyWith(
        status: StateStatus.success,
        notificationsStatus: notificationsStatus,
      );

  GenericSelectedNotificationsState failure() =>
      copyWith(status: StateStatus.failure);
}
