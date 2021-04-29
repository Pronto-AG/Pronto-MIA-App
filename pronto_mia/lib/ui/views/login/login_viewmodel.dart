import 'package:logging/logging.dart';
import 'package:pronto_mia/core/factories/error_message_factory.dart';
import 'package:pronto_mia/core/services/logging_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/app.router.dart';
import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/authentication_service.dart';
import 'package:pronto_mia/ui/views/login/login_view.form.dart';

class LoginViewModel extends FormViewModel {
  AuthenticationService get _authenticationService =>
      locator.get<AuthenticationService>();
  NavigationService get _navigationService => locator.get<NavigationService>();
  ErrorMessageFactory get _errorMessageFactory =>
      locator.get<ErrorMessageFactory>();
  Future<LoggingService> get _loggingService =>
      locator.getAsync<LoggingService>();

  @override
  void setFormStatus() {}

  Future<void> submitForm() async {
    final validationMessage = _validateForm();
    if (validationMessage != null) {
      setValidationMessage(validationMessage);
      notifyListeners();
      return;
    }

    await runBusyFuture(
      _authenticationService.login(userNameValue, passwordValue),
    );

    if (hasError) {
      final errorMessage = _errorMessageFactory.getErrorMessage(modelError);
      (await _loggingService).log("LoginViewModel", Level.WARNING, modelError);

      setValidationMessage(errorMessage);
      notifyListeners();
    } else {
      _navigationService.replaceWith(Routes.homeView);
    }
  }

  String _validateForm() {
    if (userNameValue == null || userNameValue.isEmpty) {
      return 'Bitte Benutzernamen eingeben.';
    }

    if (passwordValue == null || passwordValue.isEmpty) {
      return 'Bitte Passwort eingeben.';
    }

    return null;
  }
}
