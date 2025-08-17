import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:push_notification/screens/notification_details_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  void firebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    //FCM token
    String? token = await messaging.getToken();
    print("FCM Token: $token");
    //foreground notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification!.title ?? "N/A";
      final body = message.notification!.body ?? "N/A";

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(
            body,
            maxLines: 1,
            style: TextStyle(overflow: TextOverflow.ellipsis),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        NotificationDetailsScreen(title: title, body: body),
                  ),
                );
              },
              child: Text("Next"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
          ],
        ),
      );
    });
    //app is not closed but as in the background
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification!.title ?? "N/A";
      final body = message.notification!.body ?? "N/A";
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) =>
      //         NotificationDetailsScreen(title: title, body: body),
      //   ),
      // );
    });
    //already the app is closed or terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final title = message.notification!.title ?? "N/A";
        final body = message.notification!.body ?? "N/A";
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                NotificationDetailsScreen(title: title, body: body),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    firebaseMessaging();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text(
          "Push Notification",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
    );
  }
}
