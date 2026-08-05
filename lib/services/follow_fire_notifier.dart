import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Android counterpart to iOS Live Activity: a colored ongoing notification
/// per followed fire. Built entirely in Dart via `flutter_local_notifications`
/// so it can also be updated from the FCM background isolate when the app
/// is closed and a `follow-fire-update` push arrives.
class FollowFireNotifier {
  static const String _channelId = 'fogos_following';
  static const String _channelName = 'Fogos seguidos';
  static const String _channelDesc =
      'Notificação persistente para incêndios em curso que estás a seguir.';
  static const String _prefKeyPrefix = 'follow_fire_';
  static const String _actionStop = 'stop_follow';

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  /// Initialize the plugin. Safe to call multiple times (including from a
  /// background isolate); the plugin de-duplicates internally.
  static Future<void> init() async {
    if (_initialized) return;
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: _onResponse,
      onDidReceiveBackgroundNotificationResponse: _onResponse,
    );
    _initialized = true;
  }

  /// Post or update the ongoing notification for a followed fire.
  static Future<void> notify({
    required String fireId,
    required String title,
    required String location,
    required String statusText,
    required String statusColorHex,
    required int human,
    required int terrain,
    required int aerial,
    required bool isFire,
  }) async {
    await init();
    final body = _buildBody(statusText, human, terrain, aerial);
    final bigText = _buildBigText(location, statusText, human, terrain, aerial);
    final color = _parseColor(statusColorHex);
    final details = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      onlyAlertOnce: true,
      color: color,
      colorized: true,
      styleInformation: BigTextStyleInformation(bigText),
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          _actionStop,
          'Deixar de seguir',
          cancelNotification: true,
          showsUserInterface: false,
        ),
      ],
    );
    await _plugin.show(
      fireId.hashCode,
      title,
      body,
      NotificationDetails(android: details),
      payload: 'follow:$fireId',
    );
  }

  /// Cancel the notification and clear the persisted follow flag.
  static Future<void> cancel(String fireId) async {
    await init();
    await _plugin.cancel(fireId.hashCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_prefKeyPrefix$fireId');
  }

  static Future<void> setFollowFlag(String fireId, bool following) async {
    final prefs = await SharedPreferences.getInstance();
    if (following) {
      await prefs.setBool('$_prefKeyPrefix$fireId', true);
    } else {
      await prefs.remove('$_prefKeyPrefix$fireId');
    }
  }

  static Future<bool> isFollowing(String fireId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_prefKeyPrefix$fireId') ?? false;
  }

  static String _buildBody(String status, int h, int t, int a) {
    final parts = <String>[];
    if (status.isNotEmpty) parts.add(status);
    parts.add('👥 $h  🚗 $t  ✈️ $a');
    return parts.join(' · ');
  }

  static String _buildBigText(String location, String status, int h, int t, int a) {
    final buf = StringBuffer();
    if (location.isNotEmpty) buf.writeln(location);
    if (status.isNotEmpty) buf.writeln(status);
    buf.write('Operacionais: $h   Viaturas: $t   Aéreos: $a');
    return buf.toString();
  }

  static Color _parseColor(String hex) {
    var s = hex.startsWith('#') ? hex.substring(1) : hex;
    if (s.length == 6) s = 'FF$s';
    final v = int.tryParse(s, radix: 16);
    if (v == null) return const Color(0xFFFF512F);
    return Color(v);
  }

  @pragma('vm:entry-point')
  static void _onResponse(NotificationResponse response) {
    if (response.actionId != _actionStop) return;
    final payload = response.payload ?? '';
    if (!payload.startsWith('follow:')) return;
    final fireId = payload.substring('follow:'.length);
    if (fireId.isEmpty) return;
    // Fire and forget — running inside a background isolate that will
    // shut down shortly after this returns.
    _handleStop(fireId);
  }

  static Future<void> _handleStop(String fireId) async {
    await setFollowFlag(fireId, false);
    await _plugin.cancel(fireId.hashCode);
    // Unsubscribing from the FCM topic must happen in the main isolate the
    // next time the app opens, since Firebase isn't guaranteed to be
    // initialized here. The check on `isFollowing` in the FCM handler
    // prevents future notifications from resurrecting it.
  }
}
