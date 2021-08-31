import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:fogosmobile/actions/modis_actions.dart';
import 'package:fogosmobile/actions/viirs_actions.dart';
import 'package:fogosmobile/screens/fires_table/fires_table_page.dart';
import 'package:fogosmobile/actions/lightning_actions.dart';
import 'package:sentry/sentry.dart';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fogosmobile/constants/routes.dart';
import 'package:fogosmobile/constants/variables.dart';
import 'package:fogosmobile/screens/about/about.dart';
import 'package:fogosmobile/screens/partners.dart';
import 'package:fogosmobile/screens/info_page.dart';
import 'package:fogosmobile/screens/statistics_page.dart';
import 'package:fogosmobile/styles/theme.dart';
import 'package:redux/redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/actions/preferences_actions.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/screens/assets/icons.dart';
import 'package:fogosmobile/screens/home_page.dart';
import 'package:fogosmobile/screens/settings/settings.dart';
import 'package:fogosmobile/store/app_store.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/localization/fogos_localizations_delegate.dart';
import 'package:fogosmobile/middleware/shared_preferences_manager.dart';
import 'package:fogosmobile/screens/components/fire_gradient_app_bar.dart';
import 'package:fogosmobile/screens/fire_details.dart';
import 'package:fogosmobile/screens/warnings.dart';
import 'package:fogosmobile/screens/fire_list_page.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/screens/warnings_madeira.dart';
import 'package:logger/logger.dart';

final SentryClient _sentry = SentryClient(dsn: SENTRY_DSN);

typedef SetFiltersCallback = Function(FireStatus filter);

bool get isInDebugMode {
  // Assume you're in production mode
  bool inDebugMode = false;

  // Assert expressions are only evaluated during development. They are ignored
  // in production. Therefore, this code only sets `inDebugMode` to true
  // in a development environment.
  assert(inDebugMode = true);

  return inDebugMode;
}

Future<Null> _reportError(dynamic error, dynamic stackTrace) async {
  print('Caught error: $error');

  // Errors thrown in development mode are unlikely to be interesting. You can
  // check if you are running in dev mode using an assertion and omit sending
  // the report.
  if (isInDebugMode) {
    print(stackTrace);
    print('In dev mode. Not sending report to Sentry.io.');
    return;
  }

  print('Reporting to Sentry.io...');

  final SentryResponse response = await _sentry.captureException(
    exception: error,
    stackTrace: stackTrace,
  );

  if (response.isSuccessful) {
    print('Success! Event ID: ${response.eventId}');
  } else {
    print('Failed to report to Sentry.io: ${response.error}');
  }
}

