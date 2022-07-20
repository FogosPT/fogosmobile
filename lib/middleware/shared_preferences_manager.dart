import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static final String _tag = 'SharedPreferencesManager';
  static final SharedPreferencesManager preferences =
      SharedPreferencesManager._();
  static SharedPreferences _instance;
  static bool _showLogs;

  SharedPreferencesManager._();
  _throwError() => throw Exception(
      'Preferences not available. Make sure to call init() before using any other method');

  /// Loads the shared preferences so they are immediately available to use.
  /// This should be called before accessing `preferences`.
  ///
  /// If [withLogs] param is set to `false`, most of the operations won't
  /// print any information.
  static Future<bool> init([bool withLogs = true]) async {
    if (_instance == null) {
      _showLogs = withLogs;
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      _instance = await SharedPreferences.getInstance().catchError((error) {
        print(
            '$_tag: Couldn\'t get the local preferences, operation failed with error: $error');
      });
      print('$_tag: Preferences loaded.');
    }
    return _instance != null;
  }

  /// Returns a `bool` value for the provided [key]
  bool getBool(String key) => _instance.getBool(key);

  /// Returns a `int` value for the provided [key]
  int getInt(String key) => _instance.getInt(key);

  /// Returns a `double` value for the provided [key]
  double getDouble(String key) => _instance.getDouble(key);

  /// Returns a `String` value for the provided [key]
  String getString(String key) => _instance.getString(key);

  /// Returns a `List<String>` value for the provided [key]
  List<String> getStringList(String key) => _instance.getStringList(key);

  /// Saves the [value] for the provided [key].
  ///
  /// Accepted value types are `bool`, `int`, `double`, `String` and `List<String`.
  /// Values must NOT be `null`, if you want to remove a [value] for a specific [key]
  /// use the `remove()` method instead.
  Future<bool> save(String key, dynamic value) async {
    assert(key != null && value != null);
    if (_instance == null) _throwError();
    if (_showLogs) print('$_tag: Saving value [$value] for key [$key].');

    if (value is bool) {
      return _instance.setBool(key, value);
    } else if (value is int) {
      return _instance.setInt(key, value);
    } else if (value is double) {
      return _instance.setDouble(key, value);
    } else if (value is String) {
      return _instance.setString(key, value);
    } else if (value is List) {
      return _instance.setStringList(key, value);
    } else {
      throw Exception('$_tag: Unsupported value type.');
    }
  }

  /// Removes the [value] for the provided [key], thus setting it to `null`.
  ///
  /// The [key] must NOT be `null`.
  Future<bool> remove(String key) async {
    assert(key != null);
    if (_instance == null) _throwError();
    if (_showLogs) print('$_tag: Removing value for key [$key].');

    return _instance.remove(key).catchError((error) {
      print(
          '$_tag: Couldn\'t get remove the value for the key [$key]. Operation failed with the error: $error');
    });
  }
}
