import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/department_service.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/core/models/department.dart';
import 'package:pronto_mia/ui/views/department/edit/department_edit_view.form.dart';

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

  DepartmentEditViewModel({this.department, this.isDialog = false});

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
