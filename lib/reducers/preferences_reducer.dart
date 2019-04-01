import 'package:fogosmobile/actions/preferences_actions.dart';

preferencesReducer(dynamic preferences, action) {
  if (action is LoadAllPreferencesAction) {
    return preferences;
  } else if (action is AllPreferencesLoadedAction) {
    return action.preferences;
  } else if (action is TurnOnNotificationAction) {
    return preferences;
  } else if (action is TurnedOnNotificationAction) {
    return action.key;
  } else if (action is TurnOffNotificationAction) {
    return preferences;
  } else if (action is TurnedOffNotificationAction) {
    return action.key;
  } else {
    return preferences;
  }
}
