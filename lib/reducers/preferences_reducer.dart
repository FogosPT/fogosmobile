import 'package:fogosmobile/actions/preferences_actions.dart';

preferencesReducer(dynamic preferences, action) {
  if (action is LoadAllPreferencesAction) {
    return preferences;
  } else if (action is AllPreferencesLoadedAction) {
    return action.preferences;
  } else if (action is SetPreferenceAction) {
    preferences[action.key] = action.value;
    return preferences;
  } else if (action is SetFireNotificationAction) {
    return preferences;
  } else {
    return preferences;
  }
}
