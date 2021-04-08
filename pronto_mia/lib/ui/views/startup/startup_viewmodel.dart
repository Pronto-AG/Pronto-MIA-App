import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:pronto_mia/core/services/graphql_service.dart';
import 'package:pronto_mia/core/services/push_notification_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:global_configuration/global_configuration.dart';

import 'package:pronto_mia/app/app.locator.dart';
import 'package:pronto_mia/core/services/authentication_service.dart';
import 'package:pronto_mia/app/app.router.dart';

class StartUpViewModel extends BaseViewModel {
  final _configuration = GlobalConfiguration();
  final _pushNotificationService = locator<PushNotificationService>();
  final _graphQLService = locator<GraphQLService>();
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();

  Future<void> handleStartUp() async {
    await _configuration.loadFromPath('../config/app_settings.json');

    if (kReleaseMode) {
      await _configuration.loadFromPath('../config/app_settings_prod.json');
    } else {
      await _configuration.loadFromPath('../config/app_settings_dev.json');
    }

    await Firebase.initializeApp();

    await _pushNotificationService.initialise();
    _graphQLService.initialise();

    final pushNotificationToken = await _pushNotificationService.getToken();
    // ignore: avoid_print
    print('FCM Token: $pushNotificationToken');

    final isAuthenticated = await _authenticationService.isAuthenticated();
    if (isAuthenticated) {
      _navigationService.replaceWith(Routes.homeView);
    } else {
      _navigationService.replaceWith(Routes.loginView);
    }
  }
}
