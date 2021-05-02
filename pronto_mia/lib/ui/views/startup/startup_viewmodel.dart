import 'package:firebase_core/firebase_core.dart';
import 'package:logging/logging.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/authentication_service.dart';
import 'package:pronto_mia/app/app.router.dart';
import 'package:pronto_mia/core/factories/error_message_factory.dart';
import 'package:pronto_mia/core/services/logging_service.dart';
import 'package:pronto_mia/core/services/push_notification_service.dart';

class StartUpViewModel extends BaseViewModel {
  AuthenticationService get _authenticationService =>
      locator.get<AuthenticationService>();
  NavigationService get _navigationService => locator.get<NavigationService>();
  Future<LoggingService> get _loggingService =>
      locator.getAsync<LoggingService>();
  Future<PushNotificationService> get _pushNotificationService =>
      locator.getAsync<PushNotificationService>();

  String get errorMessage => _errorMessage;
  String _errorMessage;

  @override
  Future<void> onFutureError(dynamic error, Object key) async {
    _errorMessage = ErrorMessageFactory.getErrorMessage(modelError);
    (await _loggingService).log("LoginViewModel", Level.WARNING, modelError);
  }

  Future<void> handleStartUp() async {
    await Firebase.initializeApp();

    final isAuthenticated = await runErrorFuture(
      _authenticationService.isAuthenticated(),
    ) as bool;

    _handlePushNotifcations(isAuthenticated);

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

  Future<void> _handlePushNotifcations(bool isAuthenticated) async {
    final notificationsAuthorized =
        await (await _pushNotificationService).requestPermissions();
    if (notificationsAuthorized && isAuthenticated) {
      await (await _pushNotificationService).enableNotifications();
    } else {
      await (await _pushNotificationService).disableNotifications();
    }
  }
}
