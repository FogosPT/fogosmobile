import 'package:dart_mappable/dart_mappable.dart';
import 'package:fogos_api/features/latest_warnings/domain/fire.dart';
import 'package:warnings/warnings.dart';

part 'selected_fire_state.mapper.dart';

@MappableClass()
final class SelectedFireState extends BaseState with SelectedFireStateMappable {
  final Fire? fire;

  SelectedFireState({
    super.status = StateStatus.initial,
    Fire? fire,
  }) : fire = fire;
}

extension SelectedFireStateExtension on SelectedFireState {
  SelectedFireState failure() => copyWith(status: StateStatus.failure);
  SelectedFireState loading() => copyWith(status: StateStatus.loading);
  SelectedFireState success({
    Fire? fire,
  }) =>
      copyWith(
        status: StateStatus.success,
        fire: fire,
      );
}
