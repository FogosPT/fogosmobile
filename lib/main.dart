import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fogosmobile/screens/assets/icons.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/actions/preferences_actions.dart';
import 'package:fogosmobile/store/app_store.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/screens/home_page.dart';
import 'package:fogosmobile/screens/settings/settings.dart';

void main() => runApp(new MyApp());

const SETTINGS_ROUTE = '/settings';

class MyApp extends StatelessWidget {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iOSPermission();

    _firebaseMessaging.getToken().then((token) {
      print('token: $token');
    });
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
          routes: <String, WidgetBuilder>{
            '$SETTINGS_ROUTE': (_) => new Settings(),
          },
          home: FirstPage()),
    );
  }
}

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.redAccent,
        iconTheme: new IconThemeData(color: Colors.white),
        title: new Text(
          'Fogos.pt',
          style: new TextStyle(color: Colors.white),
        ),
        actions: [
          new StoreConnector<AppState, VoidCallback>(
            converter: (Store<AppState> store) {
              return () {
                store.dispatch(new LoadFiresAction());
                store.dispatch(new LoadAllPreferencesAction());
              };
            },
            builder: (BuildContext context, VoidCallback loadFiresAction) {
              return new StoreConnector<AppState, AppState>(
                converter: (Store<AppState> store) => store.state,
                builder: (BuildContext context, AppState state) {
                  if ((state.hasFirstLoad == false ||
                          state.hasFirstLoad == null) &&
                      (state.isLoading == false || state.isLoading == null) &&
                      state.fires.length == 0) {
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
      drawer: new Drawer(
        child: new ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            new DrawerHeader(
              child: new Center(
                child: SvgPicture.asset(imgSvgLogoFlame, color: Colors.redAccent),
              ),
              decoration: new BoxDecoration(
                color: Colors.white,
              ),
            ),
            new ListTile(
              title: new Text('Notificações'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(SETTINGS_ROUTE);
              },
              leading: Icon(Icons.settings),
            ),
            new Divider(),
          ],
        ),
      ),
      body: new HomePage(),
    );
  }
}
