import 'dart:io';
import 'package:stacked/stacked.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/deployment_plan_service.dart';
import 'package:pronto_mia/ui/views/deployment_plan/edit/deployment_plan_edit_view.form.dart';

class DeploymentPlanEditViewModel extends FormViewModel {
  DeploymentPlanService get _deploymentPlanService =>
      locator<DeploymentPlanService>();

  File pdfFile;

  @override
  void setFormStatus() {}

  // TODO: Implement error and busy handling

  Future<void> submitDeploymentPlan() async {
    final availableFrom = DateTime.parse(availableFromValue);
    final availableUntil = DateTime.parse(availableUntilValue);

    await _deploymentPlanService.createDeploymentPlan(
        availableFrom,
        availableUntil,
        pdfFile
    );
  }
}