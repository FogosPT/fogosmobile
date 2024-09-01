import 'package:bloc/bloc.dart';
import 'package:fogospt/features/fires/application/fires/fires_state.dart';
import 'package:fogospt/features/fires/data/fire_service.dart';
import 'package:warnings/state_management/base_state.dart';

class FiresCubit extends Cubit<FiresState> {
  FireService service;

  FiresCubit(this.service) : super(FiresState());

  /// Fetches all the information for a fire
  ///
  /// TODO(FB): Better error handling.
  ///
  Future<void> fetchAllFireInformation(String fireId) async {
    emit(state.loading());

    Future.wait([
      _updateFire(fireId),
      _updateResources(fireId),
      _updateHistoryStatuses(fireId),
      _updateRCM(fireId)
    ]);
  }

  Future<void> _updateFire(String fireId) {
    return service.fetchFire(fireId).then(
          (fire) => state.isSuccess
              ? emit(state.success(fire: fire))
              : emit(state.failure()),
        );
  }

  Future<void> _updateResources(String fireId) {
    return service.fetchResources(fireId).then(
          (resources) => state.isSuccess
              ? emit(state.success(resources: resources))
              : emit(state.failure()),
        );
  }

  Future<void> _updateHistoryStatuses(String fireId) {
    return service.fetchHistoryStatuses(fireId).then(
          (history) => state.isSuccess
              ? emit(state.success(historyStatuses: history))
              : emit(state.failure()),
        );
  }

  Future<void> _updateRCM(String fireId) {
    return service.fetchRCM(fireId).then(
          (rcm) => state.isSuccess
              ? emit(state.success(rcm: rcm))
              : emit(state.failure()),
        );
  }
}
