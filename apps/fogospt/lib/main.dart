import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:fogos_api/shared/dependency_injection.dart';
import 'package:fogospt/app.dart';
import 'package:fogospt/firebase_options.dart';
import 'package:fogospt/utils/notifications/notification_helpers.dart';

final messaging = FirebaseMessaging.instance;

const topic = 'warning_fogos';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Dependency Injection
  setupFogosAPIDependencyInjection();

  // Firebase initialize
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // configureFirebaseMessaging();
  NotificationHelpers().initializeNotifications();

  runApp(const FogosApp());
}

Future<void> subscribeToFirebaseMessageTopics() async {
  await messaging.subscribeToTopic(topic);
}
