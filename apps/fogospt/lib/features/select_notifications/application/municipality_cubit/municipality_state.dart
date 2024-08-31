import 'package:dart_mappable/dart_mappable.dart';
import 'package:fogospt/features/select_notifications/domain/municipality_data.dart';
import 'package:warnings/state_management/state.dart';
import 'package:warnings/state_management/state_status.dart';

part 'municipality_state.mapper.dart';

@MappableClass()
final class MunicipalityState extends BaseState with MunicipalityStateMappable {
  final Map<DistrictValue, List<MunicipalityValue>> municipalitiesPerDistrict;

  MunicipalityState({
    Map<DistrictValue, List<MunicipalityValue>>? municipalitiesPerDistrict,
    super.status = StateStatus.initial,
  }) : municipalitiesPerDistrict = municipalitiesPerDistrict ?? {};
}

extension MunicipalityStateExtension on MunicipalityState {
  MunicipalityState loading() {
    return MunicipalityState(
      status: StateStatus.loading,
      municipalitiesPerDistrict: municipalitiesPerDistrict,
    );
  }

  MunicipalityState success({
    required Map<DistrictValue, List<MunicipalityValue>>
        municipalitiesPerDistrict,
  }) {
    return MunicipalityState(
      status: StateStatus.success,
      municipalitiesPerDistrict: municipalitiesPerDistrict,
    );
  }

  MunicipalityState failure() {
    return MunicipalityState(
      status: StateStatus.failure,
      municipalitiesPerDistrict: municipalitiesPerDistrict,
    );
  }
}
