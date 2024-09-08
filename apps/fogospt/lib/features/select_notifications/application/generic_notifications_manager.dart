import 'package:fogospt/main.dart';

class GenericNotificationsManager {
  static Future<void> toggleNotification({
    required String topic,
    required bool enabled,
  }) async {
    toggleFirebaseMessageByTopic(
      toggleValue: enabled,
      topic: topic,
    );
  }
}
