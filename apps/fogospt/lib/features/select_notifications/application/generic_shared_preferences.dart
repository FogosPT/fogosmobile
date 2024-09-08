import 'package:shared_preferences/shared_preferences.dart';

class NotificationPreferences {
  static const String _prefPrefix = 'notification_topic_';

  static Future<bool> saveTopicSubscription({
    required String topic,
    required bool isSubscribed,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool('$_prefPrefix$topic', isSubscribed);
  }

  static Future<bool> getTopicSubscription({required String topic}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_prefPrefix$topic') ?? false;
  }
}
