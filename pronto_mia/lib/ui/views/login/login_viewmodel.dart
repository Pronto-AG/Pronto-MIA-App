import 'package:pronto_mia/core/factories/error_message_factory.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/app.router.dart';
import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/authentication_service.dart';
import 'package:pronto_mia/ui/views/login/login_view.form.dart';

class LoginViewModel extends FormViewModel {
  AuthenticationService get _authenticationService =>
      locator<AuthenticationService>();
  NavigationService get _navigationService => locator<NavigationService>();
  ErrorMessageFactory get _errorMessageFactory =>
      locator<ErrorMessageFactory>();

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
      _authenticationService.login(userNameValue, passwordValue)
    );

    if (hasError) {
      final errorMessage = _errorMessageFactory.getErrorMessage(error);
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
