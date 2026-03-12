import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fogosmobile/constants/endpoints.dart';
import 'package:fogosmobile/middleware/shared_preferences_manager.dart';
import 'package:fogosmobile/services/nearby_notification_service.dart';
import 'package:fogosmobile/utils/network_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Handles one-time FCM topic migration on app upgrade.
///
/// When the app upgrades, stale legacy FCM topic subscriptions may remain
/// (e.g. "mobile-ios-<key>", district names like "Lisboa"). These cause
/// users to receive notifications they didn't subscribe to.
///
/// This service detects the first run after upgrade, deletes the FCM token
/// (which clears ALL server-side topic subscriptions), gets a fresh token,
/// and re-subscribes only the topics the user actually has enabled.
class FcmMigrationService {
  // Bump this when you need to force a new migration
  static const int _currentMigrationVersion = 2;
  static const String _migrationKey = 'fcm_migration_version';

  /// Run migration if needed. Should be called early in app startup,
  /// after Firebase is initialized and permission is granted.
  static Future<void> migrateIfNeeded(FirebaseMessaging messaging) async {
    final prefs = await SharedPreferences.getInstance();
    final lastMigration = prefs.getInt(_migrationKey) ?? 0;

    if (lastMigration >= _currentMigrationVersion) return;

    print('FcmMigration: Running migration v$_currentMigrationVersion (last: v$lastMigration)');

    try {
      // Explicitly unsubscribe from all known legacy topics first.
      // deleteToken() does NOT clear topic subscriptions on FCM servers.
      await _unsubscribeAllLegacy(messaging, prefs);

      // Delete and re-create token for a clean slate
      await messaging.deleteToken();
      final newToken = await messaging.getToken();
      print('FcmMigration: New token: $newToken');

      // Re-subscribe only active topics
      await _resubscribeDistricts(messaging, prefs);
      await _resubscribeOther(messaging, prefs);
      await _resubscribeNearby(messaging, prefs);

      // Mark migration as complete
      await prefs.setInt(_migrationKey, _currentMigrationVersion);
      print('FcmMigration: Migration complete');
    } catch (e) {
      print('FcmMigration: Migration failed: $e');
      // Don't mark as complete — will retry next launch
    }
  }

  static String _prefix() {
    // Match NotificationTool prefix logic
    return '';
  }

  static String _unifiedTopic(String key) {
    if (key.startsWith('all-') && RegExp(r'^\d{6}$').hasMatch(key.substring(4))) {
      return 'district-$key';
    }
    if (RegExp(r'^\d{6}$').hasMatch(key)) {
      return 'district-$key';
    }
    if (key == 'important') return 'incident-important';
    return key;
  }

  static String _legacyTopic(String key) {
    return Platform.isIOS ? 'mobile-ios-$key' : 'mobile-android-$key';
  }

  /// Explicitly unsubscribe from all known legacy topics.
  /// This is necessary because deleteToken() does NOT clear topic subscriptions.
  static Future<void> _unsubscribeAllLegacy(
      FirebaseMessaging messaging, SharedPreferences prefs) async {
    try {
      final response = await get(Endpoints.getLocations);
      if (response == null) return;
      final locations = response.data['rows'] as List;

      for (var location in locations) {
        final key = location['key'] as String;
        // Legacy per-platform topics
        for (var prefix in ['mobile-ios-', 'mobile-android-', 'web-']) {
          await messaging.unsubscribeFromTopic('$prefix$key');
        }
        // Unified district topic (in case user unsubscribed locally but FCM kept it)
        await messaging.unsubscribeFromTopic('district-$key');
        await messaging.unsubscribeFromTopic('district-all-$key');
      }

      // Legacy global topics
      for (var key in ['important', 'warnings', 'planes']) {
        for (var prefix in ['mobile-ios-', 'mobile-android-', 'web-', 'incident-']) {
          await messaging.unsubscribeFromTopic('$prefix$key');
        }
        await messaging.unsubscribeFromTopic(key);
      }

      // Nearby
      await messaging.unsubscribeFromTopic('incident-nearby');

      print('FcmMigration: Unsubscribed from all legacy topics');
    } catch (e) {
      print('FcmMigration: Failed to unsubscribe legacy topics: $e');
    }
  }

  static Future<void> _resubscribeDistricts(
      FirebaseMessaging messaging, SharedPreferences prefs) async {
    try {
      final response = await get(Endpoints.getLocations);
      if (response == null) return;
      final locations = response.data['rows'] as List;

      final appPrefs = SharedPreferencesManager.preferences;

      for (var location in locations) {
        final key = location['key'] as String;

        // Fires-only district subscription
        final value = appPrefs.getInt(key) ?? 0;
        if (value != 0) {
          await messaging.subscribeToTopic(_unifiedTopic(key));
          await messaging.subscribeToTopic(_legacyTopic(key));
          print('FcmMigration: Re-subscribed district $key');
        }

        // All-incidents district subscription
        final allKey = 'all-$key';
        final allValue = prefs.getInt(allKey) ?? 0;
        if (allValue != 0) {
          await messaging.subscribeToTopic(_unifiedTopic(allKey));
          print('FcmMigration: Re-subscribed district-all $key');
        }
      }
    } catch (e) {
      print('FcmMigration: Failed to re-subscribe districts: $e');
    }
  }

  static Future<void> _resubscribeOther(
      FirebaseMessaging messaging, SharedPreferences prefs) async {
    final appPrefs = SharedPreferencesManager.preferences;

    for (var key in ['important', 'warnings', 'planes']) {
      final value = appPrefs.getInt(key) ?? 0;
      if (value != 0) {
        await messaging.subscribeToTopic(_unifiedTopic(key));
        await messaging.subscribeToTopic(_legacyTopic(key));
        print('FcmMigration: Re-subscribed $key');
      }
    }
  }

  static Future<void> _resubscribeNearby(
      FirebaseMessaging messaging, SharedPreferences prefs) async {
    final enabled = prefs.getBool(NearbyPrefs.nearbyEnabled) ?? false;
    if (enabled) {
      await messaging.subscribeToTopic('incident-nearby');
      print('FcmMigration: Re-subscribed nearby');
    }
  }
}
