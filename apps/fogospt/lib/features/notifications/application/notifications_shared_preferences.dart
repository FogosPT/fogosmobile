import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MunicipalitiesSharedPreferences {
  static Future<void> setTopicNotifications(String key, bool value) async {
    final SharedPreferences prefs = GetIt.I.get<SharedPreferences>();
    await prefs.setBool(key, value);
  }

  static Future<bool> getTopicNotifications(String key) async {
    final SharedPreferences prefs = GetIt.I.get<SharedPreferences>();
    return prefs.getBool(key) ?? false;
  }
}
