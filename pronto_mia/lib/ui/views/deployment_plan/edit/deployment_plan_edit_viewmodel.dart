import 'package:flutter/foundation.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/deployment_plan_service.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/ui/views/deployment_plan/edit/deployment_plan_edit_view.form.dart';
import 'package:pronto_mia/core/models/simple_file.dart';
import 'package:pronto_mia/core/models/deployment_plan.dart';
import 'package:pronto_mia/core/models/department.dart';
import 'package:pronto_mia/core/services/department_service.dart';

class DeploymentPlanEditViewModel extends FormViewModel {
  static const contextIdentifier = "DeploymentPlanEditViewModel";
  static const editBusyKey = 'edit-busy-key';
  static const removeBusyKey = 'remove-busy-key';

  DepartmentService get _departmentService => locator.get<DepartmentService>();
  DeploymentPlanService get _deploymentPlanService =>
      locator.get<DeploymentPlanService>();
  NavigationService get _navigationService => locator.get<NavigationService>();
  DialogService get _dialogService => locator.get<DialogService>();
  ErrorService get _errorService => locator.get<ErrorService>();

  final bool isDialog;
  final DeploymentPlan deploymentPlan;

  List<Department> get availableDepartments => _availableDepartments;
  List<Department> _availableDepartments;
  Department get department => _department;
  Department _department;
  SimpleFile get pdfFile => _pdfFile;
  SimpleFile _pdfFile;

  DeploymentPlanEditViewModel({
    @required this.deploymentPlan,
    this.isDialog = false,
  });

  @override
  void setFormStatus() {}

  Future<void> fetchDepartments() async {
    _availableDepartments = await _departmentService.getDepartments();
    notifyListeners();
  }

  void setDepartment(Department department) {
    _department = department;
    notifyListeners();
  }

  void setPdfUpload(SimpleFile fileUpload) {
    _pdfFile = fileUpload;
    notifyListeners();
  }

  Future<void> openPdf() async {
    if (_pdfFile != null) {
      _deploymentPlanService.openPdfSimpleFile(_pdfFile);
    } else {
      _deploymentPlanService.openPdf(deploymentPlan);
    }
  }

  Future<void> submitForm() async {
    final validationMessage = _validateForm();
    if (validationMessage != null) {
      setValidationMessage(validationMessage);
      notifyListeners();
      return;
    }

    final availableFrom = DateTime.parse(availableFromValue);
    final availableUntil = DateTime.parse(availableUntilValue);

    if (deploymentPlan == null) {
      await runBusyFuture(
        _deploymentPlanService.createDeploymentPlan(
          descriptionValue,
          availableFrom,
          availableUntil,
          _pdfFile,
          _department.id
        ),
        busyObject: editBusyKey,
      );
    } else {
      await runBusyFuture(
        _deploymentPlanService.updateDeploymentPlan(
          deploymentPlan.id,
          description: deploymentPlan.description != descriptionValue
              ? descriptionValue
              : null,
          availableFrom:
              !deploymentPlan.availableFrom.isAtSameMomentAs(availableFrom)
                  ? availableFrom
                  : null,
          availableUntil:
              !deploymentPlan.availableUntil.isAtSameMomentAs(availableUntil)
                  ? availableUntil
                  : null,
          pdfFile: _pdfFile,
          departmentId: _department.id,
        ),
        busyObject: editBusyKey,
      );
    }

    if (hasError) {
      await _errorService.handleError(
          DeploymentPlanEditViewModel.contextIdentifier, error);
      final errorMessage = _errorService.getErrorMessage(error);
      setValidationMessage(errorMessage);
      notifyListeners();
    } else if (isDialog) {
      _dialogService.completeDialog(DialogResponse(confirmed: true));
    } else {
      _navigationService.back(result: true);
    }
  }

  Future<void> removeDeploymentPlan() async {
    if (deploymentPlan != null) {
      await runBusyFuture(
        _deploymentPlanService.removeDeploymentPlan(deploymentPlan.id),
        busyObject: removeBusyKey,
      );
    }

    if (hasError) {
      await _errorService.handleError(
          DeploymentPlanEditViewModel.contextIdentifier, error);
      final errorMessage = _errorService.getErrorMessage(error);
      setValidationMessage(errorMessage);
      notifyListeners();
    } else if (isDialog) {
      _dialogService.completeDialog(DialogResponse(confirmed: true));
    } else {
      _navigationService.back(result: true);
    }
  }

  String _validateForm() {
    if (availableFromValue == null || availableFromValue.isEmpty) {
      return 'Bitte Startdatum eingeben.';
    }

    if (availableUntilValue == null || availableUntilValue.isEmpty) {
      return 'Bitte Enddatum eingeben.';
    }

    final availableFrom = DateTime.parse(availableFromValue);
    final availableUntil = DateTime.parse(availableUntilValue);
    if (!availableFrom.isBefore(availableUntil)) {
      return 'Das Startdatum muss vor dem Enddatum liegen.';
    }

    if (department == null) {
      return 'Bitte Abteilung auswählen.';
    }

    if (pdfPathValue == null || pdfPathValue.isEmpty) {
      return 'Bitte Einsatzplan als PDF-Datei hochladen.';
    }

    return null;
  }

  String getDeploymentPlanTitle(DeploymentPlan deploymentPlan) {
    return _deploymentPlanService.getDeploymentPlanTitle(deploymentPlan);
  }

  String getDeploymentPlanSubtitle(DeploymentPlan deploymentPlan) {
    return _deploymentPlanService.getDeploymentPlanAvailability(deploymentPlan);
  }
}
