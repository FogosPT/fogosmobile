import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/actions/preferences_actions.dart';
import 'package:fogosmobile/constants/endpoints.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/utils/network_utils.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Text(FogosLocalizations.of(context).textNotificationProblems),
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
                child:
                    Text(FogosLocalizations.of(context).textResetNotifications),
                onPressed: () {
                  _resetFirebaseNotifications();
                },
              ),
          ],
        ),
      ),
    );
  }

  getLocations() async {
    String url = Endpoints.getLocations;
    final response = await get(url);
    return response.data['rows'];
  }

  void iOSPermission() {
    _firebaseMessaging.requestPermission(sound: true, badge: true, alert: true);
  }

  void _resetFirebaseNotifications() async {
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

    _firebaseMessaging.deleteToken().then((value) {
      _firebaseMessaging.getToken().then((value) {
        print("token $value");
        setState(() {
          isLoading = false;
          isSuccess = true;
        });

        for (var _location in _locations) {
          String key = _location['key'];
          int value = state.preferences?['pref-$key'];
          bool isLocationTurnedOn = value != 0;

          if (isLocationTurnedOn) {
            store.dispatch(SetPreferenceAction(key, value));
          }
        }
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
        isSuccess = false;
      });
    });
  }
}
