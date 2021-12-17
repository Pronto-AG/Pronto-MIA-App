import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/access_control_list.dart';
import 'package:pronto_mia/core/models/department.dart';
import 'package:pronto_mia/core/models/profiles.dart';
import 'package:pronto_mia/core/models/user.dart';
import 'package:pronto_mia/core/services/department_service.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/core/services/user_service.dart';
import 'package:pronto_mia/ui/views/user/edit/user_edit_view.form.dart';
import 'package:pronto_mia/ui/views/user/overview/user_overview_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// A view model, providing functionality for [UserEditView].
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
  List<Department> get departments => _departments;
  List<Department> _departments;
  AccessControlList get accessControlList => _accessControlList;
  AccessControlList _accessControlList =
      AccessControlList.copy(profiles['empty'].accessControlList);

  /// Initializes a new instance of [DeploymentPlanEditViewModel]
  ///
  /// Takes the [User] to edit and a [bool] wether the form should be
  /// displayed as a dialog or standalone as an input.
  UserEditViewModel({this.user, this.isDialog = false}) {
    if (user != null) {
      _accessControlList = user.profile.accessControlList;
    }
  }

  /// Resets errors and messages, as soon as form fields update.
  @override
  void setFormStatus() {
    clearErrors();
  }

  /// Fetches departments and assigns them to [_availableDepartments].
  Future<void> fetchDepartments() async {
    _availableDepartments = await _departmentService.getDepartments();
    notifyListeners();
  }

  /// Sets the department.
  ///
  /// Takes the [Department] to set as an input.
  void setDepartments(List<Department> departments) {
    _departments = departments;
    notifyListeners();
  }

  /// Sets the accessControlList.
  ///
  /// Takes the [AccessControlList] to set as an input.
  /// It does not set the original [AccessControlList] provided by the argument,
  /// but rather a copy of its values.
  void setAccessControlList(AccessControlList accessControlList) {
    _accessControlList = AccessControlList.copy(accessControlList);
    notifyListeners();
  }

  /// Modifies the accessControlList according to the given [key] and [value].
  ///
  /// Takes a [String] key describing the permission to modify and the new
  /// [bool] value it should receive as an input.
  /// In most cases setting a permission to true, will also set others
  /// needed for that permission to true. Permissions that are not compatible
  /// with the set permission will be adjusted to false instead.
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
      case 'canEditExternalNews':
        accessControlList.canEditExternalNews = value;
        break;
      case 'canViewInternalNews':
        accessControlList.canViewInternalNews = value;
        break;
      case 'canEditInternalNews':
        accessControlList.canEditInternalNews = value;
        break;
      case 'canViewEducationalContent':
        accessControlList.canViewEducationalContent = value;
        break;
      case 'canEditEducationalContent':
        accessControlList.canEditEducationalContent = value;
        break;
      case 'canViewAppointment':
        accessControlList.canViewAppointment = value;
        break;
      case 'canEditAppointment':
        accessControlList.canEditAppointment = value;
        break;
      default:
        throw AssertionError(
          'The provided access control list property is not supported.',
        );
    }
    notifyListeners();
  }

  /// Validates the form and either creates or updates a [User].
  ///
  /// After the form has been submitted successfully, closes the dialog in case
  /// it was opened as a dialog or navigates to the previous view, if opened as
  /// standalone.
  Future<void> submitForm(List<Department> selectedDepartments) async {
    _departments = selectedDepartments;
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
          departments.map((d) => d.id).toList(),
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
          departmentIds: departments.map((d) => d.id).toList(),
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

  /// Removes the [User] contained in the form.
  ///
  /// After the [User] has been removed successfully, closes the dialog
  /// in case it was opened or navigates to the previous view, if opened as
  /// standalone.
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

    if (departments.isEmpty) {
      return 'Bitte Abteilung auswählen.';
    }

    return null;
  }

  void cancelForm() {
    _navigationService.replaceWithTransition(
      const UserOverviewView(),
    );
  }

  Future<List<Department>> getAllDepartments() {
    return _departmentService.getDepartments();
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
