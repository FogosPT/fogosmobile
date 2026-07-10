import 'dart:io';

import 'package:flutter/services.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/services/live_activity_backend.dart';

/// Bridges Flutter → platform "follow fire" UI.
/// - iOS 16.2+: ActivityKit Live Activity (lock screen, Dynamic Island,
///   Apple Watch Smart Stack when paired). Push tokens are captured from
///   the activity and forwarded to the Fogos.pt backend so APNs can
///   deliver updates while the app is closed.
/// - Android: persistent ongoing notification via a receiver-backed
///   NotificationCompat.
class LiveActivityService {
  static const MethodChannel _channel = MethodChannel('pt.fogos/live_activity');
  static bool _handlerInstalled = false;

  /// Maps fireId → last known APNs push token, so we can unregister the
  /// exact token when the user stops following.
  static final Map<String, String> _tokensByFireId = {};

  static bool get _supported => Platform.isIOS || Platform.isAndroid;

  static void _ensureHandler() {
    if (_handlerInstalled) return;
    _handlerInstalled = true;
    _channel.setMethodCallHandler(_onNativeCall);
  }

  static Future<dynamic> _onNativeCall(MethodCall call) async {
    switch (call.method) {
      case 'pushTokenUpdate':
        final args = Map<String, dynamic>.from(call.arguments as Map);
        final fireId = args['fireId'] as String? ?? '';
        final token = args['pushToken'] as String? ?? '';
        final env = args['env'] as String? ?? 'production';
        if (fireId.isEmpty || token.isEmpty) return null;
        _tokensByFireId[fireId] = token;
        await LiveActivityBackend.register(
          fireId: fireId,
          pushToken: token,
          env: env,
        );
        return null;
      case 'activityEnded':
        final args = Map<String, dynamic>.from(call.arguments as Map);
        final fireId = args['fireId'] as String? ?? '';
        final token = _tokensByFireId.remove(fireId);
        if (fireId.isNotEmpty && token != null) {
          await LiveActivityBackend.unregister(fireId: fireId, pushToken: token);
        }
        return null;
    }
    return null;
  }

  static Future<bool> start(Fire fire, {double? distanceKm}) async {
    if (!_supported) return false;
    _ensureHandler();
    try {
      final result = await _channel.invokeMethod<bool>('start', _payload(fire, distanceKm));
      return result ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  static Future<void> update(Fire fire, {double? distanceKm}) async {
    if (!_supported) return;
    try {
      await _channel.invokeMethod('update', _payload(fire, distanceKm));
    } on PlatformException {} on MissingPluginException {}
  }

  static Future<void> stop(String fireId) async {
    if (!_supported) return;
    // Unregister from backend up-front so the server stops sending pushes
    // even if the native end callback is delayed.
    final token = _tokensByFireId.remove(fireId);
    if (token != null && Platform.isIOS) {
      await LiveActivityBackend.unregister(fireId: fireId, pushToken: token);
    }
    try {
      await _channel.invokeMethod('stop', {'fireId': fireId});
    } on PlatformException {} on MissingPluginException {}
  }

  static Future<bool> isActive(String fireId) async {
    if (!_supported) return false;
    try {
      final result = await _channel.invokeMethod<bool>('isActive', {'fireId': fireId});
      return result ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  static Map<String, dynamic> _payload(Fire fire, double? distanceKm) {
    final location = [fire.district, fire.city, fire.town]
        .where((s) => s.isNotEmpty)
        .join(' · ');
    final title = fire.isFire ? '🔥 ${fire.city.isEmpty ? "Incêndio" : fire.city}' : '⚠️ Incidente';
    return {
      'fireId': fire.id,
      'title': title,
      'location': location.isEmpty ? 'Incidente' : location,
      'isFire': fire.isFire,
      'statusText': _statusToString(fire.status),
      'statusColor': fire.statusColor.isEmpty ? '#FF512F' : fire.statusColor,
      'statusColorHex': fire.statusColor.isEmpty ? '#FF512F' : fire.statusColor,
      'human': fire.human,
      'terrain': fire.terrain,
      'aerial': fire.aerial,
      if (distanceKm != null) 'distanceKm': distanceKm,
    };
  }

  static String _statusToString(FireStatus status) {
    switch (status) {
      case FireStatus.dispatch:
        return 'Despacho';
      case FireStatus.significative_ocurrence:
        return 'Ocorrência Significativa';
      case FireStatus.vigilance:
        return 'Vigilância';
      case FireStatus.first_alert_dispatch:
        return 'Despacho de 1º Alerta';
      case FireStatus.arrival:
        return 'Chegada ao TO';
      case FireStatus.ongoing:
        return 'Em Curso';
      case FireStatus.in_resolution:
        return 'Em Resolução';
      case FireStatus.in_conclusion:
        return 'Conclusão';
      case FireStatus.done:
        return 'Encerrada';
      case FireStatus.false_alarm:
        return 'Falso Alarme';
      case FireStatus.false_alert:
        return 'Falso Alerta';
    }
  }
}
