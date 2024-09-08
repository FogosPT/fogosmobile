import 'package:dart_mappable/dart_mappable.dart';
import 'package:fogos_api/features/latest_warnings/domain/fire.dart';
import 'package:fogos_api/features/latest_warnings/domain/history_status.dart';
import 'package:fogos_api/features/latest_warnings/domain/rcm.dart';
import 'package:fogos_api/features/latest_warnings/domain/resources.dart';
import 'package:warnings/state_management/base_state.dart';
import 'package:warnings/state_management/state_status.dart';

part 'fires_state.mapper.dart';

@MappableClass()
final class FiresState extends BaseState with FiresStateMappable {
  final Fire? fire;
  final List<Resources> resources;
  final List<HistoryStatus> historyStatuses;
  final List<RCM> rcm;

  FiresState({
    super.status = StateStatus.initial,
    Fire? fire,
    List<Resources>? resources,
    List<HistoryStatus>? historyStatuses,
    List<RCM>? rcm,
    String? errorMessage,
  })  : fire = fire,
        resources = resources ?? [],
        historyStatuses = historyStatuses ?? [],
        rcm = rcm ?? [];

  /// Returns the latest resource from the resources list if the state is success and the resources list is not empty or null.
  ///
  /// Given the API the latest resource is the last element of the resources list.
  /// If the resource is negative, it returns 0. -1 is possible because of an issue of the official sources.
  int get latestResourceTerrain => switch (this) {
        _ when isSuccess && resources.isNotEmpty =>
          resources.last.terrain < 0 ? 0 : resources.last.terrain,
        _ => 0,
      };

  int get latestResourceAerial => switch (this) {
        _ when isSuccess && resources.isNotEmpty =>
          resources.last.aerial < 0 ? 0 : resources.last.aerial,
        _ => 0,
      };

  int get latestResourceMan => switch (this) {
        _ when isSuccess && resources.isNotEmpty =>
          resources.last.man < 0 ? 0 : resources.last.man,
        _ => 0,
      };

  RCM? get latestRCM => switch (this) {
        _ when isSuccess && rcm.isNotEmpty => rcm.last,
        _ => null,
      };
}

extension FiresStateExtension on FiresState {
  FiresState failure() => copyWith(status: StateStatus.failure);
  FiresState loading() => copyWith(status: StateStatus.loading);
  FiresState success({
    Fire? fire,
    List<Resources>? resources,
    List<HistoryStatus>? historyStatuses,
    List<RCM>? rcm,
  }) =>
      copyWith(
        status: StateStatus.success,
        fire: fire,
        resources: resources,
        historyStatuses: historyStatuses,
        rcm: rcm,
      );

  FiresState error({required String errorMessage}) {
    return FiresState(
      status: StateStatus.failure,
      errorMessage: errorMessage,
    );
  }
}
