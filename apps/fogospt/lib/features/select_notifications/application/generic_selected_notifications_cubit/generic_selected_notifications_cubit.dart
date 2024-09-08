import 'package:bloc/bloc.dart';
import 'package:fogospt/features/select_notifications/application/generic_notifications_manager.dart';
import 'package:fogospt/features/select_notifications/application/generic_selected_notifications_cubit/generic_selected_notifications_state.dart';
import 'package:fogospt/features/select_notifications/data/generic_shared_preferences.dart';
import 'package:fogospt/main.dart';
import 'package:warnings_core/logger.dart';

/// [appNotificationTopics] is the predefined notification topics for this app
///
/// TODO(FB): move this to a common constants file.
/// TODO(FB): implement the topic: incident-<id-incidente>.
///
final Map<String, String> appNotificationTopics = {
  // 'incident-<id-incidente>': 'Tópico por Incidente',
  'notification-warnings': 'Tópico por Avisos',
  'incident-important': 'Tópico incidentes importantes',
  'notification-all': 'Tópico para todos avisos',
};

class GenericSelectedNotificationsCubit
    extends Cubit<GenericSelectedNotificationsState> {
  GenericSelectedNotificationsCubit()
      : super(GenericSelectedNotificationsState());

  Map<String, bool> _topicsStatus = {};

  /// [appNotificationTopics] is the predefined notification topics for this app
  Map<String, String> get topicNotifications => appNotificationTopics;

  /// [_topicsStatus] is the status of the notification topics for this app.
  /// Picked by the user.
  Map<String, bool> get topicsNotificationsStatus => _topicsStatus;

  Future<void> fetchTopicsStatus() async {
    emit(state.loading());
    try {
      for (String topic in appNotificationTopics.keys) {
        _topicsStatus[topic] =
            await GenericNotificationPreferences.loadTopicNotificationKey(
          key: topic,
        );
      }
      emit(state.success(
        notificationsStatus: _topicsStatus,
      ));
    } catch (e) {
      emit(state.failure());
    }
  }

  /// Subscribe to the generic fire warning topic
  Future<void> subscribeToGenericFireWarning() async {
    emit(state.loading());
    try {
      await messaging.subscribeToTopic(topicWarningFogos);
      _topicsStatus[topicWarningFogos] = true;
      emit(state.success(
        notificationsStatus: _topicsStatus,
      ));
    } catch (e) {
      emit(state.failure());
    }
  }

  /// Handle the subscription to the topic
  Future<void> toggleNotification({
    required String topic,
    required bool toggleValue,
  }) async {
    emit(state.loading());
    try {
      /// Toggle the subscription to the topic in the local storage
      final result =
          await GenericNotificationPreferences.saveTopicNotificationKey(
        key: topic,
        value: toggleValue,
      );

      if (_topicsStatus[topic] != toggleValue) {
        _topicsStatus[topic] = toggleValue;
      }

      if (result) {
        GenericNotificationsManager.toggleNotification(
          topic: topic,
          enabled: toggleValue,
        );
      }

      emit(
        state.success(
          notificationsStatus: _topicsStatus,
        ),
      );
    } catch (e) {
      log('Error toggling subscription for $topic: $e');
      emit(state.failure());
    }
  }
}
