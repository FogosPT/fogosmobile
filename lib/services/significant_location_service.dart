import 'dart:io';

import 'package:flutter/services.dart';

/// Thin wrapper around the iOS Significant-Change Location bridge. On
/// Android it is a no-op — Android already has the Fused Location Provider
/// pattern and the current polling on lifecycle resume is enough there.
class SignificantLocationService {
  static const _channel = MethodChannel('pt.fogos/significant_location');

  static bool get _supported => Platform.isIOS;

  static Future<void> start() async {
    if (!_supported) return;
    try {
      await _channel.invokeMethod('start');
    } on PlatformException {} on MissingPluginException {}
  }

  static Future<void> stop() async {
    if (!_supported) return;
    try {
      await _channel.invokeMethod('stop');
    } on PlatformException {} on MissingPluginException {}
  }

  /// Copy the nearby toggle/radius/filter into the shared App Group so the
  /// Notification Service Extension reads the same values.
  static Future<void> mirrorSettings({
    bool? enabled,
    int? radiusKm,
    String? filter,
  }) async {
    if (!_supported) return;
    try {
      await _channel.invokeMethod('mirrorSettings', {
        if (enabled != null) 'enabled': enabled,
        if (radiusKm != null) 'radiusKm': radiusKm,
        if (filter != null) 'filter': filter,
      });
    } on PlatformException {} on MissingPluginException {}
  }

  /// Write a location straight to the App Group. Used when the Flutter
  /// side resolves coordinates by other means (Geolocator fallback) so the
  /// Notification Service Extension has data to work with immediately.
  static Future<void> writeLocation(double lat, double lng) async {
    if (!_supported) return;
    try {
      await _channel.invokeMethod('writeLocation', {'lat': lat, 'lng': lng});
    } on PlatformException {} on MissingPluginException {}
  }

  /// Returns the last significant-change coordinate the OS delivered, or
  /// null if none yet. `ts` is a millisecond epoch.
  static Future<({double lat, double lng, int ts})?> getLast() async {
    if (!_supported) return null;
    try {
      final result = await _channel.invokeMethod<Map<Object?, Object?>>('getLast');
      if (result == null) return null;
      final lat = (result['lat'] as num?)?.toDouble();
      final lng = (result['lng'] as num?)?.toDouble();
      final ts = (result['ts'] as num?)?.toInt() ?? 0;
      if (lat == null || lng == null) return null;
      return (lat: lat, lng: lng, ts: ts);
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }
}
