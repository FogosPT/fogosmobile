import 'package:dart_mappable/dart_mappable.dart';
import 'package:fogos_api/features/latest_warnings/domain/fire.dart';
import 'package:fogos_api/features/latest_warnings/domain/history_status.dart';
import 'package:fogos_api/features/latest_warnings/domain/rcm.dart';
import 'package:fogos_api/features/latest_warnings/domain/resources.dart';

part 'fires_state.mapper.dart';

@MappableClass()
sealed class FiresState with FiresStateMappable {}

@MappableClass()
class FiresStateInitial with FiresStateInitialMappable implements FiresState {
  const FiresStateInitial();
}

@MappableClass()
class FiresStateLoading with FiresStateLoadingMappable implements FiresState {
  const FiresStateLoading();
}

@MappableClass()
class FiresStateLoaded with FiresStateLoadedMappable implements FiresState {
  final Fire? fire;
  final List<Resources>? resources;
  final List<HistoryStatus>? historyStatuses;
  final List<RCM>? rcm;

  const FiresStateLoaded({
    this.fire,
    this.resources,
    this.historyStatuses,
    this.rcm,
  });

  Resources? get latestResource => resources?.last;
  HistoryStatus? get latestHistoryStatus => historyStatuses?.last;
  RCM? get latestRCM => rcm?.last;
}

@MappableClass()
class FiresStateFailed with FiresStateFailedMappable implements FiresState {
  const FiresStateFailed();
}
