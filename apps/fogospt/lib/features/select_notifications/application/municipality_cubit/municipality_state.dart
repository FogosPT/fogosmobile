import 'package:dart_mappable/dart_mappable.dart';
import 'package:fogospt/features/select_notifications/domain/municipality_data.dart';
import 'package:warnings/state_management/base_state.dart';
import 'package:warnings/state_management/state_status.dart';

part 'municipality_state.mapper.dart';

@MappableClass()
final class MunicipalityState extends BaseState with MunicipalityStateMappable {
  final Map<DistrictValue, List<MunicipalityValue>> municipalitiesPerDistrict;

  MunicipalityState({
    super.status = StateStatus.initial,
    Map<DistrictValue, List<MunicipalityValue>>? municipalitiesPerDistrict,
  }) : municipalitiesPerDistrict = municipalitiesPerDistrict ?? {};
}

extension MunicipalityStateExtension on MunicipalityState {
  MunicipalityState failure() => copyWith(status: StateStatus.failure);
  MunicipalityState loading() => copyWith(status: StateStatus.loading);
  MunicipalityState success({
    required Map<DistrictValue, List<MunicipalityValue>>
        municipalitiesPerDistrict,
  }) =>
      copyWith(
        status: StateStatus.success,
        municipalitiesPerDistrict: municipalitiesPerDistrict,
      );
}
