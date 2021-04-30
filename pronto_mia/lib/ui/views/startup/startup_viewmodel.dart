import 'package:firebase_core/firebase_core.dart';
import 'package:logging/logging.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/authentication_service.dart';
import 'package:pronto_mia/app/app.router.dart';
import 'package:pronto_mia/core/factories/error_message_factory.dart';
import 'package:pronto_mia/core/services/logging_service.dart';

class StartUpViewModel extends BaseViewModel {
  AuthenticationService get _authenticationService =>
      locator.get<AuthenticationService>();
  NavigationService get _navigationService => locator.get<NavigationService>();
  Future<LoggingService> get _loggingService =>
      locator.getAsync<LoggingService>();
  ErrorMessageFactory get _errorMessageFactory =>
      locator.get<ErrorMessageFactory>();

  String get errorMessage => _errorMessage;
  String _errorMessage;

  @override
  Future<void> onFutureError(dynamic error, Object key) async {
    final errorMessage = _errorMessageFactory.getErrorMessage(modelError);
    (await _loggingService).log("LoginViewModel", Level.WARNING, modelError);
  }

  Future<void> handleStartUp() async {
    await Firebase.initializeApp();

    final isAuthenticated = await runErrorFuture(
      _authenticationService.isAuthenticated(),
    ) as bool;

    if (isAuthenticated) {
      (await _loggingService).log("StartUpViewModel", Level.INFO,
          "User already authenticated. Redirecting...");
      _navigationService.replaceWith(Routes.deploymentPlanOverviewView);
    } else {
      (await _loggingService)
          .log("StartUpViewModel", Level.INFO, "User not yet authenticated");
      _navigationService.replaceWith(Routes.loginView);
    }
  }
}
