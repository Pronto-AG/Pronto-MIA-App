import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:pronto_mia/app/app.locator.dart';
import 'package:pronto_mia/app/app.router.dart';

void main() {
  setupLocator();
  runApp(MyApp());
  setUpMessaging();
}

Future setUpMessaging() async {
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission();
  print('User granted permission: ${settings.authorizationStatus}');

  final token = await messaging.getToken();
  print(token);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Message was received!');

    if (message.notification != null) {
      print('Message contained a notification: ${message.notification.body}');
    }
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pronto-MIA',
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: StackedRouter().onGenerateRoute,
    );
  }
}
