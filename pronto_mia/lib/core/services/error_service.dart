import 'package:logging/logging.dart';
import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/factories/analyzed_error_factory.dart';
import 'package:pronto_mia/core/factories/error_message_factory.dart';
import 'package:pronto_mia/core/services/authentication_service.dart';
import 'package:pronto_mia/core/services/logging_service.dart';
import 'package:pronto_mia/ui/views/startup/startup_view.dart';
import 'package:stacked_services/stacked_services.dart';

/// A service, globally responsible for handling incoming errors.
///
/// It includes functionality to determine the correct error message for an
/// error.
class ErrorService {
  Future<LoggingService> get _loggingService =>
      locator.getAsync<LoggingService>();
  NavigationService get _navigationService => locator.get<NavigationService>();

  AuthenticationService get _authenticationService =>
      locator.get<AuthenticationService>();

  /// Analyzes an incoming error and performs a user logout if needed.
  ///
  /// Takes a [String] contextIdentifier to identify the class logging the
  /// error and the dynamic error itself as an input.
  Future<void> handleError(String contextIdentifier, dynamic error) async {
    final analyzedError = AnalyzedErrorFactory.create(error);
    if (analyzedError.isAuthenticationError) {
      await _authenticationService.logout();
      _navigationService.replaceWithTransition(
        StartUpView(),
        transition: NavigationTransition.UpToDown,
      );
    }
    (await _loggingService).log(contextIdentifier, Level.WARNING, error);
  }

  /// Gets the corresponding error message to a dynamic error object.
  ///
  /// Takes a dynamic error object as an input.
  /// Returns the corresponding [String] error message.
  String getErrorMessage(dynamic error) {
    final analyzedError = AnalyzedErrorFactory.create(error);
    return ErrorMessageFactory.getErrorMessage(analyzedError);
  }
}
