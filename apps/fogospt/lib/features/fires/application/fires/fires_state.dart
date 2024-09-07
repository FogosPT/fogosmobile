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

  /// Returns the latest resource from the resources list if the state is success and the resources list is not empty or null
  ///
  /// Given the API the latest resource is the last element of the resources list
  ///
  /// Throws an exception if the state is not success, or the resources list is empty or null
  ///
  /// TODO(FB): Add specific exception
  ///
  Resources get latestResource => switch (this) {
        _ when isSuccess && resources.isNotEmpty => resources.last,
        _ => throw Exception('No resources available'),
      };

  RCM get latestRCM => switch (this) {
        _ when isSuccess && rcm.isNotEmpty => rcm.last,
        _ => throw Exception('No RCM available'),
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
