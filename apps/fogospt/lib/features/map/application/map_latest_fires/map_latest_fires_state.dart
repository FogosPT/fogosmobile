import 'package:dart_mappable/dart_mappable.dart';
import 'package:fogos_api/features/latest_warnings/domain/fire.dart';
import 'package:warnings/state_management/base_state.dart';
import 'package:warnings/state_management/state_status.dart';

part 'map_latest_fires_state.mapper.dart';

@MappableClass()
final class MapLatestFiresState extends BaseState
    with MapLatestFiresStateMappable {
  final List<Fire> fires;

  MapLatestFiresState({
    super.status = StateStatus.initial,
    List<Fire>? fires,
  }) : fires = fires ?? [];
}

extension MapLatestFiresStateExtension on MapLatestFiresState {
  MapLatestFiresState loading() {
    return MapLatestFiresState(
      status: StateStatus.loading,
    );
  }

  MapLatestFiresState success({
    List<Fire>? fires,
  }) {
    return MapLatestFiresState(
      fires: fires,
      status: StateStatus.success,
    );
  }

  MapLatestFiresState failure() {
    return MapLatestFiresState(
      status: StateStatus.failure,
    );
  }
}
