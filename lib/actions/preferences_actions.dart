class LoadAllPreferencesAction {}

class AllPreferencesLoadedAction {
  final List preferences;

  AllPreferencesLoadedAction(this.preferences);
}

class TurnOnNotificationAction {
  final String key;

  TurnOnNotificationAction(this.key);
}

class TurnedOnNotificationAction {
  final String key;

  TurnedOnNotificationAction(this.key);
}

class TurnOffNotificationAction {
  final String key;

  TurnOffNotificationAction(this.key);
}

class TurnedOffNotificationAction {
  final String key;

  TurnedOffNotificationAction(this.key);
}
