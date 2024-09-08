import 'package:bloc/bloc.dart';
import 'package:fogospt/features/select_notifications/application/fetch_municipalities_service.dart';
import 'package:fogospt/features/select_notifications/application/municipalities_cubit/municipalities_cubit.dart';
import 'package:fogospt/features/select_notifications/application/municipalities_notifications_manager.dart';
import 'package:fogospt/features/select_notifications/data/municipalities_shared_preferences.dart';
import 'package:fogospt/features/select_notifications/application/selected_notifications_cubit/selected_notifications_state.dart';
import 'package:fogospt/features/select_notifications/domain/municipality_data.dart';
import 'package:get_it/get_it.dart';

class SelectedNotificationsCubit extends Cubit<SelectedNotificationsState> {
  SelectedNotificationsCubit() : super(SelectedNotificationsState());

  final _municipalitiesService = GetIt.I<FetchMunicipalitiesService>();

  Future<void> fetchNotifications() async {
    emit(state.loading());

    List<MunicipalityValue> _municipalities =
        await _municipalitiesService.fetchAllMunicipalities();

    final Set<String> _municipalitiesKeys = {};

    for (int i = 0; i < _municipalities.length; i++) {
      MunicipalityValue municipality = _municipalities[i];
      final isActive =
          await MunicipalitiesSharedPreferences.loadTopicNotificationKey(
        key: municipality.key,
      );
      if (isActive) {
        _municipalitiesKeys.add(municipality.key);
      }
    }

    emit(state.success(activeMunicipalities: _municipalitiesKeys));
  }

  Future<void> toggleNotification({
    required MunicipalityValue municipality,
    required bool toggleValue,
    required MunicipalitiesCubit municipalityCubit,
  }) async {
    final result =
        await MunicipalitiesSharedPreferences.saveTopicNotificationKey(
      key: municipality.key,
      value: toggleValue,
    );

    await fetchNotifications();

    if (result) {
      MunicipalityNotificationsManager.toggleMunicipality(
        municipality: municipality,
        enabled: toggleValue,
      );
    }
  }
}
