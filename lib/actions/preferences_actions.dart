class LoadAllPreferencesAction {}

class AllPreferencesLoadedAction {
  final Map preferences;

  AllPreferencesLoadedAction(this.preferences);
}

class SetPreferenceAction {
  final String key;
  final int value;

  SetPreferenceAction(this.key, this.value);
}