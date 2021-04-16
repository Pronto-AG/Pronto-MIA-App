import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:pronto_mia/core/services/graphql_service.dart';
import 'package:pronto_mia/core/services/push_notification_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:global_configuration/global_configuration.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/authentication_service.dart';
import 'package:pronto_mia/app/app.router.dart';

class StartUpViewModel extends BaseViewModel {
  Future<PushNotificationService> get _pushNotificationService =>
    locator.getAsync<PushNotificationService>();
  AuthenticationService get _authenticationService =>
      locator<AuthenticationService>();
  NavigationService get _navigationService => locator<NavigationService>();

  Future<void> handleStartUp() async {
    await Firebase.initializeApp();

    final pushNotificationToken =
      await (await _pushNotificationService).getToken();
    // ignore: avoid_print
    print('FCM Token: $pushNotificationToken');

    final isAuthenticated =
      await (await _authenticationService).isAuthenticated();
    if (isAuthenticated) {
      _navigationService.replaceWith(Routes.homeView);
    } else {
      _navigationService.replaceWith(Routes.loginView);
    }
  }
}
