package com.tomahock.fogos

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

/// The "seguir incêndio" feature and its ongoing notification are
/// managed entirely from Dart via `flutter_local_notifications`, so both
/// foreground and FCM background isolate paths share the same code.
///
/// We do register a small native bridge for the incident-photo compass —
/// TYPE_ROTATION_VECTOR is Android's fused, Kalman-filtered orientation
/// source and produces a far more stable azimuth than the raw
/// accelerometer+magnetometer feed the Dart side used previously.
class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        OrientationBridge.get(this).register(flutterEngine.dartExecutor.binaryMessenger)
    }
}
