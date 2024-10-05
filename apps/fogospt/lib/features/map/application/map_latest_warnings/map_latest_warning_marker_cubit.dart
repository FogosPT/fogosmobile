import 'package:bloc/bloc.dart';
import 'package:fogospt/features/map/application/map_latest_warnings/map_latest_warning_marker_state.dart';
import 'package:fogospt/features/map/data/fires_latest_service.dart';

class MapLatestWarningMarkerCubit extends Cubit<MapLatestWarningMarkerState> {
  FiresLatestService service;

  MapLatestWarningMarkerCubit(this.service)
      : super(MapLatestWarningMarkerState());

  Future<void> fetchLatestFires() async {
    emit(state.loading());

    try {
      final fires = await service.fetchLatestFires();
      emit(state.success(fires: fires.toSet()));
    } on Exception catch (_) {
      emit(state.failure());
    }
  }
}
