import 'package:bloc/bloc.dart';
import 'package:fogospt/features/select_notifications/application/fetch_municipalities_service.dart';
import 'package:fogospt/features/select_notifications/application/municipalities_cubit/municipalities_state.dart';
import 'package:get_it/get_it.dart';

class MunicipalitiesCubit extends Cubit<MunicipalitiesState> {
  MunicipalitiesCubit() : super(MunicipalitiesState());

  final _municipalitiesService = GetIt.I.get<FetchMunicipalitiesService>();

  Future<void> loadMunicipalities() async {
    emit(state.loading());

    try {
      final municipalities =
          await _municipalitiesService.getMunicipalitiesPerDistrict();

      emit(state.success(municipalitiesPerDistrict: municipalities));
    } on Exception catch (_) {
      emit(state.failure());
    }
  }
}
