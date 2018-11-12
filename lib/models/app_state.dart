class AppState {
  final List fires;
  final bool isLoading;

  AppState({this.fires, this.isLoading});

  AppState copyWith({int count, bool isLoading}) {
		return new AppState(
			fires: fires ?? this.fires,
			isLoading: isLoading ?? this.isLoading
		);
	}

  @override
	String toString() {
		return 'AppState{isLoading: $isLoading, fires count: ${fires.length}}';
	}
}
