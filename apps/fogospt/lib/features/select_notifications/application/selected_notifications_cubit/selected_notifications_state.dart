import 'package:dart_mappable/dart_mappable.dart';
import 'package:warnings/state_management/base_state.dart';
import 'package:warnings/state_management/state_status.dart';

part 'selected_notifications_state.mapper.dart';

@MappableClass()
final class SelectedNotificationsState extends BaseState
    with SelectedNotificationsStateMappable {
  final Set<String> enabledMunicipalityNotifications;

  SelectedNotificationsState({
    Set<String>? enabledMunicipalityNotifications,
    super.status = StateStatus.initial,
  }) : enabledMunicipalityNotifications =
            enabledMunicipalityNotifications ?? {};
}

extension SelectedNotificationsStateExtension on SelectedNotificationsState {
  SelectedNotificationsState loading() {
    return SelectedNotificationsState(
      status: StateStatus.loading,
      enabledMunicipalityNotifications: enabledMunicipalityNotifications,
    );
  }

  SelectedNotificationsState success({
    required Set<String> activeMunicipalities,
  }) {
    return SelectedNotificationsState(
      status: StateStatus.success,
      enabledMunicipalityNotifications: activeMunicipalities,
    );
  }

  SelectedNotificationsState failure() {
    return SelectedNotificationsState(
      status: StateStatus.failure,
      enabledMunicipalityNotifications: enabledMunicipalityNotifications,
    );
  }
}
