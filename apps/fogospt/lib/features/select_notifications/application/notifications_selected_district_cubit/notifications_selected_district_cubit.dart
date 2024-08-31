import 'package:bloc/bloc.dart';
import 'package:fogospt/features/select_notifications/application/notifications_selected_district_cubit/notifications_selected_district_state.dart';
import 'package:fogospt/features/select_notifications/domain/municipality_data.dart';

class SelectedDistrictCubit extends Cubit<DistrictSelectedState> {
  SelectedDistrictCubit() : super(DistrictSelectedStarted());

  void selectDistrict(DistrictValue district) {
    emit(
      DistrictSelected(district: district),
    );
  }
}
