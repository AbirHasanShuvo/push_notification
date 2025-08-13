import 'package:flutter/material.dart';
import 'package:push_notification/services/notification_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit();
    //notificationServices.isTokenRefresh();
    //device token
    notificationServices.getDeviceToken().then((value) {
      ;
      print('Device Token: $value');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: [Text('Hello World again')]));
  }
}
