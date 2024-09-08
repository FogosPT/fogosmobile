import 'package:dart_mappable/dart_mappable.dart';
import 'package:warnings/warnings.dart';

part 'generic_selected_notifications_state.mapper.dart';

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
  }) {
    return copyWith(
      status: StateStatus.success,
      notificationsStatus: notificationsStatus,
    );
  }

  GenericSelectedNotificationsState failure() =>
      copyWith(status: StateStatus.failure);
}
