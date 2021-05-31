import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/user.dart';
import 'package:pronto_mia/ui/views/user/edit/user_edit_view.form.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/core/services/user_service.dart';
import 'package:pronto_mia/core/models/access_control_list.dart';
import 'package:pronto_mia/core/models/profiles.dart';

class UserEditViewModel extends FormViewModel {
  static const contextIdentifier = 'UserEditViewModel';
  static const editBusyKey = 'edit-busy-key';
  static const removeBusyKey = 'remove-busy-key';

  UserService get _userService => locator.get<UserService>();
  ErrorService get _errorService => locator.get<ErrorService>();
  DialogService get _dialogService => locator.get<DialogService>();
  NavigationService get _navigationService => locator.get<NavigationService>();

  final User user;
  final bool isDialog;
  AccessControlList accessControlList = profiles['empty'].accessControlList;

  UserEditViewModel({this.user, this.isDialog = false}) {
    if (user != null) {
      accessControlList = user.profile.accessControlList;
    }
  }

  @override
  void setFormStatus() {
    clearErrors();
  }

  void setProfile(Profile profile) {
    accessControlList = profile.accessControlList;
    notifyListeners();
  }

  // ignore: avoid_positional_boolean_parameters
  void modifyAccessControlList(String key, bool value) {
    switch (key) {
      case 'canViewDeploymentPlans':
        accessControlList.canViewDeploymentPlans = value;
        break;
      case 'canEditDeploymentPlans':
        accessControlList.canEditDeploymentPlans = value;
        break;
      case 'canViewDepartments':
        accessControlList.canViewDepartments = value;
        break;
      case 'canEditDepartments':
        accessControlList.canEditDepartments = value;
        break;
      case 'canViewUsers':
        accessControlList.canViewUsers = value;
        break;
      case 'canEditUsers':
        accessControlList.canEditUsers = value;
        break;
      default:
        throw AssertionError(
            'The provided access control list property is not supported.');
    }
    notifyListeners();
  }

  Future<void> submitForm() async {
    final validationMessage = _validateForm();

    if (validationMessage != null) {
      setValidationMessage(validationMessage);
      notifyListeners();
      return;
    }

    if (user == null) {
      await runBusyFuture(
        _userService.createUser(
            userNameValue, passwordValue, accessControlList),
        busyObject: editBusyKey,
      );
    } else {
      await runBusyFuture(
        _userService.updateUser(
          user.id,
          userName: user.userName != userNameValue ? userNameValue : null,
          password: passwordValue != 'XXXXXX' ? passwordValue : null,
          accessControlList:
              accessControlList.isEqual(user.profile.accessControlList)
                  ? accessControlList
                  : null,
        ),
        busyObject: editBusyKey,
      );
    }

    _completeFormAction();
  }

  Future<void> removeUser() async {
    if (user != null) {
      await runBusyFuture(
        _userService.removeUser(user.id),
        busyObject: removeBusyKey,
      );
    }

    _completeFormAction();
  }

  String _validateForm() {
    if (userNameValue == null || userNameValue.isEmpty) {
      return 'Bitte Benutzernamen eingeben.';
    }

    if (user == null && (passwordValue == null || passwordValue.isEmpty)) {
      return 'Bitte Passwort eingeben.';
    }

    if (passwordValue != passwordConfirmValue) {
      return 'Die angegebenen Passwörter stimmen nicht überein.';
    }

    return null;
  }

  Future<void> _completeFormAction() async {
    if (hasError) {
      await _errorService.handleError(
        UserEditViewModel.contextIdentifier,
        error,
      );
      final errorMessage = _errorService.getErrorMessage(error);
      setValidationMessage(errorMessage);
      notifyListeners();
    } else if (isDialog) {
      _dialogService.completeDialog(DialogResponse(confirmed: true));
    } else {
      _navigationService.back(result: true);
    }
  }
}
