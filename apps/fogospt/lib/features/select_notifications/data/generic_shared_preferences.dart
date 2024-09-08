import 'package:shared_preferences/shared_preferences.dart';

class GenericNotificationPreferences {
  static Future<bool> saveTopicSubscription({
    required String topic,
    required bool isSubscribed,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(topic, isSubscribed);
  }

  static Future<bool> getTopicSubscription({required String topic}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(topic) ?? false;
  }
}
