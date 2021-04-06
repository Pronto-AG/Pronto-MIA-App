import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:pronto_mia/app/app.locator.dart';
import 'package:pronto_mia/app/app.router.dart';
import 'package:pronto_mia/ui/views/startup/startup_view.dart';

void main() {
  setupLocator();
  runApp(MyApp());
  setUpMessaging();
}

Future setUpMessaging() async {
  await Firebase.initializeApp();
  final messaging = FirebaseMessaging.instance;

  final settings = await messaging.requestPermission();
  print('User granted permission: ${settings.authorizationStatus}');

  final token = await messaging.getToken(
    // ignore: lines_longer_than_80_chars
    vapidKey: 'BPD1n6GbFtXrNJuBmYaW065gUAas_6vPuMtGF2dd3aNwCEryKu53mDiFGLfM0J0lrsoNZnOYgnrEvn-3dKWaqzE',
  );
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
      home: StartUpView(),
    );
  }
}
