import 'package:bloc/bloc.dart';
import 'package:fogospt/features/notifications/application/municipalities_service.dart';
import 'package:fogospt/features/notifications/application/notifications/notification_state.dart';
import 'package:fogospt/features/notifications/domain/municipality_data.dart';
import 'package:get_it/get_it.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationStarted());

  final MunicipalitiesService _municipalitiesService =
      GetIt.I<MunicipalitiesService>();

  Future<void> fetchNotifications() async {
    List<Municipality> _municipalities =
        await _municipalitiesService.fetchAllMunicipalities();

    emit(NotificationLoading());
  }
}
