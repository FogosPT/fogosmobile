package com.tomahock.fogos

import io.flutter.embedding.android.FlutterActivity

/// Nothing custom to configure — the "seguir incêndio" feature and its
/// ongoing notification are managed entirely from Dart via
/// `flutter_local_notifications`, so both foreground and FCM background
/// isolate paths share the same code.
class MainActivity : FlutterActivity()
