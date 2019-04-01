import 'package:fogosmobile/actions/preferences_actions.dart';

preferencesReducer(dynamic preferences, action) {
  if (action is LoadAllPreferencesAction) {
    return preferences;
  } else if (action is AllPreferencesLoadedAction) {
    return action.preferences;
  } else if (action is SetPreferenceAction) {
    return preferences;
  } else {
    return preferences;
  }
}
