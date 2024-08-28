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
    try {
      final municipalitiesPerDistrict = Map<String, List<Municipality>>();

      _municipalities.forEach((element) {
        if (municipalitiesPerDistrict.containsKey(element.value.districtId)) {
          municipalitiesPerDistrict[element.value.districtId]!.add(element);
        } else {
          municipalitiesPerDistrict[element.value.districtId] = [element];
        }
      });

      emit(NotificationSuccessful(
          allMunicipalities: _municipalities,
          municipalitiesPerDistrict: municipalitiesPerDistrict));
    } on Exception catch (e) {
      emit(NotificationFailed(error: e.toString()));
    }
  }
}
