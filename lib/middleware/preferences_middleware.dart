import 'dart:io';

import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/actions/preferences_actions.dart';
import 'package:fogosmobile/constants/endpoints.dart';

List<Middleware<AppState>> preferencesMiddleware() {
  final loadPreferences = _createLoadPreferences();
  final setPreference = _createSetPreference();
  final setNotification = _createSetNotification();

  return [
    TypedMiddleware<AppState, LoadAllPreferencesAction>(loadPreferences),
    TypedMiddleware<AppState, SetPreferenceAction>(setPreference),
    TypedMiddleware<AppState, SetFireNotificationAction>(setNotification),
  ];
}

Middleware<AppState> _createLoadPreferences() {
  return (Store store, action, NextDispatcher next) async {
    next(action);

    try {
      String url = endpoints['getLocations'];
      final response = await http.get(url);
      final locations = json.decode(utf8.decode(response.bodyBytes))['rows'];

      Map data = {};
      final prefs = await SharedPreferences.getInstance();

      for (Map location in locations) {
        data['pref-${location['key']}'] = prefs.getInt(location['key']) ?? 0;
      }

      List<String> subbedFires = prefs.getStringList('subscribedFires') ?? [];
      List<Fire> fires = store.state.fires;

      if (fires.length > 0) {
        data['subscribedFires'] = fires.where((f) => subbedFires.contains(f.id)).toList();
      } else {
        data['subscribedFires'] = [];
      }

      store.dispatch(new AllPreferencesLoadedAction(data));
    } catch (e) {}
  };
}

Middleware<AppState> _createSetPreference() {
  return (Store store, action, NextDispatcher next) async {
    next(action);
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

    String topic = Platform.isIOS ? 'mobile-ios-${action.key}' : 'mobile-android-${action.key}';

    if (action.value == 1) {
      _firebaseMessaging.subscribeToTopic(topic);
    } else {
      _firebaseMessaging.unsubscribeFromTopic(topic);
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt(action.key, action.value);
      store.dispatch(new LoadAllPreferencesAction());
    } catch (e) {}
  };
}

Middleware<AppState> _createSetNotification() {
  return (Store store, action, NextDispatcher next) async {
    next(action);
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

    String topic = Platform.isIOS ? 'mobile-ios-${action.key}' : 'mobile-android-${action.key}';

    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> subscribedFires = prefs.getStringList('subscribedFires') ?? [];
      if (action.value == 1 && subscribedFires.contains(action.key) == false) {
        subscribedFires.add(action.key);
        _firebaseMessaging.subscribeToTopic(topic);
      } else {
        subscribedFires.remove(action.key);
        _firebaseMessaging.unsubscribeFromTopic(topic);
      }
      prefs.setStringList('subscribedFires', subscribedFires);
      store.dispatch(new LoadAllPreferencesAction());
    } catch (e) {
      print(e);
    }
  };
}