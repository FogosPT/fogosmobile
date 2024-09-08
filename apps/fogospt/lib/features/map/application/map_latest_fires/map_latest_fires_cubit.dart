import 'package:bloc/bloc.dart';
import 'package:fogospt/features/map/application/map_latest_fires/map_latest_fires_state.dart';
import 'package:fogospt/features/map/data/fires_latest_service.dart';

class MapLatestFiresCubit extends Cubit<MapLatestFiresState> {
  FiresLatestService service;

  MapLatestFiresCubit(this.service) : super(MapLatestFiresState());

  Future<void> fetchLatestFires() async {
    emit(state.loading());

    try {
      final fires = await service.fetchLatestFires();
      emit(state.copyWith(fires: fires));
    } on Exception catch (_) {
      emit(state.failure());
    }
  }
}
