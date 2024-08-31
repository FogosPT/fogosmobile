import 'package:fogospt/features/select_notifications/domain/municipality_data.dart';
import 'package:fogospt/main.dart';

String _notificationTopic(String DICO) => "notification-$DICO";

class MunicipalityNotificationsManager {
  static String _notificationParser(MunicipalityValue municipality) =>
      _notificationTopic(municipality.key);

  static Future<void> toggleMunicipality({
    required MunicipalityValue municipality,
    required bool enabled,
  }) async {
    final topic = _notificationParser(municipality);
    toggleFirebaseMessageByTopic(
      toggleValue: enabled,
      topic: topic,
    );
  }
}
