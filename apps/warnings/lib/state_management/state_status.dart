enum StateStatus {
  initial,
  loading,
  success,
  failure,
}

extension StateStatusExtension on StateStatus {
  bool get isInitial => this == StateStatus.initial;
  bool get isLoading => this == StateStatus.loading;
  bool get isSuccess => this == StateStatus.success;
  bool get isFailure => this == StateStatus.failure;
}
