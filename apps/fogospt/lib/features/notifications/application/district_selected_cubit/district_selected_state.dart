import 'package:dart_mappable/dart_mappable.dart';
import 'package:fogospt/features/notifications/domain/municipality_data.dart';

part 'district_selected_state.mapper.dart';

@MappableClass()
sealed class DistrictSelectedState with DistrictSelectedStateMappable {}

@MappableClass()
class DistrictSelectedStarted extends DistrictSelectedState
    with DistrictSelectedStartedMappable {}

@MappableClass()
class DistrictSelectedLoading extends DistrictSelectedState
    with DistrictSelectedLoadingMappable {}

@MappableClass()
class DistrictSelected extends DistrictSelectedState
    with DistrictSelectedMappable {
  final District district;
  DistrictSelected({
    required this.district,
  });
}

@MappableClass()
class DistrictUnselected extends DistrictSelectedState
    with DistrictUnselectedMappable {
  DistrictUnselected();
}

@MappableClass()
class DistrictSelectedFailed extends DistrictSelectedState
    with DistrictSelectedFailedMappable {}
