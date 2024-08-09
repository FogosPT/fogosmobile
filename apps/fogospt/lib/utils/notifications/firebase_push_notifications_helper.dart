import 'package:firebase_messaging/firebase_messaging.dart';

// final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

Future<void> configureFirebaseMessaging() async {
  // final settings = await _firebaseMessaging.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );

  // if (kDebugMode) {
  //   print('Permission granted: ${settings.authorizationStatus}');
  // }

  // /// Listen - onMessage
  // FirebaseMessaging.onMessage.listen((message) {
  // });

  /// Listen - onBackgroundMessage
  FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

  /// Get the token
  // _firebaseMessaging.getToken().then((token) {
  //   if (kDebugMode) {
  //     print('Registration Token=$token');
  //     // GlobalVariable.fcToken.value = token!;

  //     // localStore().saveStringToPrefs("tokemFCN", token.toString());
  //     // Send the token to your server if needed.
  //   }
  // });
}

Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  // Handle background messages here.
  print("Handling background message: ${message.notification?.title}");
}
