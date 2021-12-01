import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/authentication_service.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/ui/views/deployment_plan/overview/deployment_plan_overview_view.dart';
import 'package:pronto_mia/ui/views/external_news/overview/external_news_overview_view.dart';
import 'package:pronto_mia/ui/views/login/login_view.dart';
import 'package:pronto_mia/ui/views/login/login_view.form.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// A view model, providing functionality for [LoginView].
class LoginViewModel extends FormViewModel {
  static String contextIdentifier = "LoginViewModel";

  AuthenticationService get _authenticationService =>
      locator.get<AuthenticationService>();
  NavigationService get _navigationService => locator.get<NavigationService>();
  ErrorService get _errorService => locator.get<ErrorService>();

  String get errorMessage => _errorMessage;
  String _errorMessage;

  /// Resets errors and messages, as soon as form fields update.
  @override
  void setFormStatus() {
    clearErrors();
  }

  /// Handles incoming error and sets [errorMessage] accordingly.
  ///
  /// Takes the thrown dynamic error object as an input.
  Future<void> onError(dynamic modelError) async {
    await _errorService.handleError(contextIdentifier, modelError);
    _errorMessage = _errorService.getErrorMessage(modelError);
    setValidationMessage(_errorMessage);
    notifyListeners();
  }

  /// Validates the form and performs a login for the user.
  ///
  /// After the form has been submitted successfully, navigates to
  /// [LoginView].
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
      onError(modelError);
    } else {
      _navigationService.replaceWithTransition(
        const DeploymentPlanOverviewView(),
        transition: NavigationTransition.UpToDown,
      );
    }
  }

  void cancelForm() {
    _navigationService.replaceWithTransition(
      const ExternalNewsOverviewView(),
    );
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
