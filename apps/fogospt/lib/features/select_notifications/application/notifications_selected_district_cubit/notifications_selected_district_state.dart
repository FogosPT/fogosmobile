import 'package:dart_mappable/dart_mappable.dart';
import 'package:fogospt/features/select_notifications/domain/municipality_data.dart';
import 'package:warnings/state_management/state.dart';
import 'package:warnings/state_management/state_status.dart';

part 'notifications_selected_district_state.mapper.dart';

@MappableClass()
final class DistrictSelectedState extends BaseState
    with DistrictSelectedStateMappable {
  final DistrictValue? district;

  DistrictSelectedState({
    this.district,
    super.status = StateStatus.initial,
  });
}

extension DistrictSelectedStateExtension on DistrictSelectedState {
  DistrictSelectedState loading() {
    return DistrictSelectedState(
      status: StateStatus.loading,
      district: district,
    );
  }

  DistrictSelectedState success({
    required DistrictValue district,
  }) {
    return DistrictSelectedState(
      status: StateStatus.success,
      district: district,
    );
  }

  DistrictSelectedState failure() {
    return DistrictSelectedState(
      status: StateStatus.failure,
      district: district,
    );
  }
}
