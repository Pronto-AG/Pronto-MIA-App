import 'package:file_picker/file_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/app.router.dart';
import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/deployment_plan_service.dart';
import 'package:pronto_mia/ui/views/deployment_plan/edit/deployment_plan_edit_view.form.dart';

class DeploymentPlanEditViewModel extends FormViewModel {
  DeploymentPlanService get _deploymentPlanService =>
      locator<DeploymentPlanService>();
  NavigationService get _navigationService => locator<NavigationService>();

  PlatformFile pdfUpload;

  @override
  void setFormStatus() {}

  // TODO: Implement error and busy handling

  void setPdfUpload(PlatformFile file) {
    pdfUpload = file;
    notifyListeners();
  }

  void openPdf() {
    if (pdfUpload != null) {
      final title = (descriptionValue == null || descriptionValue.isEmpty)
          ? 'Einsatzplan'
          : descriptionValue;
      final subTitle = '$availableFromValue - $availableUntilValue';

      final pdfViewArguments = PdfViewArguments(
        title: title,
        subTitle: subTitle,
        pdfUpload: pdfUpload,
      );

      _navigationService.navigateTo(
        HomeViewRoutes.pdfView,
        id: 1,
        arguments: pdfViewArguments,
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

    await _deploymentPlanService.createDeploymentPlan(
      descriptionValue,
      availableFrom,
      availableUntil,
      pdfUpload,
    );
  }

  // TODO: Implement validation
  String _validateForm() {
    return null;
  }
}
