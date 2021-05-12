import 'package:flutter/foundation.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/deployment_plan_service.dart';
import 'package:pronto_mia/ui/views/deployment_plan/edit/deployment_plan_edit_view.form.dart';
import 'package:pronto_mia/core/models/simple_file.dart';
import 'package:pronto_mia/core/factories/error_message_factory.dart';
import 'package:pronto_mia/core/models/deployment_plan.dart';
import 'package:pronto_mia/core/services/pdf_service.dart';
import 'package:pronto_mia/ui/views/pdf/pdf_view.dart';

class DeploymentPlanEditViewModel extends FormViewModel {
  DeploymentPlanService get _deploymentPlanService =>
      locator.get<DeploymentPlanService>();
  NavigationService get _navigationService => locator.get<NavigationService>();
  DialogService get _dialogService => locator.get<DialogService>();
  PdfService get _pdfService => locator.get<PdfService>();

  final String editBusyKey = 'edit-busy-key';
  final String removeBusyKey = 'remove-busy-key';

  final DeploymentPlan deploymentPlan;
  final bool isDialog;

  SimpleFile get pdfFile => _pdfFile;
  SimpleFile _pdfFile;

  DeploymentPlanEditViewModel({
    @required this.deploymentPlan,
    this.isDialog = false,
  });

  @override
  void setFormStatus() {}

  void setPdfUpload(SimpleFile fileUpload) {
    _pdfFile = fileUpload;
    notifyListeners();
  }

  Future<void> openPdf() async {
    if (kIsWeb) {
      _pdfFile ??= await _pdfService.downloadPdf(deploymentPlan.link);
      _pdfService.openPdfWeb(_pdfFile);
    } else {
      _navigationService.navigateWithTransition(
        PdfView(
          title: pdfPathValue,
          pdfFile: _pdfFile ?? deploymentPlan.link,
        ),
        transition: NavigationTransition.DownToUp,
      );
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
        ),
        busyObject: editBusyKey,
      );
    }

    if (hasError) {
      final errorMessage = ErrorMessageFactory.getErrorMessage(error);
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
      final errorMessage = ErrorMessageFactory.getErrorMessage(error);
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

    if (pdfPathValue == null || pdfPathValue.isEmpty) {
      return 'Bitte Einsatzplan als PDF-Datei hochladen.';
    }

    return null;
  }
}
