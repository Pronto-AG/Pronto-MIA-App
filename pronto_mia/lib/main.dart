import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/authentication_service.dart';
import 'package:pronto_mia/core/services/push_notification_service.dart';
import 'package:pronto_mia/ui/shared/custom_dialogs.dart';
import 'package:pronto_mia/ui/shared/theme.dart';
import 'package:pronto_mia/ui/views/startup/startup_view.dart';
import 'package:stacked_services/stacked_services.dart';

/// Executes setup and runs the application.
void main() {
  setupLocator();
  setupDialogs();
  runApp(MyApp());
}

/// A representation of the apps root widget.
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Future<PushNotificationService> get _pushNotificationService =>
      locator.getAsync<PushNotificationService>();
  AuthenticationService get _authenticationsService =>
      locator.get<AuthenticationService>();

  /// Handles initial push notification, when available.
  ///
  /// Additionally binds lifecycle events to the widget.
  @override
  void initState() {
    super.initState();

    _pushNotificationService.then(
      (pushNotificationService) =>
          pushNotificationService.handleInitialMessage(),
    );

    WidgetsBinding.instance.addObserver(this);
  }

  /// Unbinds lifecycle events from the widget.
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Evaluates if notifications should be enabled on lifecycle change.
  ///
  /// Takes the current [AppLifeCycleState] as an input.
  /// If the app is authorized for notifications and a user is signed in,
  /// they will be enabled, otherwise they will be disabled.
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

  /// Builds the app as a material app with [StartUpView] as its home widget.
  ///
  /// Takes the current [BuildContext] as an input.
  /// Returns the built [MaterialApp].
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MaterialApp(
        title: 'Pronto-MIA',
        navigatorKey: StackedService.navigatorKey,
        home: StartUpView(),
        theme: theme,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('de', 'CH'),
        ],
      ),
    );
  }
}
