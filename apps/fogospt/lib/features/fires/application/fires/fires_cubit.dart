import 'package:bloc/bloc.dart';
import 'package:fogospt/features/fires/application/fires/fires_state.dart';
import 'package:fogospt/features/fires/data/fire_service.dart';

class FiresCubit extends Cubit<FiresState> {
  FireService service;

  FiresCubit(this.service) : super(FiresStateInitial());

  Future<void> fetchAllFireInformation(String fireId) async {
    emit(FiresStateLoading());

    try {
      _updateFire(fireId);
      _updateResources(fireId);
      _updateHistoryStatuses(fireId);
      _updateRCM(fireId);
    } catch (e) {
      emit(FiresStateFailed());
    }
  }

  Future<void> _updateFire(String fireId) {
    return service.fetchFire(fireId).then(
      (fire) {
        if (state is FiresStateLoaded) {
          emit(
            (state as FiresStateLoaded).copyWith(
              fire: fire,
            ),
          );
        } else {
          emit(
            FiresStateLoaded(
              fire: fire,
            ),
          );
        }
      },
    );
  }

  Future<void> _updateResources(String fireId) {
    return service.fetchResources(fireId).then(
      (resources) {
        if (state is FiresStateLoaded) {
          emit(
            (state as FiresStateLoaded).copyWith(resources: resources),
          );
        } else {
          emit(
            FiresStateLoaded(
              resources: resources,
            ),
          );
        }
      },
    );
  }

  Future<void> _updateHistoryStatuses(String fireId) {
    return service.fetchHistoryStatuses(fireId).then(
      (history) {
        if (state is FiresStateLoaded) {
          emit(
            (state as FiresStateLoaded).copyWith(historyStatuses: history),
          );
        } else {
          emit(
            FiresStateLoaded(
              historyStatuses: history,
            ),
          );
        }
      },
    );
  }

  Future<void> _updateRCM(String fireId) {
    return service.fetchRCM(fireId).then(
      (rcm) {
        if (state is FiresStateLoaded) {
          emit(
            (state as FiresStateLoaded).copyWith(rcm: rcm),
          );
        } else {
          emit(
            FiresStateLoaded(
              rcm: rcm,
            ),
          );
        }
      },
    );
  }
}
