import 'package:shared_preferences/shared_preferences.dart';

import 'package:fogosmobile/models/fire.dart';

class AppState {
  List fires;
  Fire fire;
  bool isLoading = false;
  bool hasFirstLoad = false;
  SharedPreferences preferences;

  AppState({this.fires, this.fire, this.isLoading, this.hasFirstLoad}) {
    SharedPreferences.getInstance().then((prefs) {
      this.preferences = prefs;
    });
  }

  AppState copyWith({List fires, Fire fire, bool isLoading, bool hasFirstLoad}) {
    return new AppState(
      fires: fires ?? this.fires,
      fire: fire ?? this.fires,
      isLoading: isLoading ?? this.isLoading,
      hasFirstLoad: hasFirstLoad ?? this.hasFirstLoad,
    );
  }

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, \nfires count: ${fires?.length}, \nselected fire: $fire, \nhasFirstLoad: $hasFirstLoad, \nprefs: $preferences}';
  }
}
