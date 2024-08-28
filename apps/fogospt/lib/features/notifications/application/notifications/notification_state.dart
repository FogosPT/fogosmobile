import 'package:dart_mappable/dart_mappable.dart';
import 'package:fogospt/features/notifications/domain/municipality_data.dart';

part 'notification_state.mapper.dart';

@MappableClass()
sealed class NotificationState with NotificationStateMappable {}

@MappableClass()
class NotificationStarted extends NotificationState
    with NotificationStartedMappable {
  NotificationStarted();
}

@MappableClass()
class NotificationLoading extends NotificationState
    with NotificationLoadingMappable {}

@MappableClass()
class NotificationSuccessful extends NotificationState
    with NotificationSuccessfulMappable {
  final List<Municipality>? allMunicipalities;
  final Map<String, List<Municipality>>? municipalitiesPerDistrict;

  NotificationSuccessful({
    this.allMunicipalities,
    this.municipalitiesPerDistrict,
  });
}

@MappableClass()
class NotificationFailed extends NotificationState
    with NotificationFailedMappable {
  final String error;
  NotificationFailed({
    required this.error,
  });
}
