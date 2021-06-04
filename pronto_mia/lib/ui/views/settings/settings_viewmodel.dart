import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/authentication_service.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/ui/views/settings/settings_view.form.dart';
import 'package:pronto_mia/ui/views/login/login_view.dart';

class SettingsViewModel extends FormViewModel {
  static const contextIdentifier = 'ProfileViewModel';
  static const logoutActionKey = 'LogoutActionKey';
  static const changePasswordActionKey = 'ChangePasswordActionKey';

  AuthenticationService get _authenticationService =>
      locator.get<AuthenticationService>();
  ErrorService get _errorService => locator.get<ErrorService>();
  DialogService get _dialogService => locator.get<DialogService>();
  NavigationService get _navigationService => locator.get<NavigationService>();

  final bool isDialog;

  SettingsViewModel({this.isDialog = false});

  @override
  void setFormStatus() {
    clearErrors();
  }

  Future<void> submitForm() async {
    final validationMessage = _validateForm();

    if (validationMessage != null) {
      setValidationMessage(validationMessage);
      notifyListeners();
      return;
    }

    await runBusyFuture(
      _authenticationService.changePassword(oldPasswordValue, newPasswordValue),
      busyObject: changePasswordActionKey,
    );
    _completeFormAction(changePasswordActionKey);
  }

  Future<void> logout() async {
    await runBusyFuture(
      _authenticationService.logout(),
      busyObject: logoutActionKey,
    );
    _navigationService.replaceWithTransition(
      LoginView(),
      transition: NavigationTransition.UpToDown,
    );
  }

  String _validateForm() {
    if (oldPasswordValue == null || oldPasswordValue.isEmpty) {
      return 'Bitte aktuelles Passwort eingeben.';
    }

    if (newPasswordValue == null || newPasswordValue.isEmpty) {
      return 'Bitte neues Passwort eingeben.';
    }

    return null;
  }

  Future<void> _completeFormAction(String actionKey) async {
    if (hasErrorForKey(actionKey)) {
      await _errorService.handleError(
        SettingsViewModel.contextIdentifier,
        error(actionKey),
      );
      final errorMessage = _errorService.getErrorMessage(error(actionKey));
      setValidationMessage(errorMessage);
      notifyListeners();
    } else if (isDialog) {
      _dialogService.completeDialog(DialogResponse(confirmed: true));
    } else {
      _navigationService.back(result: true);
    }
  }
}
