class AppState {
  List fires;
  bool isLoading;
  bool hasFirstLoad;

  AppState({this.fires, this.isLoading, this.hasFirstLoad});

  AppState copyWith({List fires, bool isLoading, bool hasFirstLoad}) {
    return new AppState(
      fires: fires ?? this.fires,
      isLoading: isLoading ?? this.isLoading,
      hasFirstLoad: hasFirstLoad ?? this.hasFirstLoad,
    );
  }

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, fires count: ${fires?.length}, hasFirstLoad: $hasFirstLoad}';
  }
}
