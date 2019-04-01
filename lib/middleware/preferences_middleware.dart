import 'dart:io';

import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/actions/preferences_actions.dart';
import 'package:fogosmobile/constants/endpoints.dart';

List<Middleware<AppState>> preferencesMiddleware() {
  final loadPreferences = _createLoadPreferences();
  final setPreference = _createSetPreference();

  return [
    TypedMiddleware<AppState, LoadAllPreferencesAction>(loadPreferences),
    TypedMiddleware<AppState, SetPreferenceAction>(setPreference),
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
