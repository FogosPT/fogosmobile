import 'package:fogosmobile/middleware/modis_middleware.dart';
import 'package:fogosmobile/middleware/viirs_middleware.dart';
import 'package:fogosmobile/middleware/lightnings_middleware.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/middleware/statistics_middleware.dart';
import 'package:fogosmobile/middleware/contributors_middleware.dart';
import 'package:redux/redux.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/reducers/app_reducer.dart';
import 'package:fogosmobile/middleware/fires_middleware.dart';
import 'package:fogosmobile/middleware/preferences_middleware.dart';
import 'package:fogosmobile/middleware/warnings_middleware.dart';

final store = Store<AppState>(
  appReducer,
  initialState: AppState(
    fires: [],
    selectedFire: null,
    contributors: [],
    isLoading: false,
    hasFirstLoad: false,
    hasPreferences: false,
    hasContributors: false,
    preferences: {},
    activeFilters: List.of(FireStatus.values),
    warningsMadeira: [],
    modis: [],
    viirs: [],
    showModis: false,
    showViirs: false,
    lightnings: [],
  ),
  middleware: firesMiddleware()
    ..addAll(preferencesMiddleware())
    ..addAll(statisticsMiddleware())
    ..addAll(contributorsMiddleware())
    ..addAll(viirsMiddleware())
    ..addAll(modisMiddleware())
    ..addAll(warningsMiddleware())
    ..addAll(warningsMiddleware())
    ..addAll(lightningMiddleware()),
);
