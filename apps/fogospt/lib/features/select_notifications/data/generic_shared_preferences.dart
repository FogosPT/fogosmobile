import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenericNotificationPreferences {
  static Future<bool> saveTopicNotificationKey({
    required String key,
    required bool value,
  }) async {
    final SharedPreferences prefs = await GetIt.I.getAsync<SharedPreferences>();
    return await prefs.setBool(key, value);
  }

  static Future<bool> loadTopicNotificationKey({required String key}) async {
    final SharedPreferences prefs = await GetIt.I.getAsync<SharedPreferences>();
    return prefs.getBool(key) ?? false;
  }
}
