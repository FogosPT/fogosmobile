import 'package:redux/redux.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/reducers/app_reducer.dart';
import 'package:fogosmobile/middleware/fires_middleware.dart';
import 'package:fogosmobile/middleware/preferences_middleware.dart';

final store = new Store<AppState>(
  appReducer,
  initialState: new AppState(
    fires: [],
    isLoading: false,
    hasFirstLoad: false,
    hasPreferences: false,
    preferences: {},
    activeFilters: []
  ),
  middleware: firesMiddleware()..addAll(preferencesMiddleware()),
);
