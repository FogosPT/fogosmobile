import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

enum OrientationAccuracy { uncalibrated, low, medium, high, unknown }

class OrientationEvent {
  /// Camera azimuth in degrees clockwise from north, [0, 360). When
  /// [isTrueNorth] is true this is corrected for local magnetic declination,
  /// otherwise it is magnetic north.
  final double headingDeg;

  /// Elevation of the camera axis above horizontal, in degrees. Positive
  /// when the phone is tilted back (camera aimed above the horizon).
  final double pitchDeg;

  final OrientationAccuracy accuracy;
  final bool isTrueNorth;

  const OrientationEvent({
    required this.headingDeg,
    required this.pitchDeg,
    required this.accuracy,
    required this.isTrueNorth,
  });
}

/// Bridges to the native fused-orientation source:
///   iOS     → CMDeviceMotion in .xTrueNorthZVertical reference frame.
///   Android → SensorManager TYPE_ROTATION_VECTOR + GeomagneticField
///             declination correction (when the app has pushed a location).
///
/// The service exposes a single broadcast stream. Callers should still be
/// prepared for the stream to fail — on platforms/devices without a full
/// motion sensor stack the caller must fall back to its own raw-sensor
/// heading pipeline (see `ar_compass_math.dart`).
class OrientationService {
  static const _channel = MethodChannel('pt.fogos/orientation');
  static bool _handlerInstalled = false;

  static final StreamController<OrientationEvent> _controller =
      StreamController<OrientationEvent>.broadcast(
    onListen: _ensureHandler,
  );

  static Stream<OrientationEvent> get events => _controller.stream;

  static bool get _supported => Platform.isIOS || Platform.isAndroid;

  static void _ensureHandler() {
    if (_handlerInstalled) return;
    _handlerInstalled = true;
    _channel.setMethodCallHandler((call) async {
      if (call.method != 'orientation') return null;
      final args = Map<String, dynamic>.from(call.arguments as Map);
      final heading = (args['headingDeg'] as num?)?.toDouble();
      final pitch = (args['pitchDeg'] as num?)?.toDouble();
      if (heading == null || pitch == null) return null;
      final accuracy = _parseAccuracy(args['accuracy'] as String?);
      final isTrueNorth = args['isTrueNorth'] as bool? ?? false;
      _controller.add(OrientationEvent(
        headingDeg: heading,
        pitchDeg: pitch,
        accuracy: accuracy,
        isTrueNorth: isTrueNorth,
      ));
      return null;
    });
  }

  static OrientationAccuracy _parseAccuracy(String? s) {
    switch (s) {
      case 'uncalibrated':
        return OrientationAccuracy.uncalibrated;
      case 'low':
        return OrientationAccuracy.low;
      case 'medium':
        return OrientationAccuracy.medium;
      case 'high':
        return OrientationAccuracy.high;
      default:
        return OrientationAccuracy.unknown;
    }
  }

  static Future<bool> isAvailable() async {
    if (!_supported) return false;
    try {
      final r = await _channel.invokeMethod<bool>('isAvailable');
      return r ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  /// Begin streaming orientation events. Safe to call repeatedly; the
  /// native side deduplicates.
  static Future<bool> start() async {
    if (!_supported) return false;
    _ensureHandler();
    try {
      final r = await _channel.invokeMethod<bool>('start');
      return r ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  static Future<void> stop() async {
    if (!_supported) return;
    try {
      await _channel.invokeMethod('stop');
    } on PlatformException {} on MissingPluginException {}
  }

  /// Push the current GPS location so the Android bridge can compute
  /// magnetic declination for true-north correction. No-op on iOS —
  /// CMDeviceMotion resolves declination itself in
  /// `.xTrueNorthZVertical` mode.
  static Future<void> setLocation(double lat, double lng, {double? altitude}) async {
    if (!Platform.isAndroid) return;
    try {
      await _channel.invokeMethod('setLocation', {
        'lat': lat,
        'lng': lng,
        if (altitude != null) 'alt': altitude,
      });
    } on PlatformException {} on MissingPluginException {}
  }
}
