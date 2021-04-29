import 'package:firebase_core/firebase_core.dart';
import 'package:logging/logging.dart';
import 'package:pronto_mia/core/services/logging_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/authentication_service.dart';
import 'package:pronto_mia/app/app.router.dart';

class StartUpViewModel extends BaseViewModel {
  AuthenticationService get _authenticationService =>
      locator.get<AuthenticationService>();
  NavigationService get _navigationService => locator.get<NavigationService>();
  Future<LoggingService> get _loggingService =>
      locator.getAsync<LoggingService>();

  Future<void> handleStartUp() async {
    await Firebase.initializeApp();

    final isAuthenticated = await _authenticationService.isAuthenticated();
    if (isAuthenticated) {
      (await _loggingService).log("StartUpViewModel", Level.INFO,
          "User already authenticated. Redirecting...");
      _navigationService.replaceWith(Routes.homeView);
    } else {
      (await _loggingService)
          .log("StartUpViewModel", Level.INFO, "User not yet authenticated");
      _navigationService.replaceWith(Routes.loginView);
    }
  }
}
