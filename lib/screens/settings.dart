import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:convert' show utf8;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:fogosmobile/constants/endpoints.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/actions/preferences_actions.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  List locations = [];

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iOSPermission();

    _firebaseMessaging.getToken().then((token) {});
  }

  void iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {});
  }

  getLocations() async {
    String url = endpoints['getLocations'];
    final response = await http.get(url);
    final data = json.decode(utf8.decode(response.bodyBytes));
    return data['rows'];
  }

  _changeSetting(String key, bool newState) {}

  @override
  Widget build(BuildContext context) {
    firebaseCloudMessagingListeners();

    if (this.locations.length == 0) {
      getLocations().then((locs) {
        setState(() {
          this.locations = locs;
        });
      });

      return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.redAccent,
          iconTheme: new IconThemeData(color: Colors.white),
          title: new Text(
            'Fogos.pt',
            style: new TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.redAccent,
        iconTheme: new IconThemeData(color: Colors.white),
        title: new Text(
          'Fogos.pt',
          style: new TextStyle(color: Colors.white),
        ),
      ),
      body: new StoreConnector<AppState, AppState>(
        converter: (Store<AppState> store) => store.state,
        onInit: (store) {
          store.dispatch(LoadAllPreferencesAction());
        },
        builder: (BuildContext context, AppState state) {
          if (!state.hasPreferences && !state.isLoading) {
            return new Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: this.locations.length,
            itemBuilder: (BuildContext context, int index) {
              final _location = this.locations[index];
              return CheckboxListTile(
                title: Text(_location['value']['name']),
                value: true,
                onChanged: (bool changed) {
                  _changeSetting(_location['key'], changed);
                },
              );
            },
          );
        },
      ),
    );
  }
}
