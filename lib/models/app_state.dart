import 'package:fogosmobile/models/fire.dart';

class AppState {
  List fires = [];
  Fire fire;
  List<FireStatus> activeFilters = [];
  bool isLoading = false;
  bool hasFirstLoad = false;
  bool hasPreferences = false;
  Map preferences = {};

  AppState(
      {this.fires,
      this.fire,
      this.isLoading,
      this.hasFirstLoad,
      this.hasPreferences,
      this.preferences,
      this.activeFilters});

  AppState copyWith({
    List fires,
    Fire fire,
    bool isLoading,
    bool hasFirstLoad,
    bool hasPreferences,
    Map preferences,
    List<FireStatus> activeFilters,
  }) {
    return new AppState(
        fires: fires ?? this.fires,
        fire: fire ?? this.fires,
        isLoading: isLoading ?? this.isLoading,
        hasFirstLoad: hasFirstLoad ?? this.hasFirstLoad,
        hasPreferences: hasPreferences ?? this.hasPreferences,
        preferences: preferences ?? this.preferences,
        activeFilters: activeFilters ?? this.activeFilters);
  }

  @override
  String toString() {
    return 'AppState\n{isLoading: $isLoading, \nfires count: ${fires?.length}, \nselected fire: $fire, \nhasFirstLoad: $hasFirstLoad, \nhasPreferences: $hasPreferences, \nprefs: $preferences, \nactivefilters: $activeFilters}';
  }
}
