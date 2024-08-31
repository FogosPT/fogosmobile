import 'package:bloc/bloc.dart';
import 'package:fogospt/features/notifications/application/municipalities_service.dart';
import 'package:fogospt/features/notifications/application/municipality_cubit/municipality_state.dart';
import 'package:get_it/get_it.dart';

class MunicipalityCubit extends Cubit<MunicipalityState> {
  MunicipalityCubit() : super(MunicipalityStateInitial());

  final _municipalitiesService = GetIt.I.get<MunicipalitiesService>();

  Future<void> loadMunicipalities() async {
    emit(MunicipalityStateLoading());

    try {
      final municipalities =
          await _municipalitiesService.getMunicipalitiesPerDistrict();

      emit(MunicipalityStateLoaded(municipalitiesPerDistrict: municipalities));
    } on Exception catch (_) {
      emit(MunicipalityStateFailed());
    }
  }
}
