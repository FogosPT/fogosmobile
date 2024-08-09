import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

mixin MessageWatcherBase {
  late void Function(RemoteMessage)? processMessage;

  Future<NotificationSettings> _requestPermissions() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    return settings;
  }

  Future<void> setupFirebaseMessaging() async {
    await _requestPermissions();

    /// Boot up initial message
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();

    if (initialMessage != null) {
      (initialMessage);
      processMessage?.call(initialMessage);
    }

    FirebaseMessaging.onMessage.listen(
      processMessage,
      cancelOnError: false,
      onDone: () {},
      onError: (error) {},
    );

    ///
  }
}
