class AllPreferencesLoadedAction {
  final Map? preferences;

  AllPreferencesLoadedAction(this.preferences);
}

class LoadAllPreferencesAction {}

class SetFireNotificationAction {
  final String? key;
  final int? value;

  SetFireNotificationAction(this.key, this.value);
}

class SetPreferenceAction {
  final String? key;
  final int? value;

  SetPreferenceAction(this.key, this.value);
}
