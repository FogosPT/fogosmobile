import 'package:dart_mappable/dart_mappable.dart';
import 'package:fogos_api/features/latest_warnings/domain/fire.dart';
import 'package:warnings/state_management/state.dart';
import 'package:warnings/state_management/state_status.dart';

part 'map_latest_fires_state.mapper.dart';

@MappableClass()
final class MapLatestFiresState extends BaseState
    with MapLatestFiresStateMappable {
  final List<Fire> fires;

  MapLatestFiresState({
    super.status = StateStatus.initial,
    this.fires = const [],
  });
}

extension MunicipalitiesStateExtension on MapLatestFiresState {
  MapLatestFiresState loading() {
    return MapLatestFiresState(
      status: StateStatus.loading,
      fires: fires,
    );
  }

  MapLatestFiresState success({
    required List<Fire> fires,
  }) {
    return MapLatestFiresState(
      status: StateStatus.success,
      fires: fires,
    );
  }

  MapLatestFiresState failure() {
    return MapLatestFiresState(
      status: StateStatus.failure,
      fires: fires,
    );
  }
}
