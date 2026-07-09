import 'dart:io';

import 'package:fogosmobile/middleware/shared_preferences_manager.dart';
import 'package:fogosmobile/utils/network_utils.dart';
import 'package:redux/redux.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/actions/preferences_actions.dart';
import 'package:fogosmobile/constants/endpoints.dart';
import 'package:fogosmobile/services/watch_bridge_service.dart';

const String preferenceSatellite = "pref-satellite";

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
      String url = Endpoints.getLocations;
      final response = await get(url);
      final locations = response!.data['rows'];

      Map data = {};
      final prefs = SharedPreferencesManager.preferences;

      for (Map location in locations) {
        data['pref-${location['key']}'] = prefs.getInt(location['key']) ?? 0;
        // Also load "all incidents" preference for each concelho
        data['pref-all-${location['key']}'] = prefs.getInt('all-${location['key']}') ?? 0;
      }

      List<String> subbedFires = prefs.getStringList('subscribedFires') ?? [];
      List<Fire> allKnownIncidents = [
        ...store.state.fires,
        ...store.state.otherFires,
      ];

      if (allKnownIncidents.length > 0) {
        data['subscribedFires'] =
            allKnownIncidents.where((f) => subbedFires.contains(f.id)).toList();
      } else {
        data['subscribedFires'] = [];
      }

      data['pref-important'] = prefs.getInt('important') ?? 0;
      data['pref-warnings'] = prefs.getInt('warnings') ?? 0;
      data['pref-satellite'] = prefs.getInt('satellite') ?? 0;
      data['pref-planes'] = prefs.getInt('planes') ?? 0;

      store.dispatch(AllPreferencesLoadedAction(data));
    } catch (e) {
      print(e);
    }
  };
}

/// Map a preference key to its unified FCM topic name.
/// Must match the topics used by fogosapi NotificationTool.
String _unifiedTopic(String key) {
  // "all incidents" subscriptions: "all-010100" → "district-all-010100"
  if (key.startsWith('all-') && RegExp(r'^\d{6}$').hasMatch(key.substring(4))) {
    return 'district-$key';
  }
  // Numeric DICO codes (e.g. "010100") → "district-010100"
  if (RegExp(r'^\d{6}$').hasMatch(key)) {
    return 'district-$key';
  }
  // "important" → "incident-important" (matches buildImportantTopic)
  if (key == 'important') {
    return 'incident-important';
  }
  // "warnings", "planes", etc. → same name (matches buildWarningsTopic / buildPlanesTopic)
  return key;
}

Middleware<AppState> _createSetPreference() {
  return (Store store, action, NextDispatcher next) async {
    next(action);
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    // Unified topic (new) — matches fogosapi NotificationTool
    String unifiedTopic = _unifiedTopic(action.key);
    // Legacy topic (platform-specific)
    String legacyTopic = Platform.isIOS
        ? 'mobile-ios-${action.key}'
        : 'mobile-android-${action.key}';

    if (action.value == 1) {
      _firebaseMessaging.subscribeToTopic(unifiedTopic);
      _firebaseMessaging.subscribeToTopic(legacyTopic);
    } else {
      _firebaseMessaging.unsubscribeFromTopic(unifiedTopic);
      _firebaseMessaging.unsubscribeFromTopic(legacyTopic);
    }

    try {
      final prefs = SharedPreferencesManager.preferences;
      prefs.save(action.key, action.value);
    } catch (e) {}
  };
}

Middleware<AppState> _createSetNotification() {
  return (Store store, action, NextDispatcher next) async {
    next(action);
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    // Unified topic (new) — "incident-<id>"
    String unifiedTopic = 'incident-${action.key}';
    // Legacy topic (platform-specific)
    String legacyTopic = Platform.isIOS
        ? 'mobile-ios-${action.key}'
        : 'mobile-android-${action.key}';

    try {
      final prefs = SharedPreferencesManager.preferences;
      List<String> subscribedFires =
          prefs.getStringList('subscribedFires') ?? [];
      if (action.value == 1 && subscribedFires.contains(action.key) == false) {
        subscribedFires.add(action.key);
        _firebaseMessaging.subscribeToTopic(unifiedTopic);
        _firebaseMessaging.subscribeToTopic(legacyTopic);
      } else {
        subscribedFires.remove(action.key);
        _firebaseMessaging.unsubscribeFromTopic(unifiedTopic);
        _firebaseMessaging.unsubscribeFromTopic(legacyTopic);
      }
      prefs.save('subscribedFires', subscribedFires);
      await WatchBridgeService.sendSubscribedFires(subscribedFires);
      store.dispatch(LoadAllPreferencesAction());
    } catch (e) {
      print(e);
    }
  };
}
