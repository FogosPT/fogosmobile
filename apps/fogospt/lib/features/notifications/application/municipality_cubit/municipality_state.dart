import 'package:dart_mappable/dart_mappable.dart';
import 'package:fogospt/features/notifications/domain/municipality_data.dart';

part 'municipality_state.mapper.dart';

@MappableClass()
sealed class MunicipalityState with MunicipalityStateMappable {}

@MappableClass()
class MunicipalityStateInitial extends MunicipalityState
    with MunicipalityStateInitialMappable {}

@MappableClass()
class MunicipalityStateLoading extends MunicipalityState
    with MunicipalityStateLoadingMappable {}

@MappableClass()
class MunicipalityStateLoaded extends MunicipalityState
    with MunicipalityStateLoadedMappable {
  final Map<District, List<Municipality>> municipalitiesPerDistrict;

  MunicipalityStateLoaded({required this.municipalitiesPerDistrict});
}

@MappableClass()
class MunicipalityStateFailed extends MunicipalityState
    with MunicipalityStateFailedMappable {}
