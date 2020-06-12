import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

typedef SetPreferenceCallBack = Function(String key, int value);

class ResetNotifications extends StatefulWidget {
  @override
  _ResetNotificationsState createState() => _ResetNotificationsState();
}

class _ResetNotificationsState extends State<ResetNotifications> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool isLoading = false;
  bool isSuccess = false;
  bool hasRequestRun = false;

  void iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {});
  }

  void _resetFirebaseNotifications() {
    setState(() {
      hasRequestRun = true;
      isLoading = true;
    });

    if (Platform.isIOS) {
      iOSPermission();
    }

    _firebaseMessaging.deleteInstanceID().then((value) {
      _firebaseMessaging.getToken().then((value) {
        print("token $value");
        setState(() {
          isLoading = false;
          isSuccess = true;
        });
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
        isSuccess = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: new ListView(
          children: <Widget>[
            Text(
                'Se está com problemas em receber notificações, clique no botão abaixo.'),
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
                child: Text('Reset notifications'),
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
