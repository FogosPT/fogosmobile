import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelpers {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initializeNotifications() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // payload
    var initializationSettingsIos = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      // onDidReceiveLocalNotification:
      //     (int id, String? title, String? body, String? payload) async {
      //   //
      //   print(
      //       'onDidReceiveLocalNotification\nid: $id\ntitle: $title\nbody: $body\npayload: $payload');
      // },

    );

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIos,
    );

    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (notificationResponse) async {
        print('onDidReceiveNotificationResponse - $notificationResponse');
      },
      onDidReceiveBackgroundNotificationResponse: (notificationResponse) async {
        print(
            'onDidReceiveBackgroundNotificationResponse - $notificationResponse');
      },
    );
  }

  @pragma('vm:entry-point')
  void notificationTapBackground(NotificationResponse notificationResponse) {
    print('notificationTapBackground - $notificationResponse');
  }

  static Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification!.android!.channelId ?? "fogospt",
      message.notification!.android!.channelId ?? "fogospt",
      importance: Importance.max,
      showBadge: true,
      playSound: true,
    );

    AndroidNotificationDetails androidPlatformChannelDetails =
        AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: "Fogos Notifications",
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      ticker: 'fogos ticker',
      sound: channel.sound,
    );

    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidPlatformChannelDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(
      Duration.zero,
      () async {
        try {
          await notificationsPlugin.show(
            message.hashCode,
            message.notification!.title,
            message.notification!.body,
            notificationDetails,
            payload: message.data.toString(),
          );
        } on Exception catch (e) {
          print(e.toString());
        }
      },
    );
  }
}

typedef DidReceiveLocalNotification = void Function(
    int id, String? title, String? body, String? payload);
