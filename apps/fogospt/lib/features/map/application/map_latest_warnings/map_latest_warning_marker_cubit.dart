import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:fogos_api/features/latest_warnings/domain/fire.dart' show Fire;
import 'package:fogospt/features/map/application/map_latest_warnings/map_latest_warning_marker_state.dart';
import 'package:fogospt/features/map/data/fires_latest_service.dart';
import 'package:warnings/state_management/state_status.dart' show StateStatus;

class MapLatestWarningMarkerCubit extends Cubit<MapLatestWarningMarkerState> {
  FiresLatestService service;

  MapLatestWarningMarkerCubit(this.service)
      : super(MapLatestWarningMarkerState());

  Future<void> fetchLatestFires() async {
    // emit(state.loading());

    try {
      final fires = await service.fetchLatestFires();
      final activeFires = fires.where((Fire fire) => fire.active).toSet();

      if (!setEquals(state.activeWarnings, activeFires)) {
        emit(
          state.copyWith(
            warnings: fires.toSet(),
            activeWarnings: activeFires,
            status: StateStatus.success,
          ),
        );
      }
    } on Exception catch (_) {
      emit(state.failure());
    }
  }
}
