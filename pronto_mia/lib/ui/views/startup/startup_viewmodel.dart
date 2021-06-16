import 'package:firebase_core/firebase_core.dart';
import 'package:logging/logging.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/authentication_service.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/core/services/logging_service.dart';
import 'package:pronto_mia/core/services/push_notification_service.dart';
import 'package:pronto_mia/ui/views/deployment_plan/overview/deployment_plan_overview_view.dart';
import 'package:pronto_mia/ui/views/login/login_view.dart';

class StartUpViewModel extends BaseViewModel {
  static String contextIdentifier = "StartUpViewModel";

  AuthenticationService get _authenticationService =>
      locator.get<AuthenticationService>();
  NavigationService get _navigationService => locator.get<NavigationService>();
  Future<LoggingService> get _loggingService =>
      locator.getAsync<LoggingService>();
  ErrorService get _errorService => locator.get<ErrorService>();
  Future<PushNotificationService> get _pushNotificationService =>
      locator.getAsync<PushNotificationService>();

  String get errorMessage => _errorMessage;
  String _errorMessage;

  @override
  Future<void> onFutureError(dynamic error, Object key) async {
    super.onFutureError(error, key);
    await _errorService.handleError(
        StartUpViewModel.contextIdentifier, error);
    _errorMessage = _errorService.getErrorMessage(error);
    notifyListeners();
  }

  Future<void> handleStartUp({void Function() firebaseInitialize = Firebase.initializeApp}) async {
    await firebaseInitialize();

    final isAuthenticated = await runErrorFuture(
      _authenticationService.isAuthenticated(),
    ) as bool;

    _handlePushNotifcations(isAuthenticated);

    if (isAuthenticated) {
      (await _loggingService).log("StartUpViewModel", Level.INFO,
          "User already authenticated. Redirecting...");
      _navigationService.replaceWithTransition(
        const DeploymentPlanOverviewView(),
        transition: NavigationTransition.UpToDown,
      );
    } else {
      (await _loggingService)
          .log("StartUpViewModel", Level.INFO, "User not yet authenticated");
      _navigationService.replaceWithTransition(
        LoginView(),
        transition: NavigationTransition.UpToDown,
      );
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
