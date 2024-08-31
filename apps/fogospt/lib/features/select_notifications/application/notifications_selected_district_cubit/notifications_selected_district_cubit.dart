import 'package:bloc/bloc.dart';
import 'package:fogospt/features/select_notifications/application/notifications_selected_district_cubit/notifications_selected_district_state.dart';
import 'package:fogospt/features/select_notifications/domain/municipality_data.dart';

class NotificationsSelectedDistrictCubit extends Cubit<DistrictSelectedState> {
  NotificationsSelectedDistrictCubit() : super(DistrictSelectedState());

  void selectDistrict(DistrictValue district) {
    emit(state.success(district: district));
  }
}