var logger = Logger(
  printer: PrettyPrinter(),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    if (isInDebugMode) {
      // In development mode, simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode, report to the application zone to report to
      // Sentry.
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  runZoned<Future<void>>(() async {
    try {
      SharedPreferencesManager.init().then((_) => runApp(MyApp()));
    } catch (error, stackTrace) {
      _reportError(error, stackTrace);
    }
  }, onError: (error, stackTrace) {
    // Whenever an error occurs, call the `_reportError` function. This sends
    // Dart errors to the dev console or Sentry depending on the environment.
    _reportError(error, stackTrace);
  });

  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store, // store comes from the app_store.dart import
      child: MaterialApp(
        title: 'Fogos.pt',
        theme: FogosTheme().themeData,
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          SETTINGS_ROUTE: (_) => Settings(),
          WARNINGS_ROUTE: (_) => Warnings(),
          WARNINGS_MADEIRA_ROUTE: (_) => WarningsMadeira(),
          PARTNERS_ROUTE: (_) => Partners(),
          STATISTICS_ROUTE: (_) => StatisticsPage(),
          INFO_ROUTE: (_) => InfoPage(),
          ABOUT_ROUTE: (_) => About(),
          FIRE_DETAILS_ROUTE: (_) => FireDetailsPage(),
          FIRES_ROUTE: (_) => FireList(),
          FIRES_TABLES_ROUTE: (_) => FiresTablePage(),
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

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> with WidgetsBindingObserver {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iOSPermission();

    _firebaseMessaging.getToken().then((token) {
      print('token: $token');
    });
  }

  void iOSPermission() {
    _firebaseMessaging.requestPermission(sound: true, badge: true, alert: true);
  }

  Widget _buildRefreshButton(AppState state, VoidCallback action) {
    return state.isLoading
        ? Container(
            width: 48,
            height: 48,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            ),
          )
        : IconButton(
            onPressed: action,
            icon: Icon(Icons.refresh),
          );
  }

  Widget _buildFiltersMenu(AppState state) {
    return StoreConnector<AppState, SetFiltersCallback>(
        converter: (Store<AppState> store) {
      return (FireStatus filter) {
        store.dispatch(SelectFireFiltersAction(filter));
      };
    }, builder: (BuildContext context, SetFiltersCallback setFiltersAction) {
      return PopupMenuButton<FireStatus>(
        icon: Icon(Icons.filter_list),
        onSelected: (selectedStatus) => setFiltersAction(selectedStatus),
        itemBuilder: (BuildContext context) => FireStatus.values
            .map(
              (status) => PopupMenuItem<FireStatus>(
                value: status,
                child: ListTileTheme(
                  style: ListTileStyle.drawer,
                  selectedColor: Theme.of(context).accentColor,
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.all(0.0),
                    selected: state.activeFilters.contains(status),
                    trailing: state.activeFilters.contains(status)
                        ? Icon(Icons.check)
                        : null,
                    title: Text(
                        FogosLocalizations.of(context).textFireStatus(status)),
                  ),
                ),
              ),
            )
            .toList(),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final store = StoreProvider.of<AppState>(context);
      store.dispatch(LoadFiresAction());
      store.dispatch(LoadModisAction());
      store.dispatch(LoadViirsAction());
      store.dispatch(LoadLightningsAction());
    }
  }

  @override
  Widget build(BuildContext context) {
    firebaseCloudMessagingListeners();

    SystemChrome.setApplicationSwitcherDescription(
      ApplicationSwitcherDescription(
        label: "Fogos.pt",
        primaryColor: Colors.black.value,
      ),
    );

    return StoreConnector<AppState, AppState>(
      converter: (Store<AppState> store) => store.state,
      onInit: (Store<AppState> store) {
        store.dispatch(LoadFiresAction());
        store.dispatch(LoadLightningsAction());
        store.dispatch(LoadModisAction());
        store.dispatch(LoadViirsAction());
        store.dispatch(LoadAllPreferencesAction());
      },
      builder: (BuildContext context, AppState state) {
        return Scaffold(
          appBar: FireGradientAppBar(
            title: Text(
              'Fogos.pt',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              StoreConnector<AppState, VoidCallback>(
                converter: (Store<AppState> store) {
                  return () {
                    store.dispatch(LoadFiresAction());
                    store.dispatch(LoadLightningsAction());
                    store.dispatch(LoadModisAction());
                    store.dispatch(LoadViirsAction());
                    store.dispatch(LoadAllPreferencesAction());
                  };
                },
                builder: (BuildContext context, VoidCallback loadFiresAction) {
                  return StoreConnector<AppState, AppState>(
                    converter: (Store<AppState> store) => store.state,
                    onInit: (Store<AppState> store) {
                      store.dispatch(LoadFiresAction());
                      store.dispatch(LoadModisAction());
                      store.dispatch(LoadViirsAction());
                    },
                    builder: (BuildContext context, AppState state) {
                      return Row(children: <Widget>[
                        _buildFiltersMenu(state),
                        _buildRefreshButton(state, loadFiresAction),
                      ]);
                    },
                  );
                },
              ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Center(
                    child:
                        SvgPicture.asset(imgSvgLogoFlame, color: Colors.white),
                  ),
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          FogosTheme().accentColor,
                          FogosTheme().primaryColor,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                ),
                new ListTile(
                  title: new Text(FogosLocalizations.of(context).textFiresList),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(FIRES_ROUTE);
                  },
                  leading: Icon(Icons.list),
                ),
                new ListTile(
                  title:
                      new Text(FogosLocalizations.of(context).textFiresTable),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(FIRES_TABLES_ROUTE);
                  },
                  leading: Icon(Icons.table_chart),
                ),
                new ListTile(
                  title: new Text(FogosLocalizations.of(context).textWarnings),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(WARNINGS_ROUTE);
                  },
                  leading: Icon(Icons.warning),
                ),
                new ListTile(
                  title: new Text(
                      FogosLocalizations.of(context).textWarningsMadeira),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(WARNINGS_MADEIRA_ROUTE);
                  },
                  leading: Icon(Icons.warning),
                ),
                new ListTile(
                  title:
                      new Text(FogosLocalizations.of(context).textInformations),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(INFO_ROUTE);
                  },
                  leading: Icon(Icons.info),
                ),
                new ListTile(
                  title:
                      new Text(FogosLocalizations.of(context).textStatistics),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(STATISTICS_ROUTE);
                  },
                  leading: Icon(Icons.insert_chart),
                ),
                new Divider(),
                new ListTile(
                  title: new Text(
                      FogosLocalizations.of(context).textNotifications),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(SETTINGS_ROUTE);
                  },
                  leading: Icon(Icons.settings),
                ),
                new Divider(),
                new ListTile(
                  title: new Text(FogosLocalizations.of(context).textAbout),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(ABOUT_ROUTE);
                  },
                  leading: Icon(Icons.person),
                ),
                new ListTile(
                  title: new Text(FogosLocalizations.of(context).textPartners),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(PARTNERS_ROUTE);
                  },
                  leading: Icon(Icons.business),
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
