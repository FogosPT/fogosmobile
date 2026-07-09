import 'dart:io';

import 'package:flutter/services.dart';

/// Bridges preferences and location to a paired Apple Watch companion app.
///
/// The watch talks to source.fogos.pt directly; this service only ships
/// preference state (radius, filter, subscribed fires, last known location)
/// via WCSession application context. No-op on non-iOS platforms.
class WatchBridgeService {
  static const MethodChannel _channel = MethodChannel('pt.fogos/watch_bridge');

  static bool get _supported => Platform.isIOS;

  static Future<void> sendLocation(double lat, double lng) async {
    if (!_supported) return;
    await _send({'lat': lat, 'lng': lng});
  }

  static Future<void> sendRadius(int km) async {
    if (!_supported) return;
    await _send({'radiusKm': km});
  }

  static Future<void> sendFilter(String filter) async {
    if (!_supported) return;
    await _send({'filter': filter});
  }

  static Future<void> sendSubscribedFires(List<String> ids) async {
    if (!_supported) return;
    await _send({'subscribedFires': ids});
  }

  static Future<void> sendAll({
    double? lat,
    double? lng,
    int? radiusKm,
    String? filter,
    List<String>? subscribedFires,
  }) async {
    if (!_supported) return;
    final payload = <String, dynamic>{};
    if (lat != null) payload['lat'] = lat;
    if (lng != null) payload['lng'] = lng;
    if (radiusKm != null) payload['radiusKm'] = radiusKm;
    if (filter != null) payload['filter'] = filter;
    if (subscribedFires != null) payload['subscribedFires'] = subscribedFires;
    if (payload.isEmpty) return;
    await _send(payload);
  }

  static Future<bool> isPaired() async {
    if (!_supported) return false;
    try {
      final result = await _channel.invokeMethod<bool>('isPaired');
      return result ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  static Future<void> _send(Map<String, dynamic> payload) async {
    try {
      await _channel.invokeMethod('sendContext', payload);
    } on PlatformException {
      // Watch may be unpaired or session inactive — safe to ignore.
    } on MissingPluginException {
      // Bridge not registered (older iOS build) — safe to ignore.
    }
  }
}
