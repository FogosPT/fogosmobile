import 'dart:io';

import 'package:flutter/services.dart';

/// Reads the raw error from FIRMessaging on iOS when the Flutter plugin's
/// getToken() returns null with the useless "An unknown error has
/// occurred" message. The underlying NSError carries the real cause
/// (invalid APNs Auth Key, revoked key, FCM API disabled, etc.).
class FcmDebugBridge {
  static const _channel = MethodChannel('pt.fogos/fcm_debug');

  static Future<Map<String, Object?>?> fetchToken() async {
    if (!Platform.isIOS) return null;
    try {
      final result = await _channel.invokeMethod<Map<Object?, Object?>>('fetchToken');
      if (result == null) return null;
      return result.map((k, v) => MapEntry(k.toString(), v));
    } on PlatformException catch (e) {
      return {'error': e.message ?? e.code, 'domain': 'PlatformException'};
    } on MissingPluginException {
      return null;
    }
  }
}
