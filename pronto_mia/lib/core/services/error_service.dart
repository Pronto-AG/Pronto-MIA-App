import 'package:logging/logging.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/factories/error_message_factory.dart';
import 'package:pronto_mia/core/models/error_analyzer.dart';
import 'package:pronto_mia/core/services/authentication_service.dart';
import 'package:pronto_mia/core/services/logging_service.dart';
import 'package:pronto_mia/ui/views/startup/startup_view.dart';

class ErrorService {
  Future<LoggingService> get _loggingService =>
      locator.getAsync<LoggingService>();
  NavigationService get _navigationService => locator.get<NavigationService>();

  AuthenticationService get _authenticationService =>
      locator.get<AuthenticationService>();

  Future<void> handleError(String contextIdentifier, dynamic error) async {
    final analyzer = ErrorAnalyzer(error: error);
    if (analyzer.isAuthenticationError) {
      await _authenticationService.logout();
      _navigationService.replaceWithTransition(
        StartUpView(),
        transition: NavigationTransition.UpToDown,
      );
    }
    (await _loggingService).log(contextIdentifier, Level.WARNING, error);
  }

  String getErrorMessage(dynamic error) {
    final analyzer = ErrorAnalyzer(error: error);
    return ErrorMessageFactory.getErrorMessage(analyzer);
  }
}
