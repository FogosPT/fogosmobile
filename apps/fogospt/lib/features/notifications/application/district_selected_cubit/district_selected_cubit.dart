import 'package:bloc/bloc.dart';
import 'package:fogospt/features/notifications/application/district_selected_cubit/district_selected_state.dart';
import 'package:fogospt/features/notifications/domain/municipality_data.dart';

class DistrictSelectedCubit extends Cubit<DistrictSelectedState> {
  DistrictSelectedCubit() : super(DistrictSelectedStarted());

  void selectDistrict(District district) {
    emit(
      DistrictSelected(district: district),
    );
  }
}
