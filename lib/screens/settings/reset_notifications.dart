import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/actions/preferences_actions.dart';
import 'package:fogosmobile/constants/endpoints.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/screens/settings/notification_diagnostics.dart';
import 'package:fogosmobile/services/nearby_notification_service.dart';
import 'package:fogosmobile/services/push_registry.dart';
import 'package:fogosmobile/utils/network_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef SetPreferenceCallBack = Function(String key, int value);

class ResetNotifications extends StatefulWidget {
  @override
  _ResetNotificationsState createState() => _ResetNotificationsState();
}

class _ResetNotificationsState extends State<ResetNotifications> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool isLoading = false;
  bool isSuccess = false;
  bool hasRequestRun = false;

  getLocations() async {
    String url = Endpoints.getLocations;
    final response = await get(url);
    return response!.data['rows'];
  }

  void iOSPermission() {
    _firebaseMessaging.requestPermission(sound: true, badge: true, alert: true);
  }

  Future<void> _resetFirebaseNotifications() async {
    final store = StoreProvider.of<AppState>(context);
    AppState state = store.state;
    final _locations = await getLocations();

    setState(() {
      hasRequestRun = true;
      isLoading = true;
    });

    if (Platform.isIOS) {
      iOSPermission();
    }

    try {
      await _firebaseMessaging.deleteToken();
      final newToken = await _firebaseMessaging.getToken();
      print("token $newToken");

      // Re-subscribe district topics (fires only)
      for (var _location in _locations) {
        String key = _location['key'];
        num value = state.preferences['pref-$key'] ?? 0;
        if (value != 0) {
          store.dispatch(SetPreferenceAction(key, value.toInt()));
        }
      }

      // Re-subscribe district topics (all incidents)
      final prefs = await SharedPreferences.getInstance();
      for (var _location in _locations) {
        String allKey = 'all-${_location['key']}';
        int allValue = prefs.getInt(allKey) ?? 0;
        if (allValue != 0) {
          store.dispatch(SetPreferenceAction(allKey, allValue));
        }
      }

      // Re-subscribe other notification types
      for (var prefKey in ['important', 'warnings', 'planes']) {
        num value = state.preferences['pref-$prefKey'] ?? 0;
        if (value != 0) {
          store.dispatch(SetPreferenceAction(prefKey, value.toInt()));
        }
      }

      // Re-subscribe nearby topic if enabled
      final nearbyEnabled = prefs.getBool(NearbyPrefs.nearbyEnabled) ?? false;
      if (nearbyEnabled) {
        await PushRegistry.subscribe('incident-nearby');
      }

      setState(() {
        isLoading = false;
        isSuccess = true;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        isSuccess = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            const NotificationDiagnostics(),
            const Divider(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(FogosLocalizations.of(context).textNotificationProblems),
            ),
            if (isLoading)
              Center(
                  child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: CircularProgressIndicator(),
              ))
            else if (hasRequestRun)
              isSuccess
                  ? Center(
                      child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Icon(Icons.check),
                    ))
                  : Center(
                      child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Icon(Icons.error),
                    ))
            else
              MaterialButton(
                textTheme: ButtonTextTheme.normal,
                child: Text(FogosLocalizations.of(context).textResetNotifications),
                onPressed: () {
                  _resetFirebaseNotifications();
                },
              ),
          ],
        ),
      ),
    );
  }
}
