class AppState {
  List fires;
  bool isLoading;

  AppState({this.fires, this.isLoading});

  AppState copyWith({List fires, bool isLoading}) {
    return new AppState(
      fires: fires ?? this.fires,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, fires count: ${fires.length}}';
  }
}
