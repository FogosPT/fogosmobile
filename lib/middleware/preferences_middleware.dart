import 'dart:io';

import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/middleware/shared_preferences_manager.dart';
import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/actions/preferences_actions.dart';
import 'package:fogosmobile/constants/endpoints.dart';

List<Middleware<AppState>> preferencesMiddleware() {
  final loadPreferences = _createLoadPreferences();
  final setPreference = _createSetPreference();
  final setNotification = _createSetNotification();
  final selectFireFilters = _createSelectFireFilters();

  return [
    TypedMiddleware<AppState, LoadAllPreferencesAction>(loadPreferences),
    TypedMiddleware<AppState, SetPreferenceAction>(setPreference),
    TypedMiddleware<AppState, SetFireNotificationAction>(setNotification),
    TypedMiddleware<AppState, SelectFireFiltersAction>(selectFireFilters),
  ];
}

Middleware<AppState> _createLoadPreferences() {
  return (Store store, action, NextDispatcher next) async {
    next(action);

    try {
      String url = Endpoints.getLocations;
      final response = await http.get(url);
      final locations = json.decode(utf8.decode(response.bodyBytes))['rows'];

      Map data = {};
      final prefs = SharedPreferencesManager.preferences;

      for (Map location in locations) {
        data['pref-${location['key']}'] = prefs.getInt(location['key']) ?? 0;
      }

      List<String> subbedFires = prefs.getStringList('subscribedFires') ?? [];
      List<Fire> fires = List.from(store.state.fires);

      List<FireStatus> saveFilters = prefs.getStringList('active_filters')
          ?.map((filter)=>Fire.statusFromJson(filter))
          ?.toList()
          ?? List.from(FireStatus.values);


      if (fires.length > 0) {
        data['subscribedFires'] =
            fires.where((f) => subbedFires.contains(f.id)).toList();
      } else {
        data['subscribedFires'] = [];
      }

      data['pref-important'] = prefs.getInt('important') ?? 0;
      data['pref-warnings'] = prefs.getInt('warnings') ?? 0;
      
      store.dispatch(new AllPreferencesLoadedAction(data));
      store.dispatch(new SavedFireFiltersAction(saveFilters));
    } catch (e) {
      print(e);
    }
  };
}

Middleware<AppState> _createSetPreference() {
  return (Store store, action, NextDispatcher next) async {
    next(action);
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

    String topic = Platform.isIOS
        ? 'mobile-ios-${action.key}'
        : 'mobile-android-${action.key}';

    if (action.value == 1) {
      _firebaseMessaging.subscribeToTopic(topic);
    } else {
      _firebaseMessaging.unsubscribeFromTopic(topic);
    }

    try {
      final prefs = SharedPreferencesManager.preferences;
      prefs.save(action.key, action.value);
      store.dispatch(new LoadAllPreferencesAction());
    } catch (e) {}
  };
}

Middleware<AppState> _createSetNotification() {
  return (Store store, action, NextDispatcher next) async {
    next(action);
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

    String topic = Platform.isIOS
        ? 'mobile-ios-${action.key}'
        : 'mobile-android-${action.key}';

    try {
      final prefs = SharedPreferencesManager.preferences;
      List<String> subscribedFires =
          prefs.getStringList('subscribedFires') ?? [];
      if (action.value == 1 && subscribedFires.contains(action.key) == false) {
        subscribedFires.add(action.key);
        _firebaseMessaging.subscribeToTopic(topic);
      } else {
        subscribedFires.remove(action.key);
        _firebaseMessaging.unsubscribeFromTopic(topic);
      }
      prefs.save('subscribedFires', subscribedFires);
      store.dispatch(new LoadAllPreferencesAction());
    } catch (e) {
      print(e);
    }
  };
}

Middleware<AppState> _createSelectFireFilters() {
  return (Store store, action, NextDispatcher next) async {
    next(action);
    try {
      final prefs = SharedPreferencesManager.preferences;

      FireStatus filter = action.filter;

      List<String> activeFilters = prefs.getStringList('active_filters');


      List<FireStatus> saveFilters = activeFilters
          ?.map((filter)=>Fire.statusFromJson(filter))
          ?.toList()
          ?? List.from(FireStatus.values);

      if(saveFilters.contains(filter))
        saveFilters.remove(filter);
      else
        saveFilters.add(filter);

      prefs.save('active_filters', saveFilters.map((f) => Fire.statusToJson(f)).toList());
      store.dispatch(new SavedFireFiltersAction(saveFilters));
    } catch (e) {
      print(e);
    }
  };
}