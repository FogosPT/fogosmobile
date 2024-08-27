import 'package:dart_mappable/dart_mappable.dart';
import 'package:fogospt/features/notifications/domain/municipality_data.dart';
import '';

part 'municipality_state.mapper.dart';


@MappableClass()
sealed class AmendoinsState with AmendoinsStateMappable {}

@MappableClass()
class AmendoinsStateInitial extends AmendoinsState
    with AmendoinsStateInitialMappable {}

@MappableClass()
class AmendoinsStateLoading extends AmendoinsState
    with AmendoinsStateLoadingMappable {}

@MappableClass()
class AmendoinsStateLoaded extends AmendoinsState
    with AmendoinsStateLoadedMappable {

  AmendoinsStateLoaded();
}

@MappableClass()
class AmendoinsStateFailed extends AmendoinsState
    with AmendoinsStateFailedMappable {}
