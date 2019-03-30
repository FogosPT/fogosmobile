import 'package:fogosmobile/models/fire.dart';
class AppState {
  List fires;
  Fire fire;
  bool isLoading = false;
  bool hasFirstLoad = false;

  AppState({this.fires, this.fire, this.isLoading, this.hasFirstLoad});

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
    return 'AppState{isLoading: $isLoading, fires count: ${fires?.length}, selected fire: $fire, hasFirstLoad: $hasFirstLoad}';
  }
}
