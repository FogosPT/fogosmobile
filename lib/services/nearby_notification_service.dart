import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fogosmobile/utils/haversine.dart';
import 'package:fogosmobile/services/watch_bridge_service.dart';

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

  static const String _nearbyLocationTimestamp = 'nearby_location_ts';

  /// Max age of the stored location before we ask the OS for a fresh fix.
  static const Duration _staleAfter = Duration(hours: 6);

  /// Min spacing between active GPS requests within the same process.
  static const Duration _minActiveFetchInterval = Duration(minutes: 30);
  static DateTime? _lastActiveFetch;

  /// Refresh the stored user location, preferring cheap sources.
  ///
  /// Strategy (cheapest → most expensive):
  /// 1. If the stored location is fresher than [_staleAfter], do nothing.
  /// 2. Otherwise try `getLastKnownPosition()` — no GPS wake-up, free.
  /// 3. Only as a last resort, ask for a fresh fix, and at most once every
  ///    [_minActiveFetchInterval] per process.
  ///
  /// Never triggers a system prompt: skips silently when location services
  /// are off or permission is denied (the settings screen is the only place
  /// that should prompt).
  static Future<void> updateStoredLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(NearbyPrefs.nearbyEnabled) ?? false;
    if (!enabled) return;

    final storedTs = prefs.getInt(_nearbyLocationTimestamp);
    final hasStored = prefs.getDouble(NearbyPrefs.nearbyLat) != null &&
        prefs.getDouble(NearbyPrefs.nearbyLng) != null;
    if (hasStored && storedTs != null) {
      final age = DateTime.now().millisecondsSinceEpoch - storedTs;
      if (age < _staleAfter.inMilliseconds) return;
    }

    if (!await Geolocator.isLocationServiceEnabled()) return;
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    try {
      final last = await Geolocator.getLastKnownPosition();
      if (last != null) {
        await _persistPosition(prefs, last.latitude, last.longitude);
        return;
      }
    } catch (_) {}

    final now = DateTime.now();
    if (_lastActiveFetch != null &&
        now.difference(_lastActiveFetch!) < _minActiveFetchInterval) {
      return;
    }
    _lastActiveFetch = now;

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 15),
        ),
      );
      await _persistPosition(prefs, position.latitude, position.longitude);
    } catch (_) {}
  }

  static Future<void> _persistPosition(
      SharedPreferences prefs, double lat, double lng) async {
    await prefs.setDouble(NearbyPrefs.nearbyLat, lat);
    await prefs.setDouble(NearbyPrefs.nearbyLng, lng);
    await prefs.setInt(
        _nearbyLocationTimestamp, DateTime.now().millisecondsSinceEpoch);
    await WatchBridgeService.sendLocation(lat, lng);
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
    await WatchBridgeService.sendRadius(km);
  }

  /// Update the incident filter preference.
  static Future<void> setFilter(NearbyFilter filter) async {
    final prefs = await SharedPreferences.getInstance();
    final value = filter == NearbyFilter.firesOnly ? 'fires' : 'all';
    await prefs.setString(NearbyPrefs.nearbyFilter, value);
    await WatchBridgeService.sendFilter(value);
  }

  /// Push the currently persisted nearby prefs and location to the watch.
  /// Safe to call on startup — no-op on non-iOS or when nothing is stored.
  static Future<void> syncToWatch() async {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble(NearbyPrefs.nearbyLat);
    final lng = prefs.getDouble(NearbyPrefs.nearbyLng);
    final radius = prefs.getInt(NearbyPrefs.nearbyRadiusKm);
    final filter = prefs.getString(NearbyPrefs.nearbyFilter);
    final subscribedFires = prefs.getStringList('subscribedFires') ?? [];
    await WatchBridgeService.sendAll(
      lat: lat,
      lng: lng,
      radiusKm: radius,
      filter: filter,
      subscribedFires: subscribedFires,
    );
  }
}
