// import 'dart:math';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationServices {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   void requestNotificationPermission() async {
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: true,
//       badge: true,
//       carPlay: true,
//       criticalAlert: true,
//       provisional: true,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('user given permission');
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       print('user given provisional permission');
//     } else {
//       print('User denied permission');
//     }
//   }

//   void initNotification(BuildContext context, RemoteMessage message) async {
//     var androidInitializationSettings = AndroidInitializationSettings(
//       '@mipmap/ic_launcher',
//     );
//     var initializationSettings = InitializationSettings(
//       android: androidInitializationSettings,
//     );

//     await _flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (payload) {},
//     );
//   }

//   void firebaseInit() {
//     FirebaseMessaging.onMessage.listen((message) {
//       if (kDebugMode) {
//         print(message.notification!.title.toString());
//         print(message.notification!.body.toString());
//       }

//       showNotification(message);
//     });
//   }

//   Future<void> showNotification(RemoteMessage message) async {
//     AndroidNotificationChannel channel = AndroidNotificationChannel(
//       Random.secure().nextInt(10000).toString(),
//       "High Importance Notification",
//       importance: Importance.max,
//     );

//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//           channel.id.toString(),
//           channel.name.toString(),
//           channelDescription: "Your channel description",
//           importance: Importance.high,
//           priority: Priority.high,
//           ticker: "ticker",
//         );

//     DarwinNotificationDetails darwinNotificationDetails =
//         DarwinNotificationDetails(
//           presentAlert: true,
//           presentBadge: true,
//           presentSound: true,
//         );

//     NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//     );

//     Future.delayed(Duration.zero, () {
//       _flutterLocalNotificationsPlugin.show(
//         0,
//         message.notification!.title.toString(),
//         message.notification!.body.toString(),
//         notificationDetails,
//       );
//     });
//   }

//   Future<String> getDeviceToken() async {
//     String? token = await messaging.getToken();
//     return token!;
//   }

//   void isTokenRefresh() async {
//     messaging.onTokenRefresh.listen((event) {
//       event.toString();
//       print("refresh");
//     });
//   }
// }

import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User denied permission');
    }
  }

  void initNotification(BuildContext context) async {
    // Use existing launcher icon safely
    var androidInitializationSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher', // existing icon
    );

    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {},
    );
  }

  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print(message.notification?.title ?? '');
        print(message.notification?.body ?? '');
      }
      showNotification(message);
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    // Generate a random channel ID
    String channelId = Random.secure().nextInt(10000).toString();
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      channelId,
      "High Importance Notification",
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: "Your channel description",
          importance: Importance.high,
          priority: Priority.high,
          ticker: "ticker",
          icon: '@mipmap/ic_launcher', // use launcher icon safely
        );

    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title ?? 'Title',
        message.notification?.body ?? 'Body',
        notificationDetails,
      );
    });
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token ?? '';
  }

  void isTokenRefresh() {
    messaging.onTokenRefresh.listen((event) {
      print("Token refreshed: $event");
    });
  }
}
