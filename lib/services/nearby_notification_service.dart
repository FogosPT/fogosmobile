import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fogosmobile/utils/haversine.dart';

/// Keys for SharedPreferences — all nearby data stays on-device.
/// Filter mode for nearby notifications.
enum NearbyFilter {
  firesOnly,   // Only fire-related incidents
  allIncidents // All incident types
}

class NearbyPrefs {
  static const nearbyEnabled = 'nearby_enabled';
  static const nearbyRadiusKm = 'nearby_radius_km';
  static const nearbyLat = 'nearby_lat';
  static const nearbyLng = 'nearby_lng';
  static const nearbyNotifiedIds = 'nearby_notified_ids';
  static const nearbyFilter = 'nearby_filter'; // 'fires' or 'all'

  static const int defaultRadiusKm = 50;
  static const List<int> radiusOptions = [5, 10, 25, 50, 100];
}

/// Handles the local proximity check for incoming FCM data messages.
/// No user location ever leaves the device.
class NearbyNotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  /// Callback for when user taps a nearby notification.
  /// Receives the fireId as payload.
  static void Function(String fireId)? onNotificationTap;

  /// Initialize local notifications plugin. Call once at app start.
  static Future<void> init() async {
    if (_initialized) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty && onNotificationTap != null) {
          onNotificationTap!(payload);
        }
      },
    );
    _initialized = true;
  }

  /// Process an incoming FCM data message.
  /// Returns true if a local notification was shown.
  static Future<bool> handleMessage(RemoteMessage message) async {
    if (message.data['type'] != 'nearby') return false;

    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(NearbyPrefs.nearbyEnabled) ?? false;
    if (!enabled) return false;

    final userLat = prefs.getDouble(NearbyPrefs.nearbyLat);
    final userLng = prefs.getDouble(NearbyPrefs.nearbyLng);
    if (userLat == null || userLng == null) return false;

    final fireLat = double.tryParse(message.data['lat'] ?? '');
    final fireLng = double.tryParse(message.data['lng'] ?? '');
    if (fireLat == null || fireLng == null) return false;

    // Check filter: fires only or all incidents
    final filterStr = prefs.getString(NearbyPrefs.nearbyFilter) ?? 'fires';
    if (filterStr == 'fires') {
      final isFire = message.data['isFire'] ?? '0';
      if (isFire != '1') return false;
    }

    final radiusKm = prefs.getInt(NearbyPrefs.nearbyRadiusKm) ??
        NearbyPrefs.defaultRadiusKm;
    final distance = haversineKm(userLat, userLng, fireLat, fireLng);

    if (distance > radiusKm) return false;

    // Deduplicate — don't notify twice for the same incident
    final fireId = message.data['fireId'] ?? '';
    final notifiedIds =
        prefs.getStringList(NearbyPrefs.nearbyNotifiedIds) ?? [];
    if (notifiedIds.contains(fireId)) return false;

    // Keep last 200 IDs to avoid unbounded growth
    notifiedIds.add(fireId);
    if (notifiedIds.length > 200) {
      notifiedIds.removeRange(0, notifiedIds.length - 200);
    }
    await prefs.setStringList(NearbyPrefs.nearbyNotifiedIds, notifiedIds);

    // Show local notification
    final isFire = (message.data['isFire'] ?? '0') == '1';
    await _showNotification(
      fireId: fireId,
      distance: distance,
      location: message.data['location'] ?? '',
      nature: message.data['nature'] ?? '',
      isFire: isFire,
    );

    return true;
  }

  static Future<void> _showNotification({
    required String fireId,
    required double distance,
    required String location,
    required String nature,
    required bool isFire,
  }) async {
    // Use hashCode of fireId for notification ID to allow updates
    final notificationId = fireId.hashCode;

    final channelName = Intl.message(
      'Incêndios Próximos',
      name: 'nearbyChannelName',
      desc: 'Notification channel name for nearby fires',
    );
    final channelDesc = Intl.message(
      'Notificações de incêndios próximos da sua localização',
      name: 'nearbyChannelDescription',
      desc: 'Notification channel description for nearby fires',
    );

    final androidDetails = AndroidNotificationDetails(
      'nearby_fires',
      channelName,
      channelDescription: channelDesc,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final distText = distance < 1
        ? '${(distance * 1000).round()} m'
        : '${distance.round()} km';

    final title = isFire
        ? '🔥 Incêndio a $distText de ti'
        : '⚠️ Incidente a $distText de ti';
    final body = nature.isNotEmpty ? '$location — $nature' : location;

    // Encode fireId and isFire flag so tap handler can route correctly
    final payload = isFire ? 'fire:$fireId' : 'other:$fireId';
    await _localNotifications.show(notificationId, title, body, details,
        payload: payload);
  }

  static DateTime? _lastLocationFetch;
  static const Duration _minFetchInterval = Duration(minutes: 10);

  /// Update the stored user location. Call periodically.
  ///
  /// Guards against the OS location-services prompt loop:
  /// - skips when location services are disabled (would trigger the system
  ///   "enable location" dialog on each call);
  /// - skips when permission is denied (no prompt here — only the explicit
  ///   opt-in screen in settings should prompt);
  /// - throttles so app-resume churn doesn't re-trigger anything.
  static Future<void> updateStoredLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(NearbyPrefs.nearbyEnabled) ?? false;
    if (!enabled) return;

    final now = DateTime.now();
    if (_lastLocationFetch != null &&
        now.difference(_lastLocationFetch!) < _minFetchInterval) {
      return;
    }

    try {
      final serviceOn = await Geolocator.isLocationServiceEnabled();
      if (!serviceOn) {
        _lastLocationFetch = now;
        return;
      }

      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _lastLocationFetch = now;
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 10),
        ),
      );

      _lastLocationFetch = now;
      await prefs.setDouble(NearbyPrefs.nearbyLat, position.latitude);
      await prefs.setDouble(NearbyPrefs.nearbyLng, position.longitude);
    } catch (_) {
      _lastLocationFetch = now;
    }
  }

  /// Subscribe/unsubscribe from the nearby FCM topic.
  static Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(NearbyPrefs.nearbyEnabled, enabled);

    final messaging = FirebaseMessaging.instance;
    if (enabled) {
      await messaging.subscribeToTopic('incident-nearby');
      await updateStoredLocation();
    } else {
      await messaging.unsubscribeFromTopic('incident-nearby');
    }
  }

  /// Update the radius preference.
  static Future<void> setRadius(int km) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(NearbyPrefs.nearbyRadiusKm, km);
  }

  /// Update the incident filter preference.
  static Future<void> setFilter(NearbyFilter filter) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      NearbyPrefs.nearbyFilter,
      filter == NearbyFilter.firesOnly ? 'fires' : 'all',
    );
  }
}
