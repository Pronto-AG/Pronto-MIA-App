import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/authentication_service.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/ui/views/login/login_view.form.dart';
import 'package:pronto_mia/ui/views/deployment_plan/overview/deployment_plan_overview_view.dart';

class LoginViewModel extends FormViewModel {
  static String contextIdentifier = "LoginViewModel";

  AuthenticationService get _authenticationService =>
      locator.get<AuthenticationService>();
  NavigationService get _navigationService => locator.get<NavigationService>();
  ErrorService get _errorService => locator.get<ErrorService>();
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
      await _errorService.handleError(
          LoginViewModel.contextIdentifier, modelError);
      final errorMessage = _errorService.getErrorMessage(modelError);

      setValidationMessage(errorMessage);
      notifyListeners();
    } else {
      _navigationService.replaceWithTransition(
        const DeploymentPlanOverviewView(),
        transition: NavigationTransition.UpToDown,
      );
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
