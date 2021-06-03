import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/core/models/department.dart';
import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/core/services/department_service.dart';
import 'package:pronto_mia/ui/shared/custom_dialogs.dart';
import 'package:pronto_mia/ui/views/department/edit/department_edit_view.dart';

class DepartmentOverviewViewModel extends FutureViewModel<List<Department>> {
  static const String contextIdentifier = "DepartmentOverviewViewModel";

  DepartmentService get _departmentService => locator.get<DepartmentService>();
  ErrorService get _errorService => locator.get<ErrorService>();
  DialogService get _dialogService => locator.get<DialogService>();
  NavigationService get _navigationService => locator.get<NavigationService>();

  String get errorMessage => _errorMessage;
  String _errorMessage;

  @override
  Future<List<Department>> futureToRun() async => _getDepartments();

  @override
  Future<void> onError(dynamic error) async {
    await _errorService.handleError(contextIdentifier, error);
    _errorMessage = _errorService.getErrorMessage(error);
    notifyListeners();
  }

  Future<void> editDepartment({Department department, bool asDialog = false}) async {
    bool dataHasChanged;

    if (asDialog) {
      final dialogResponse = await _dialogService.showCustomDialog(
        variant: DialogType.custom,
        customData: DepartmentEditView(department: department, isDialog: true),
      );
      dataHasChanged = dialogResponse.confirmed;
    } else {
      final navigationResponse = await _navigationService.navigateWithTransition(
        DepartmentEditView(department: department),
      );
      dataHasChanged = navigationResponse is bool && navigationResponse == true;
    }

    if (dataHasChanged) {
      await initialise();
    }
  }

  Future<List<Department>> _getDepartments() async {
    return _departmentService.getDepartments();
  }
}