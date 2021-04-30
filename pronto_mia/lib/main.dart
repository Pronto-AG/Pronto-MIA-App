import 'package:flutter/material.dart';
import 'package:pronto_mia/core/services/authentication_service.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/app/app.router.dart';
import 'package:pronto_mia/app/theme.dart';
import 'package:pronto_mia/ui/views/startup/startup_view.dart';
import 'package:pronto_mia/core/services/push_notification_service.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

// TODO: Override error widget
// TODO: Override error handler

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Future<PushNotificationService> get _pushNotificationService =>
      locator.getAsync<PushNotificationService>();
  AuthenticationService get _authenticationsService =>
      locator.get<AuthenticationService>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      final isAuthenticated = await _authenticationsService.isAuthenticated();
      final notificationsAuthorized =
          await (await _pushNotificationService).notificationsAuthorized();
      if (isAuthenticated && notificationsAuthorized) {
        await (await _pushNotificationService).enableNotifications();
      } else {
        await (await _pushNotificationService).disableNotifications();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pronto-MIA',
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      home: StartUpView(),
      theme: theme,
      debugShowCheckedModeBanner: false,
    );
  }
}
