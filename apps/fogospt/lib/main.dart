import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:fogos_api/shared/dependency_injection.dart';
import 'package:fogospt/app.dart';
import 'package:fogospt/dependency_injection/app_dependency_injection.dart';
import 'package:fogospt/dependency_injection/app_dependency_injection_data_sources.dart';
import 'package:fogospt/constants/variables.dart';
import 'package:fogospt/firebase_options.dart';
import 'package:fogospt/utils/notifications/notification_helpers.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

final messaging = FirebaseMessaging.instance;

const topic = 'warning_fogos';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Dependency Injection
  setupFogosAPIDependencyInjection();
  setupAppDependencyInjection();
  setupAppDependencyInjectionDataSources();

  /// Firebase initialize
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  NotificationHelpers().initializeNotifications();

  /// Sentry + Run App
  SentryFlutter.init(
    (options) => options.dsn = SENTRY_DSN,
    appRunner: () {
      /// Run the app
      runApp(
        const FogosApp(),
      );
    },
  );
}

Future<void> subscribeToFirebaseMessageTopics() async {
  await messaging.subscribeToTopic(topic);
}
