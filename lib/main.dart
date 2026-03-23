import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:fogosmobile/actions/modis_actions.dart';
import 'package:fogosmobile/actions/viirs_actions.dart';
import 'package:fogosmobile/screens/fires_table/fires_table_page.dart';
import 'package:fogosmobile/actions/lightning_actions.dart';
import 'package:fogosmobile/services/nearby_notification_service.dart';
import 'package:fogosmobile/services/fcm_migration_service.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
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
import 'package:fogosmobile/screens/settings/settings.dart' as app_settings;
import 'package:fogosmobile/store/app_store.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/localization/fogos_localizations_delegate.dart';
import 'package:fogosmobile/middleware/shared_preferences_manager.dart';
import 'package:fogosmobile/screens/components/fire_gradient_app_bar.dart';
import 'package:fogosmobile/screens/fire_details.dart';
import 'package:fogosmobile/screens/components/fire_details.dart';
import 'package:fogosmobile/screens/warnings.dart';
import 'package:fogosmobile/screens/fire_list_page.dart';
import 'package:fogosmobile/screens/other_fires_page.dart';
import 'package:fogosmobile/screens/all_incidents_page.dart';
import 'package:fogosmobile/screens/search_page.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/screens/warnings_madeira.dart';
import 'package:logger/logger.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

typedef SetFiltersCallback = Function(FireStatus filter);

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

