import 'package:dart_mappable/dart_mappable.dart';
import 'package:fogospt/features/select_notifications/domain/municipality_data.dart';
import 'package:warnings/state_management/base_state.dart';
import 'package:warnings/state_management/state_status.dart';

part 'municipalities_state.mapper.dart';

@MappableClass()
final class MunicipalitiesState extends BaseState
    with MunicipalitiesStateMappable {
  final Map<DistrictValue, List<MunicipalityValue>> municipalitiesPerDistrict;

  MunicipalitiesState({
    Map<DistrictValue, List<MunicipalityValue>>? municipalitiesPerDistrict,
    super.status = StateStatus.initial,
  }) : municipalitiesPerDistrict = municipalitiesPerDistrict ?? {};
}

extension MunicipalitiesStateExtension on MunicipalitiesState {
  MunicipalitiesState failure() => copyWith(status: StateStatus.failure);
  MunicipalitiesState loading() => copyWith(status: StateStatus.loading);
  MunicipalitiesState sucess({
    Map<DistrictValue, List<MunicipalityValue>>? municipalitiesPerDistrict,
  }) =>
      copyWith(
        status: StateStatus.success,
        municipalitiesPerDistrict: municipalitiesPerDistrict,
      );
}
