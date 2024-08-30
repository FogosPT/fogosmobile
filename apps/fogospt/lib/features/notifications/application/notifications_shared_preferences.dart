import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MunicipalitiesSharedPreferences {
  static Future<bool> setTopicNotifications(String key, bool value) async {
    final SharedPreferences prefs = await GetIt.I.getAsync<SharedPreferences>();
    return await prefs.setBool(key, value);
  }

  static Future<bool> getTopicNotifications(String key) async {
    final SharedPreferences prefs = await GetIt.I.getAsync<SharedPreferences>();
    if (prefs.containsKey(key)) {
      try {
        return prefs.getBool(key) ?? false;
      } on Exception catch (_) {
        // not boolean
        return false;
      }
    }
    // Not found
    return false;
  }
}
