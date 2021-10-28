import 'package:flutter/foundation.dart';
import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/department.dart';
import 'package:pronto_mia/core/models/deployment_plan.dart';
import 'package:pronto_mia/core/models/simple_file.dart';
import 'package:pronto_mia/core/services/department_service.dart';
import 'package:pronto_mia/core/services/deployment_plan_service.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/ui/views/deployment_plan/edit/deployment_plan_edit_view.form.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// A view model, providing functionality for [DeploymentPlanEditView].
class DeploymentPlanEditViewModel extends FormViewModel {
  static const contextIdentifier = "DeploymentPlanEditViewModel";
  static const editActionKey = 'EditActionKey';
  static const removeActionKey = 'RemoveActionKey';

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

  /// Initializes a new instance of [DeploymentPlanEditViewModel]
  ///
  /// Takes the [DeploymentPlan] to edit and a [bool] wether the form should be
  /// displayed as a dialog or standalone as an input.
  DeploymentPlanEditViewModel({
    @required this.deploymentPlan,
    this.isDialog = false,
  });

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
  void setDepartment(Department department) {
    _department = department;
    notifyListeners();
  }

  /// Sets the pdf file.
  ///
  /// Takes the [SimpleFile] pdf to set as an input.
  void setPdfUpload(SimpleFile fileUpload) {
    _pdfFile = fileUpload;
    notifyListeners();
  }

  /// Opens a pdf view, either from the file picker or deployment plan.
  Future<void> openPdf() async {
    if (_pdfFile != null) {
      _deploymentPlanService.openPdfSimpleFile(_pdfFile);
    } else {
      _deploymentPlanService.openPdf(deploymentPlan);
    }
  }

  /// Validates the form and either creates or updates a [DeploymentPlan].
  ///
  /// After the form has been submitted successfully, it closes the dialog in
  /// case it was opened as a dialog or navigates to the previous view if
  /// opened as standalone.
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
          _department.id,
        ),
        busyObject: editActionKey,
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
          departmentId: department.id != deploymentPlan.department.id
              ? department.id
              : null,
        ),
        busyObject: editActionKey,
      );
    }

    _completeFormAction(editActionKey);
  }

  /// Removes the [DeploymentPlan] contained in the form.
  ///
  /// After the [DeploymentPlan] has been removed successfully, closes dialog
  /// when opened as a dialog or navigates to the previous view, when opened as
  /// standalone.
  Future<void> removeDeploymentPlan() async {
    if (deploymentPlan != null) {
      await runBusyFuture(
        _deploymentPlanService.removeDeploymentPlan(deploymentPlan.id),
        busyObject: removeActionKey,
      );
    }

    _completeFormAction(removeActionKey);
  }

  /// Generates a title for a deployment plan
  ///
  /// Takes the [DeploymentPlan] to generate the title for as an input.
  /// Returns the generated [String] title.
  String getDeploymentPlanTitle(DeploymentPlan deploymentPlan) {
    return _deploymentPlanService.getDeploymentPlanTitle(deploymentPlan);
  }

  /// Generates a subtitle for a deployment plan
  ///
  /// Takes the [DeploymentPlan] to generate the subtitle for as an input.
  /// Returns the generated [String] subtitle.
  String getDeploymentPlanSubtitle(DeploymentPlan deploymentPlan) {
    return _deploymentPlanService.getDeploymentPlanAvailability(deploymentPlan);
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

  Future<void> _completeFormAction(String actionKey) async {
    if (hasErrorForKey(actionKey)) {
      await _errorService.handleError(
        DeploymentPlanEditViewModel.contextIdentifier,
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
