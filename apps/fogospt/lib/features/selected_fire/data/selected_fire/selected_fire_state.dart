import 'package:dart_mappable/dart_mappable.dart';
import 'package:fogos_api/features/latest_warnings/domain/fire.dart';

part 'selected_fire_state.mapper.dart';

@MappableClass()
sealed class SelectedFireState with SelectedFireStateMappable {}

@MappableClass()
class SelectedFireInitialState extends SelectedFireState
    with SelectedFireInitialStateMappable {}

@MappableClass()
class SelectedFireLoadingState extends SelectedFireState
    with SelectedFireLoadingStateMappable {}

@MappableClass()
class SelectedFireLoadedState extends SelectedFireState
    with SelectedFireLoadedStateMappable {
  final Fire fire;

  SelectedFireLoadedState(this.fire);
}

@MappableClass()
class SelectedFireFailedState extends SelectedFireState
    with SelectedFireFailedStateMappable {}
