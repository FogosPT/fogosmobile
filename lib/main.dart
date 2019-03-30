import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:fogosmobile/styles/theme.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/store/app_store.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/screens/home_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iOSPermission();

    _firebaseMessaging.getToken().then((token) {
      print('token');
      print(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {});
  }

  @override
  Widget build(BuildContext context) {
    firebaseCloudMessagingListeners();

    return new StoreProvider(
      store: store, // store comes from the app_store.dart import
      child: MaterialApp(
        title: 'Fogos.pt',
        debugShowCheckedModeBanner: false,
        home: new Scaffold(
          appBar: new AppBar(
            backgroundColor: Colors.redAccent,
            iconTheme: new IconThemeData(color: Colors.white),
            title: new Text(
              'Fogos.pt',
              style: new TextStyle(color: Colors.white),
            ),
            actions: [
              new IconButton(
                icon: Icon(
                  Icons.settings,
                ),
                onPressed: () {},
              ),
              new StoreConnector<AppState, VoidCallback>(
                converter: (Store<AppState> store) {
                  return () {
                    store.dispatch(new LoadFiresAction());
                  };
                },
                builder: (BuildContext context, VoidCallback loadFiresAction) {
                  return new StoreConnector<AppState, AppState>(
                    converter: (Store<AppState> store) => store.state,
                    builder: (BuildContext context, AppState state) {
                      print(state);
                      if ((state.hasFirstLoad == false ||
                              state.hasFirstLoad == null) &&
                          (state.isLoading == false ||
                              state.isLoading == null)) {
                        loadFiresAction();
                      }

                      if (state.isLoading) {
                        return Container(
                          width: 54.0,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: new CircularProgressIndicator(
                              strokeWidth: 2.0,
                            ),
                          ),
                        );
                      } else {
                        return new IconButton(
                          onPressed: loadFiresAction,
                          icon: new Icon(Icons.refresh),
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
          body: new HomePage(),
        ),
      ),
    );
  }
}
