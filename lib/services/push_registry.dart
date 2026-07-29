import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tracks every FCM topic the app has subscribed to and every APNs push token
/// registered with the backend for iOS Live Activities. On `onTokenRefresh`
/// (or when we detect the FCM token diverged from the last known one) we
/// replay all subscriptions against the new token — otherwise topic delivery
/// silently stops after Apple/Google rotate the underlying registration.
class PushRegistry {
  static const String _kTopics = 'push_active_topics';
  static const String _kLastToken = 'push_last_fcm_token';
  static const String _kLastRefreshMs = 'push_last_token_refresh_ms';
  static const String _kLastMessageMs = 'push_last_message_ms';
  static const String _kAuthStatus = 'push_auth_status';
  static const String _kBackgroundRefresh = 'push_background_refresh_status';

  static bool _tokenListenerInstalled = false;
  static void Function()? _onResubscribe;

  /// Register once at app start. `onResubscribe` runs after every FCM token
  /// rotation so callers can re-register per-fire APNs Live Activity tokens
  /// with the backend (topics are handled here directly).
  static void installTokenRefreshListener({void Function()? onResubscribe}) {
    _onResubscribe = onResubscribe;
    if (_tokenListenerInstalled) return;
    _tokenListenerInstalled = true;
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kLastToken, token);
      await prefs.setInt(
          _kLastRefreshMs, DateTime.now().millisecondsSinceEpoch);
      await resubscribeAll();
      _onResubscribe?.call();
    });
  }

  /// Compare the current FCM token against what we saw last. Returns true if
  /// it changed (and stores the new one). Call on every app foreground —
  /// second line of defence if `onTokenRefresh` didn't fire.
  ///
  /// On iOS the APNs token binding is asynchronous, so the first getToken()
  /// call right after cold-start often returns null even though APNs was
  /// registered. We retry with a small backoff before giving up.
  static Future<bool> verifyToken() async {
    String? current;
    for (var attempt = 0; attempt < 4; attempt++) {
      try {
        current = await FirebaseMessaging.instance.getToken();
        if (current != null && current.isNotEmpty) break;
      } catch (_) {}
      await Future.delayed(Duration(milliseconds: 500 * (attempt + 1)));
    }
    if (current == null || current.isEmpty) return false;
    final prefs = await SharedPreferences.getInstance();
    final last = prefs.getString(_kLastToken);
    if (last == current) return false;
    await prefs.setString(_kLastToken, current);
    await prefs.setInt(_kLastRefreshMs, DateTime.now().millisecondsSinceEpoch);
    await resubscribeAll();
    _onResubscribe?.call();
    return true;
  }

  /// Force a fresh FCM registration token by deleting the current one and
  /// asking Firebase to derive a new one from the APNs token. Exposed for
  /// the diagnostics UI when APNs is present but FCM is stuck. Returns a
  /// [ForceRefreshResult] so the UI can show the actual server-side error
  /// (usually points to a missing APNs Auth Key in the Firebase project).
  static Future<ForceRefreshResult> forceRefreshToken() async {
    String? deleteError;
    try {
      await FirebaseMessaging.instance.deleteToken();
    } catch (e) {
      deleteError = e.toString();
    }
    String? fresh;
    String? lastError;
    for (var attempt = 0; attempt < 4; attempt++) {
      try {
        fresh = await FirebaseMessaging.instance.getToken();
        if (fresh != null && fresh.isNotEmpty) {
          lastError = null;
          break;
        }
        lastError = 'getToken returned null (attempt ${attempt + 1})';
      } catch (e) {
        lastError = e.toString();
      }
      await Future.delayed(Duration(milliseconds: 500 * (attempt + 1)));
    }
    final prefs = await SharedPreferences.getInstance();
    if (fresh != null && fresh.isNotEmpty) {
      await prefs.setString(_kLastToken, fresh);
      await prefs.setInt(
          _kLastRefreshMs, DateTime.now().millisecondsSinceEpoch);
      await resubscribeAll();
      _onResubscribe?.call();
    }
    if (lastError != null || deleteError != null) {
      await prefs.setString(
          _kLastForceError,
          [
            if (deleteError != null) 'delete: $deleteError',
            if (lastError != null) 'get: $lastError',
          ].join(' | '));
    } else {
      await prefs.remove(_kLastForceError);
    }
    return ForceRefreshResult(
      token: fresh,
      deleteError: deleteError,
      getError: lastError,
    );
  }

  static const String _kLastForceError = 'push_last_force_error';

  /// Subscribe to a topic and record it locally so we can replay after a
  /// token rotation.
  static Future<void> subscribe(String topic) async {
    if (topic.isEmpty) return;
    try {
      await FirebaseMessaging.instance.subscribeToTopic(topic);
    } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    final set = (prefs.getStringList(_kTopics) ?? const <String>[]).toSet();
    set.add(topic);
    await prefs.setStringList(_kTopics, set.toList());
  }

  /// Unsubscribe and forget the topic.
  static Future<void> unsubscribe(String topic) async {
    if (topic.isEmpty) return;
    try {
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    final set = (prefs.getStringList(_kTopics) ?? const <String>[]).toSet();
    set.remove(topic);
    await prefs.setStringList(_kTopics, set.toList());
  }

  /// Re-issue subscribeToTopic for every tracked topic. Used after a token
  /// rotation, since FCM anchors subscriptions to the previous token.
  static Future<void> resubscribeAll() async {
    final prefs = await SharedPreferences.getInstance();
    final topics = prefs.getStringList(_kTopics) ?? const <String>[];
    final messaging = FirebaseMessaging.instance;
    for (final topic in topics) {
      try {
        await messaging.subscribeToTopic(topic);
      } catch (_) {}
    }
  }

  /// Seed the local mirror from a set that was computed elsewhere (e.g. by
  /// the migration service that already knows the full picture).
  static Future<void> seed(Iterable<String> topics) async {
    final prefs = await SharedPreferences.getInstance();
    final set = (prefs.getStringList(_kTopics) ?? const <String>[]).toSet();
    set.addAll(topics.where((t) => t.isNotEmpty));
    await prefs.setStringList(_kTopics, set.toList());
  }

  static Future<List<String>> activeTopics() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_kTopics) ?? const <String>[];
  }

  static Future<void> recordMessageReceived() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kLastMessageMs, DateTime.now().millisecondsSinceEpoch);
  }

  static Future<void> recordAuthStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAuthStatus, status);
  }

  static Future<PushDiagnostics> diagnostics() async {
    final prefs = await SharedPreferences.getInstance();
    String? token;
    String? fcmError;
    try {
      token = await FirebaseMessaging.instance.getToken();
    } catch (e) {
      fcmError = e.toString();
    }
    String? apnsToken;
    try {
      apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    } catch (_) {}
    return PushDiagnostics(
      fcmToken: token,
      apnsToken: apnsToken,
      lastKnownToken: prefs.getString(_kLastToken),
      lastTokenRefreshMs: prefs.getInt(_kLastRefreshMs),
      lastMessageMs: prefs.getInt(_kLastMessageMs),
      authStatus: prefs.getString(_kAuthStatus),
      backgroundRefresh: prefs.getString(_kBackgroundRefresh),
      topics: prefs.getStringList(_kTopics) ?? const <String>[],
      lastFcmError: fcmError ?? prefs.getString(_kLastForceError),
    );
  }

  static Future<void> recordBackgroundRefresh(String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kBackgroundRefresh, status);
  }
}

class PushDiagnostics {
  final String? fcmToken;
  final String? apnsToken; // iOS-only; null on Android
  final String? lastKnownToken;
  final int? lastTokenRefreshMs;
  final int? lastMessageMs;
  final String? authStatus;
  final String? backgroundRefresh;
  final List<String> topics;
  final String? lastFcmError;

  const PushDiagnostics({
    required this.fcmToken,
    required this.apnsToken,
    required this.lastKnownToken,
    required this.lastTokenRefreshMs,
    required this.lastMessageMs,
    required this.authStatus,
    required this.backgroundRefresh,
    required this.topics,
    this.lastFcmError,
  });
}

class ForceRefreshResult {
  final String? token;
  final String? deleteError;
  final String? getError;
  const ForceRefreshResult({this.token, this.deleteError, this.getError});
  bool get success => token != null && token!.isNotEmpty;
}
