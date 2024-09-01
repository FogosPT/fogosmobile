import 'package:warnings/state_management/state_status.dart';

class BaseState {
  final StateStatus status;

  BaseState({
    required this.status,
  });
}

extension StateExtension on BaseState {
  bool get isInitial => status == StateStatus.initial;
  bool get isLoading => status == StateStatus.loading;
  bool get isSuccess => status == StateStatus.success;
  bool get isFailure => status == StateStatus.failure;
}
