import 'package:bloc/bloc.dart';
import 'package:fogospt/features/notifications/application/municipalities_service.dart';
import 'package:fogospt/features/notifications/application/notifications/notification_state.dart';
import 'package:fogospt/features/notifications/application/notifications_shared_preferences.dart';
import 'package:fogospt/features/notifications/domain/municipality_data.dart';
import 'package:get_it/get_it.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationStarted());

  final _municipalitiesService = GetIt.I<MunicipalitiesService>();

  Future<void> fetchNotifications() async {
    emit(NotificationLoading());

    List<Municipality> _municipalities =
        await _municipalitiesService.fetchAllMunicipalities();

    final Set<String> _municipalitiesKeys = {};

    for (Municipality municipality in _municipalities) {
      final isActive =
          await MunicipalitiesSharedPreferences.getTopicNotifications(
              municipality.key);
      if (isActive) {
        _municipalitiesKeys.add(municipality.value.name);
      }
    }

    emit(
      NotificationSuccessful(
        activeMunicipalities: _municipalitiesKeys,
      ),
    );
  }
}
