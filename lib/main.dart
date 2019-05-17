import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fogosmobile/screens/partners.dart';
import 'package:fogosmobile/screens/info_page.dart';
import 'package:fogosmobile/screens/statistics_page.dart';
import 'package:redux/redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/actions/preferences_actions.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/screens/assets/icons.dart';
import 'package:fogosmobile/screens/home_page.dart';
import 'package:fogosmobile/screens/settings/settings.dart';
import 'package:fogosmobile/store/app_store.dart';
import 'localization/fogos_localizations.dart';
import 'actions/statistics_actions.dart';
import 'localization/fogos_localizations_delegate.dart';
import 'middleware/shared_preferences_manager.dart';
import 'screens/components/fire_gradient_app_bar.dart';
import 'package:fogosmobile/screens/warnings.dart';
import 'models/fire.dart';

typedef SetFiltersCallback = Function(FireStatus filter);

void main() => SharedPreferencesManager.init().then((_) => runApp(new MyApp()));

const SETTINGS_ROUTE = '/settings';
const WARNINGS_ROUTE = '/warnings';
const PARTNERS_ROUTE = '/partners';
const INFO_ROUTE = '/info';
const STATISTICS_ROUTE = "/statistics";

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
          '$WARNINGS_ROUTE': (_) => new Warnings(),
          '$PARTNERS_ROUTE': (_) => new Partners(),
          '$INFO_ROUTE': (_) => new InfoPage(),
          '$STATISTICS_ROUTE': (_) => new StatisticsPage(),
        },
        home: FirstPage(),
        localizationsDelegates: [
          const FogosLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('pt', 'PT'),
          const Locale('en', 'US'),
          // ... other locales the app supports
        ],
      ),
    );
  }
}

class FirstPage extends StatelessWidget {
  Widget _buildRefreshButton(AppState state, VoidCallback action) =>
      state.isLoading
          ? Container(
              width: 54.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: new CircularProgressIndicator(
                  strokeWidth: 2.0,
                ),
              ),
            )
          : new IconButton(
              onPressed: action,
              icon: new Icon(Icons.refresh),
            );

  Widget _buildFiltersMenu(AppState state) =>
      StoreConnector<AppState, SetFiltersCallback>(
          converter: (Store<AppState> store) {
        return (FireStatus filter) {
          store.dispatch(SelectFireFiltersAction(filter));
        };
      }, builder: (BuildContext context, SetFiltersCallback setFiltersAction) {
        return PopupMenuButton<FireStatus>(
          icon: Icon(Icons.filter_list),
          onSelected: (selectedStatus) => setFiltersAction(selectedStatus),
          itemBuilder: (BuildContext context) => FireStatus.values
              .map((status) => PopupMenuItem<FireStatus>(
                  value: status,
                  child: ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.all(0.0),
                      selected: state.activeFilters.contains(status),
                      trailing: state.activeFilters.contains(status)
                          ? Icon(Icons.check)
                          : null,
                      title: Text(
                        FogosLocalizations.of(context).textFireStatus(status),
                      ))))
              .toList(),
        );
      });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
            label: "Fogos.pt", primaryColor: Colors.black.value));

    return new StoreConnector<AppState, AppState>(
      converter: (Store<AppState> store) => store.state,
      builder: (BuildContext context, AppState state) {
        return Scaffold(
          appBar: new FireGradientAppBar(
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
                    store.dispatch(new LoadNowStatsAction());
                    store.dispatch(new LoadTodayStatsAction());
                    store.dispatch(new LoadYesterdayStatsAction());
                    store.dispatch(new LoadLastNightStatsAction());
                    store.dispatch(new LoadWeekStatsAction());
                    store.dispatch(new LoadLastHoursAction());
                  };
                },
                builder: (BuildContext context, VoidCallback loadFiresAction) {
                  return new StoreConnector<AppState, AppState>(
                    converter: (Store<AppState> store) => store.state,
                    builder: (BuildContext context, AppState state) {
                      if ((state.hasFirstLoad == false ||
                              state.hasFirstLoad == null) &&
                          (state.isLoading == false ||
                              state.isLoading == null) &&
                          state.fires.length == 0) {
                        loadFiresAction();
                      }
                      return Row(children: <Widget>[
                        _buildRefreshButton(state, loadFiresAction),
                        _buildFiltersMenu(state),
                      ]);
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
                    child: SvgPicture.asset(imgSvgLogoFlame,
                        color: Colors.redAccent),
                  ),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                  ),
                ),
                new ListTile(
                  title: new Text('Avisos'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(WARNINGS_ROUTE);
                  },
                  leading: Icon(Icons.warning),
                ),
                new Divider(),
                new ListTile(
                  title: new Text('Informações'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(INFO_ROUTE);
                  },
                  leading: Icon(Icons.info),
                ),
                new Divider(),
                new ListTile(
                  title: new Text('Estatísticas'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(STATISTICS_ROUTE);
                  },
                  leading: Icon(Icons.graphic_eq),
                ),
                new Divider(),
                new ListTile(
                  title: new Text("Parcerias"),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(PARTNERS_ROUTE);
                  },
                  leading: Icon(Icons.business),
                ),
                new Divider(),
                new ListTile(
                  title: new Text('Notificações'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(SETTINGS_ROUTE);
                  },
                  leading: Icon(Icons.settings),
                ),
              ],
            ),
          ),
          body: new HomePage(),
        );
      },
    );
  }
}
