import 'package:dart_mappable/dart_mappable.dart';
import 'package:fogospt/features/select_notifications/domain/municipality_data.dart';
import 'package:warnings/state_management/base_state.dart';
import 'package:warnings/state_management/state_status.dart';

part 'notifications_selected_district_state.mapper.dart';

@MappableClass()
final class DistrictSelectedState extends BaseState
    with DistrictSelectedStateMappable {
  final DistrictValue? _district;

  DistrictSelectedState({
    DistrictValue? district,
    super.status = StateStatus.initial,
  }) : _district = district;

  DistrictValue? get district {
    return _district;
  }
}

extension DistrictSelectedStateExtension on DistrictSelectedState {
  DistrictSelectedState loading() => copyWith(status: StateStatus.loading);
  DistrictSelectedState failure() => copyWith(status: StateStatus.failure);
  DistrictSelectedState success({
    required DistrictValue district,
  }) =>
      copyWith(
        status: StateStatus.success,
        district: district,
      );
}
