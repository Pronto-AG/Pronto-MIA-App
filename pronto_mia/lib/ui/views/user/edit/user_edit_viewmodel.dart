import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/user.dart';
import 'package:pronto_mia/ui/views/user/edit/user_edit_view.form.dart';
import 'package:pronto_mia/core/services/department_service.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/core/services/user_service.dart';
import 'package:pronto_mia/core/models/access_control_list.dart';
import 'package:pronto_mia/core/models/profiles.dart';
import 'package:pronto_mia/core/models/department.dart';

class UserEditViewModel extends FormViewModel {
  static const contextIdentifier = 'UserEditViewModel';
  static const editActionKey = 'EditActionKey';
  static const removeActionKey = 'RemoveActionKey';

  DepartmentService get _departmentService => locator.get<DepartmentService>();
  UserService get _userService => locator.get<UserService>();
  ErrorService get _errorService => locator.get<ErrorService>();
  DialogService get _dialogService => locator.get<DialogService>();
  NavigationService get _navigationService => locator.get<NavigationService>();

  final bool isDialog;
  final User user;

  List<Department> get availableDepartments => _availableDepartments;
  List<Department> _availableDepartments;
  Department get department => _department;
  Department _department;
  AccessControlList get accessControlList => _accessControlList;
  AccessControlList _accessControlList =
      AccessControlList.copy(profiles['empty'].accessControlList);

  UserEditViewModel({this.user, this.isDialog = false}) {
    if (user != null) {
      _accessControlList = user.profile.accessControlList;
    }
  }

  @override
  void setFormStatus() {
    clearErrors();
  }

  Future<void> fetchDepartments() async {
    _availableDepartments = await _departmentService.getDepartments();
    notifyListeners();
  }

  void setDepartment(Department department) {
    _department = department;
    notifyListeners();
  }

  void setAccessControlList(AccessControlList accessControlList) {
    _accessControlList = AccessControlList.copy(accessControlList);
    notifyListeners();
  }

  // ignore: avoid_positional_boolean_parameters
  void modifyAccessControlList(String key, bool value) {
    switch (key) {
      case 'canViewDeploymentPlans':
        accessControlList.canViewDeploymentPlans = value;
        if (value) {
          accessControlList.canViewDepartmentDeploymentPlans = false;
        }
        break;
      case 'canViewDepartmentDeploymentPlans':
        accessControlList.canViewDepartmentDeploymentPlans = value;
        if (value) {
          accessControlList.canViewDeploymentPlans = false;
        }
        break;
      case 'canEditDeploymentPlans':
        accessControlList.canEditDeploymentPlans = value;
        if (value) {
          accessControlList.canViewDeploymentPlans = true;
          accessControlList.canViewDepartmentDeploymentPlans = false;
          accessControlList.canEditDepartmentDeploymentPlans = false;
        }
        break;
      case 'canEditDepartmentDeploymentPlans':
        accessControlList.canEditDepartmentDeploymentPlans = value;
        if (value) {
          if (!accessControlList.canViewDeploymentPlans) {
            accessControlList.canViewDepartmentDeploymentPlans = true;
          }
          accessControlList.canEditDeploymentPlans = false;
        }
        break;
      case 'canViewUsers':
        accessControlList.canViewUsers = value;
        if (value) {
          accessControlList.canViewDepartments = true;
          accessControlList.canViewOwnDepartment = false;
          accessControlList.canViewDepartmentUsers = false;
        }
        break;
      case 'canViewDepartmentUsers':
        accessControlList.canViewDepartmentUsers = value;
        if (value) {
          accessControlList.canViewUsers = false;
        }
        break;
      case 'canEditUsers':
        accessControlList.canEditUsers = value;
        if (value) {
          accessControlList.canViewUsers = true;
          accessControlList.canViewDepartments = true;
          accessControlList.canViewOwnDepartment = false;
          accessControlList.canEditDepartmentUsers = false;
        }
        break;
      case 'canEditDepartmentUsers':
        accessControlList.canEditDepartmentUsers = value;
        if (value) {
          if (!accessControlList.canViewUsers) {
            accessControlList.canViewDepartmentUsers = true;
          }
          accessControlList.canViewDepartments = true;
          accessControlList.canViewOwnDepartment = false;
          accessControlList.canEditUsers = false;
        }
        break;
      case 'canViewDepartments':
        accessControlList.canViewDepartments = value;
        accessControlList.canViewOwnDepartment = !value;
        break;
      case 'canEditDepartments':
        accessControlList.canEditDepartments = value;
        if (value) {
          accessControlList.canViewDepartments = true;
          accessControlList.canEditOwnDepartment = false;
        }
        break;
      case 'canEditOwnDepartment':
        accessControlList.canEditOwnDepartment = value;
        if (value) {
          accessControlList.canEditDepartments = false;
        }
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
          userNameValue,
          passwordValue,
          department.id,
          accessControlList,
        ),
        busyObject: editActionKey,
      );
    } else {
      await runBusyFuture(
        _userService.updateUser(
          user.id,
          userName: user.userName != userNameValue ? userNameValue : null,
          password: passwordValue != 'XXXXXX' ? passwordValue : null,
          departmentId:
              department.id != user.department.id ? department.id : null,
          accessControlList:
              accessControlList.isEqual(user.profile.accessControlList)
                  ? null
                  : accessControlList,
        ),
        busyObject: editActionKey,
      );
    }

    _completeFormAction(editActionKey);
  }

  Future<void> removeUser() async {
    if (user != null) {
      await runBusyFuture(
        _userService.removeUser(user.id),
        busyObject: removeActionKey,
      );
    }

    _completeFormAction(removeActionKey);
  }

  String _validateForm() {
    if (userNameValue == null || userNameValue.isEmpty) {
      return 'Bitte Benutzernamen eingeben.';
    }

    if (passwordValue == null || passwordValue.isEmpty) {
      return 'Bitte Passwort eingeben.';
    }

    if (passwordValue != passwordConfirmValue) {
      return 'Die angegebenen Passwörter stimmen nicht überein.';
    }

    if (department == null) {
      return 'Bitte Abteilung auswählen.';
    }

    return null;
  }

  Future<void> _completeFormAction(String actionKey) async {
    if (hasErrorForKey(actionKey)) {
      await _errorService.handleError(
        UserEditViewModel.contextIdentifier,
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
