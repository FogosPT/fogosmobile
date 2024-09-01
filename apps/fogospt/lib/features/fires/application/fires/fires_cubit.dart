import 'package:bloc/bloc.dart';
import 'package:fogospt/features/fires/application/fires/fires_state.dart';
import 'package:fogospt/features/fires/data/fire_service.dart';

class FiresCubit extends Cubit<FiresState> {
  FireService service;

  FiresCubit(this.service) : super(FiresState());

  /// Fetches all the information for a fire
  ///
  /// TODO(FB): Better error handling.
  ///
  Future<void> fetchAllFireInformation(String fireId) async {
    emit(state.loading());

    final fire = await service.fetchFire(fireId);
    final resources = await service.fetchResources(fireId);
    final history = await service.fetchHistoryStatuses(fireId);
    final rcm = await service.fetchRCM(fireId);

    emit(
      state.success(
        fire: fire,
        resources: resources,
        historyStatuses: history,
        rcm: rcm,
      ),
    );
  }
}
