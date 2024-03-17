import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/actions/lightning_actions.dart';
import 'package:fogosmobile/actions/modis_actions.dart';
import 'package:fogosmobile/actions/preferences_actions.dart';
import 'package:fogosmobile/actions/viirs_actions.dart';
import 'package:fogosmobile/constants/routes.dart';
import 'package:fogosmobile/constants/variables.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/localization/fogos_localizations_delegate.dart';
import 'package:fogosmobile/middleware/shared_preferences_manager.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/screens/about/about.dart';
import 'package:fogosmobile/screens/assets/icons.dart';
import 'package:fogosmobile/screens/components/fire_gradient_app_bar.dart';
import 'package:fogosmobile/screens/fire_details.dart';
import 'package:fogosmobile/screens/fire_list_page.dart';
import 'package:fogosmobile/screens/fires_table/fires_table_page.dart';
import 'package:fogosmobile/screens/home_page.dart';
import 'package:fogosmobile/screens/info_page.dart';
import 'package:fogosmobile/screens/partners.dart';
import 'package:fogosmobile/screens/settings/settings.dart';
import 'package:fogosmobile/screens/statistics_page.dart';
import 'package:fogosmobile/screens/warnings.dart';
import 'package:fogosmobile/screens/warnings_madeira.dart';
import 'package:fogosmobile/store/app_store.dart';
import 'package:fogosmobile/styles/theme.dart';
import 'package:logger/logger.dart';
import 'package:redux/redux.dart';
import 'package:sentry/sentry.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    if (isInDebugMode) {
      // In development mode, simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode, report to the application zone to report to
      // Sentry.
      if (details.stack != null) {
        Zone.current.handleUncaughtError(details.exception, details.stack!);
      }
    }
  };

  runZonedGuarded<Future<void>>(
    () async {
      try {
        SharedPreferencesManager.init().then((_) => runApp(MyApp()));
      } catch (error, stackTrace) {
        _reportError(error, stackTrace);
      }
    },
    (error, stack) {
      // Whenever an error occurs, call the `_reportError` function. This sends
      // Dart errors to the dev console or Sentry depending on the environment.
      _reportError(error, stack);
    },
  );
}

var logger = Logger(printer: PrettyPrinter());

var loggerNoStack = Logger(printer: PrettyPrinter(methodCount: 0));

final SentryClient _sentry = SentryClient(SentryOptions(dsn: SENTRY_DSN));

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

  final SentryId response = await _sentry.captureException(
    error,
    stackTrace: stackTrace,
  );

  print('Success! Event ID: $response');
}

typedef SetFiltersCallback = Function(FireStatus filter);

class FirstPage extends StatefulWidget {
  const FirstPage();
  @override
  _FirstPageState createState() => _FirstPageState();
}

class MyApp extends StatelessWidget {
  const MyApp();
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store, // store comes from the app_store.dart import
      child: MaterialApp(
        title: 'Fogos.pt',
        theme: FogosTheme().themeData,
        debugShowCheckedModeBanner: false,
        routes: {
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

class _FirstPageState extends State<FirstPage> with WidgetsBindingObserver {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
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
            bottom: TabBar(tabs: []),
            title: Text('Fogos.pt', style: TextStyle(color: Colors.white)),
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
                      return Row(children: [
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
              children: [
                DrawerHeader(
                  child: Center(
                    child: SvgPicture.asset(
                      imgSvgLogoFlame,
                      colorFilter:
                          ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        FogosTheme().accentColor,
                        FogosTheme().primaryColor,
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                ),
                ListTile(
                  title: Text(FogosLocalizations.of(context).textFiresTable),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(FIRES_TABLES_ROUTE);
                  },
                  leading: Icon(Icons.table_chart),
                ),
                ListTile(
                  title: Text(FogosLocalizations.of(context).textWarnings),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(WARNINGS_ROUTE);
                  },
                  leading: Icon(Icons.warning),
                ),
                ListTile(
                  title:
                      Text(FogosLocalizations.of(context).textWarningsMadeira),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(WARNINGS_MADEIRA_ROUTE);
                  },
                  leading: Icon(Icons.warning),
                ),
                ListTile(
                  title: Text(FogosLocalizations.of(context).textInformations),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(INFO_ROUTE);
                  },
                  leading: Icon(Icons.info),
                ),
                ListTile(
                  title: Text(FogosLocalizations.of(context).textStatistics),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(STATISTICS_ROUTE);
                  },
                  leading: Icon(Icons.insert_chart),
                ),
                Divider(),
                ListTile(
                  title: Text(FogosLocalizations.of(context).textNotifications),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(SETTINGS_ROUTE);
                  },
                  leading: Icon(Icons.settings),
                ),
                Divider(),
                ListTile(
                  title: Text(FogosLocalizations.of(context).textAbout),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(ABOUT_ROUTE);
                  },
                  leading: Icon(Icons.person),
                ),
                ListTile(
                  title: Text(FogosLocalizations.of(context).textPartners),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(PARTNERS_ROUTE);
                  },
                  leading: Icon(Icons.business),
                ),
              ],
            ),
          ),
          body: HomePage(),
        );
      },
    );
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
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void firebaseCloudMessagingListeners() async {
    final result = await _firebaseMessaging.requestPermission(
      sound: true,
      badge: true,
      alert: true,
    );

    if (result.authorizationStatus != AuthorizationStatus.authorized) {
      return;
    }

    _firebaseMessaging.getToken().then((token) {
      print('token: $token');
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  Widget _buildFiltersMenu(AppState state) {
    return StoreConnector<AppState, SetFiltersCallback>(
      converter: (Store<AppState> store) {
        return (FireStatus filter) {
          store.dispatch(SelectFireFiltersAction(filter));
        };
      },
      builder: (BuildContext context, SetFiltersCallback setFiltersAction) {
        return PopupMenuButton<FireStatus>(
          icon: Icon(Icons.filter_list),
          onSelected: (selectedStatus) => setFiltersAction(selectedStatus),
          itemBuilder: (BuildContext context) => FireStatus.values
              .map(
                (status) => PopupMenuItem<FireStatus>(
                  value: status,
                  child: ListTileTheme(
                    style: ListTileStyle.drawer,
                    selectedColor: Theme.of(context).colorScheme.secondary,
                    child: ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.all(0.0),
                      selected: state.activeFilters?.contains(status) ?? false,
                      trailing: state.activeFilters?.contains(status) ?? false
                          ? Icon(Icons.check)
                          : null,
                      title: Text(
                        FogosLocalizations.of(context).textFireStatus(status),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildRefreshButton(AppState state, VoidCallback action) {
    return state.isLoading ?? true
        ? Container(
            width: 48,
            height: 48,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircularProgressIndicator(strokeWidth: 2.0),
            ),
          )
        : IconButton(onPressed: action, icon: Icon(Icons.refresh));
  }
}
