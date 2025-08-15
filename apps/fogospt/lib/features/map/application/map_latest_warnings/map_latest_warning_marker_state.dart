import 'package:dart_mappable/dart_mappable.dart';
import 'package:fogos_api/features/latest_warnings/domain/fire.dart';
import 'package:warnings/state_management/base_state.dart';
import 'package:warnings/state_management/state_status.dart';

part 'map_latest_warning_marker_state.mapper.dart';

@MappableClass()
final class MapLatestWarningMarkerState extends BaseState
    with MapLatestWarningMarkerStateMappable {
  final Set<Fire> warnings;
  final Set<Fire> activeWarnings;

  MapLatestWarningMarkerState({
    super.status = StateStatus.initial,
    Set<Fire>? warnings,
    Set<Fire>? activeWarnings,
  })  : warnings = warnings ?? <Fire>{},
        activeWarnings = activeWarnings ?? <Fire>{};
}

extension MapLatestFiresStateExtension on MapLatestWarningMarkerState {
  MapLatestWarningMarkerState loading() {
    return MapLatestWarningMarkerState(
      status: StateStatus.loading,
    );
  }

  MapLatestWarningMarkerState success({Set<Fire>? fires}) {
    return MapLatestWarningMarkerState(
      warnings: warnings,
      activeWarnings:
          fires?.where((Fire element) => element.active).toSet() ?? <Fire>{},
      status: StateStatus.success,
    );
  }

  MapLatestWarningMarkerState failure() {
    return MapLatestWarningMarkerState(
      status: StateStatus.failure,
    );
  }
}