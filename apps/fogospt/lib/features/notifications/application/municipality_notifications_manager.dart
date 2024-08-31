import 'package:fogospt/features/notifications/domain/municipality_data.dart';
import 'package:fogospt/main.dart';

String _notificationTopic(String DICO) => "notifications-$DICO";

class MunicipalityNotificationsManager {
  static String _notificationParser(Municipality municipality) =>
      _notificationTopic(municipality.key);

  static Future<void> enableMunicipality(Municipality municipality) async {
    final code = _notificationParser(municipality);
    toggleFirebaseMessageByTopic(
      toggleValue: true,
      topic: code,
    );
  }

  static Future<void> disableMunicipality(Municipality municipality) async {
    final code = _notificationParser(municipality);
    toggleFirebaseMessageByTopic(
      toggleValue: false,
      topic: code,
    );
  }
}
