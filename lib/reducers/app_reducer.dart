import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/reducers/fires_reducer.dart';
import 'package:fogosmobile/reducers/preferences_reducer.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/actions/preferences_actions.dart';

AppState appReducer(AppState state, action) {
  bool isLoading;
  bool hasFirstLoad;
  bool hasPreferences;

  // print('action is action $action');

  if (action is LoadFiresAction) {
    isLoading = true;
  } else if (action is FiresLoadedAction) {
    isLoading = false;
    hasFirstLoad = true;
  } else if (action is LoadFireAction) {
    isLoading = true;
  } else if (action is FireLoadedAction) {
    isLoading = false;
    hasFirstLoad = true;
  } else if (action is LoadAllPreferencesAction) {
    hasPreferences = false;
    isLoading = true;
  } else if (action is AllPreferencesLoadedAction) {
    hasPreferences = true;
    isLoading = false;
  } else if (action is SetPreferenceAction) {
    hasPreferences = true;
    isLoading = false;
  } else {
    isLoading = false;
    hasFirstLoad = true;
    hasPreferences = false;
  }

  return new AppState(
    isLoading: isLoading,
    fires: firesReducer(state.fires, action),
    fire: fireReducer(state.fire, action),
    hasFirstLoad: hasFirstLoad,
    hasPreferences: hasPreferences,
    preferences: preferencesReducer(state.preferences, action),
  );
}
