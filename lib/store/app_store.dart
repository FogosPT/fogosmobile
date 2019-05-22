import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/middleware/statistics_middleware.dart';
import 'package:fogosmobile/middleware/contributors_middleware.dart';
import 'package:redux/redux.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/reducers/app_reducer.dart';
import 'package:fogosmobile/middleware/fires_middleware.dart';
import 'package:fogosmobile/middleware/preferences_middleware.dart';

final store = new Store<AppState>(
  appReducer,
  initialState: new AppState(
    fires: [],
    fire: null,
    contributors: [],
    isLoading: false,
    hasFirstLoad: false,
    hasPreferences: false,
    hasContributors: false,
    preferences: {},
    activeFilters: List.from(FireStatus.values),
  ),
  middleware: firesMiddleware()
    ..addAll(preferencesMiddleware())
    ..addAll(statisticsMiddleware())
    ..addAll(contributorsMiddleware()),
);
