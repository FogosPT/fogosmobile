class AllPreferencesLoadedAction {
  final Map? preferences;

  const AllPreferencesLoadedAction(this.preferences);
}

class LoadAllPreferencesAction {
  const LoadAllPreferencesAction();
}

class SetFireNotificationAction {
  final String? key;
  final int? value;

  const SetFireNotificationAction(this.key, this.value);
}

class SetPreferenceAction {
  final String? key;
  final int? value;

  const SetPreferenceAction(this.key, this.value);
}