var logger = Logger(
  printer: PrettyPrinter(),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

/// Top-level background message handler.
/// Must be a top-level function (not a class method).
@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await NearbyNotificationService.init();
  await NearbyNotificationService.handleMessage(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MapboxOptions.setAccessToken(MAPBOX_ACCESS_TOKEN);

  // Register background handler before runApp
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  await SentryFlutter.init(
    (options) {
      options.dsn = SENTRY_DSN;
      options.tracesSampleRate = isInDebugMode ? 0.0 : 1.0;
    },
    appRunner: () async {
      await SharedPreferencesManager.init();
      await NearbyNotificationService.init();
      runApp(MyApp());
    },
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'Fogos.pt',
        theme: FogosTheme().themeData,
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          SETTINGS_ROUTE: (_) => app_settings.Settings(),
          WARNINGS_ROUTE: (_) => Warnings(),
          WARNINGS_MADEIRA_ROUTE: (_) => WarningsMadeira(),
          PARTNERS_ROUTE: (_) => Partners(),
          STATISTICS_ROUTE: (_) => StatisticsPage(),
          INFO_ROUTE: (_) => InfoPage(),
          ABOUT_ROUTE: (_) => About(),
          FIRE_DETAILS_ROUTE: (_) => FireDetailsPage(),
          FIRES_ROUTE: (_) => FireList(),
          FIRES_TABLES_ROUTE: (_) => FiresTablePage(),
          OTHER_FIRES_ROUTE: (_) => OtherFiresPage(),
          ALL_INCIDENTS_ROUTE: (_) => AllIncidentsPage(),
          SEARCH_ROUTE: (_) => SearchPage(),
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

  void _setupFirebaseMessaging() async {
    final result = await _firebaseMessaging.requestPermission(sound: true, badge: true, alert: true);

    if (result.authorizationStatus != AuthorizationStatus.authorized) {
      return;
    }

    // Subscribe all users to the agif topic
    await _firebaseMessaging.subscribeToTopic('agif');

    // Migrate FCM subscriptions on upgrade (clears stale legacy topics)
    await FcmMigrationService.migrateIfNeeded(_firebaseMessaging);

    _firebaseMessaging.getToken().then((token) {
      print('token: $token');
    });

    // Handle notification that launched the app (cold start)
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }

    // Handle notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Handle foreground messages (including nearby data messages)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Firebase onMessage ${message.data}');
      // Process nearby proximity check in foreground too
      NearbyNotificationService.handleMessage(message);
    });

    // Update stored location for nearby feature
    NearbyNotificationService.updateStoredLocation();

    // Handle taps on nearby local notifications
    // Payload format: "fire:<id>" or "other:<id>"
    NearbyNotificationService.onNotificationTap = (payload) {
      if (payload.isNotEmpty && mounted) {
        final isOther = payload.startsWith('other:');
        final fireId = payload.contains(':') ? payload.split(':').last : payload;
        if (fireId.isEmpty) return;

        final store = StoreProvider.of<AppState>(context);
        store.dispatch(ClearFireAction());
        store.dispatch(LoadFireAction(fireId));

        if (isOther) {
          Navigator.of(context).pushNamed(OTHER_FIRES_ROUTE);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _openFireModal(context);
          });
        } else {
          _openFireModal(context);
        }
      }
    };
  }

  void _handleNotificationTap(RemoteMessage message) {
    final fireId = message.data['fireId'];
    if (fireId != null && fireId is String && fireId.isNotEmpty) {
      final store = StoreProvider.of<AppState>(context);
      store.dispatch(ClearFireAction());
      store.dispatch(LoadFireAction(fireId));

      final isFire = message.data['isFire'];
      if (isFire == '0') {
        Navigator.of(context).pushNamed(OTHER_FIRES_ROUTE);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _openFireModal(context);
        });
      } else {
        _openFireModal(context);
      }
    }
  }

  void _openFireModal(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => FireDetails(),
    );
  }

  Widget _buildRefreshButton(AppState state, VoidCallback action) {
    return state.isLoading
        ? SizedBox(
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
                  selectedColor: Theme.of(context).colorScheme.secondary,
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
    _setupFirebaseMessaging();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh stored location first — independent of store
      NearbyNotificationService.updateStoredLocation();

      if (!mounted) return;

      try {
        final store = StoreProvider.of<AppState>(context);
        store.dispatch(LoadFiresAction());
        store.dispatch(LoadModisAction());
        store.dispatch(LoadViirsAction());
        store.dispatch(LoadLightningsAction());
      } catch (e) {
        print('didChangeAppLifecycleState: failed to dispatch actions: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        SvgPicture.asset(imgSvgLogoFlame, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
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
                        tileMode: TileMode.clamp),
                  ),
                ),
                ListTile(
                  title:
                      Text(FogosLocalizations.of(context).textFiresTable),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(FIRES_TABLES_ROUTE);
                  },
                  leading: Icon(Icons.table_chart),
                ),
                ListTile(
                  title: Text(FogosLocalizations.of(context).textSearch),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(SEARCH_ROUTE);
                  },
                  leading: Icon(Icons.search),
                ),
                ListTile(
                  title: Text(FogosLocalizations.of(context).textAllIncidents),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(ALL_INCIDENTS_ROUTE);
                  },
                  leading: Icon(Icons.list_alt),
                ),
                ListTile(
                  title: Text(FogosLocalizations.of(context).textOtherFires),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(OTHER_FIRES_ROUTE);
                  },
                  leading: Icon(Icons.local_fire_department),
                ),
                ListTile(
                  title: Text(FogosLocalizations.of(context).textWarnings),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(WARNINGS_ROUTE);
                  },
                  leading: Icon(Icons.warning),
                ),
                // ListTile(
                //   title:
                //       Text(
                //       FogosLocalizations.of(context).textWarningsMadeira),
                //   onTap: () {
                //     Navigator.of(context).pop();
                //     Navigator.of(context).pushNamed(WARNINGS_MADEIRA_ROUTE);
                //   },
                //   leading: Icon(Icons.warning),
                // ),
                ListTile(
                  title:
                      Text(FogosLocalizations.of(context).textInformations),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(INFO_ROUTE);
                  },
                  leading: Icon(Icons.info),
                ),
                ListTile(
                  title:
                      Text(FogosLocalizations.of(context).textStatistics),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(STATISTICS_ROUTE);
                  },
                  leading: Icon(Icons.insert_chart),
                ),
                Divider(),
                ListTile(
                  title: Text(
                      FogosLocalizations.of(context).textNotifications),
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
}
