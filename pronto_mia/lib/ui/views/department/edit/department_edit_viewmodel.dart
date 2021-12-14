import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/department.dart';
import 'package:pronto_mia/core/services/department_service.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/ui/views/department/edit/department_edit_view.form.dart';
import 'package:pronto_mia/ui/views/department/overview/department_overview_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// A view model, providing functionality for [DepartmentEditView].
class DepartmentEditViewModel extends FormViewModel {
  static const contextIdentifier = 'DepartmentEditViewModel';
  static const editActionKey = 'EditActionKey';
  static const removeActionKey = 'RemoveActionKey';

  DepartmentService get _departmentService => locator.get<DepartmentService>();
  ErrorService get _errorService => locator.get<ErrorService>();
  DialogService get _dialogService => locator.get<DialogService>();
  NavigationService get _navigationService => locator.get<NavigationService>();

  final Department department;
  final bool isDialog;

  /// Initializes a new instance of [DepartmentEditViewModel]
  ///
  /// Takes the [Department] to edit and a [bool] wether the form should be
  /// displayed as a dialog or standalone as an input.
  DepartmentEditViewModel({this.department, this.isDialog = false});

  /// Resets errors and messages, as soon as form fields update.
  @override
  void setFormStatus() {
    clearErrors();
  }

  /// Validates the form and either creates or updates a [Department].
  ///
  /// After the form has been submitted successfully, closes dialog when opened
  /// as a dialog or navigates to the previous view, when opened as standalone.
  Future<void> submitForm() async {
    final validationMessage = _validateForm();

    if (validationMessage != null) {
      setValidationMessage(validationMessage);
      notifyListeners();
      return;
    }

    if (department == null) {
      await runBusyFuture(
        _departmentService.createDepartment(nameValue),
        busyObject: editActionKey,
      );
    } else {
      await runBusyFuture(
        _departmentService.updateDepartment(
          department.id,
          name: department.name != nameValue ? nameValue : null,
        ),
        busyObject: editActionKey,
      );
    }

    _completeFormAction(editActionKey);
  }

  /// Removes the [Department] contained in the form.
  ///
  /// After the [Department] has been removed successfully, closes dialog when
  /// opened as a dialog or navigates to the previous view, when opened as
  /// standalone.
  Future<void> removeDepartment() async {
    if (department != null) {
      await runBusyFuture(
        _departmentService.removeDepartment(department.id),
        busyObject: removeActionKey,
      );
    }

    _completeFormAction(removeActionKey);
  }

  String _validateForm() {
    if (nameValue == null || nameValue.isEmpty) {
      return 'Bitte Namen eingeben.';
    }

    return null;
  }

  void cancelForm() {
    _navigationService.replaceWithTransition(
      const DepartmentOverviewView(),
    );
  }

  Future<void> _completeFormAction(String actionKey) async {
    if (hasErrorForKey(actionKey)) {
      await _errorService.handleError(
        DepartmentEditViewModel.contextIdentifier,
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
