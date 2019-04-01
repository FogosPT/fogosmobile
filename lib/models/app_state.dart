import 'package:shared_preferences/shared_preferences.dart';

import 'package:fogosmobile/models/fire.dart';

class AppState {
  List fires = [];
  Fire fire;
  bool isLoading = false;
  bool hasFirstLoad = false;
  bool hasPreferences = false;
  List preferences = [];

  AppState(
      {this.fires,
      this.fire,
      this.isLoading,
      this.hasFirstLoad,
      this.hasPreferences,
      this.preferences});

  AppState copyWith(
      {List fires,
      Fire fire,
      bool isLoading,
      bool hasFirstLoad,
      bool hasPreferences,
      List preferences}) {
    return new AppState(
      fires: fires ?? this.fires,
      fire: fire ?? this.fires,
      isLoading: isLoading ?? this.isLoading,
      hasFirstLoad: hasFirstLoad ?? this.hasFirstLoad,
      hasPreferences: hasPreferences ?? this.hasPreferences,
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  String toString() {
    return 'AppState\n{isLoading: $isLoading, \nfires count: ${fires?.length}, \nselected fire: $fire, \nhasFirstLoad: $hasFirstLoad, \nhasPreferences: $hasPreferences, \nprefs: $preferences}';
  }
}
