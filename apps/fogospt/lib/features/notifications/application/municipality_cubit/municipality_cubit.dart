import 'package:bloc/bloc.dart';
import 'package:fogospt/features/notifications/application/municipalities_service.dart';
import 'package:fogospt/features/notifications/application/municipality_cubit/municipality_state.dart';
import 'package:fogospt/features/notifications/application/notifications_shared_preferences.dart';
import 'package:get_it/get_it.dart';

class MunicipalityCubit extends Cubit<MunicipalityState> {
  MunicipalityCubit() : super(MunicipalityStateInitial());

  final _municipalitiesService = GetIt.I.get<MunicipalitiesService>();

  Future<void> loadMunicipalities() async {
    emit(MunicipalityStateLoading());

    try {
      final municipalities =
          await _municipalitiesService.fetchAllMunicipalities();

      emit(MunicipalityStateLoaded(municipalities: municipalities));
    } on Exception catch (_) {
      emit(MunicipalityStateFailed());
    }
  }

  Future<void> enableMunicipality(String key) async {
    MunicipalitiesSharedPreferences.setTopicNotifications(key, true);
  }

  Future<void> disableMunicipality(String key) async {
    MunicipalitiesSharedPreferences.setTopicNotifications(key, false);
  }
}
