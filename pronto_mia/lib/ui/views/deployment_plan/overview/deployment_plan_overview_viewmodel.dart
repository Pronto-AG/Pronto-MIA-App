import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/app/app.router.dart';
import 'package:pronto_mia/core/models/deployment_plan.dart';
import 'package:pronto_mia/core/services/deployment_plan_service.dart';
import 'package:pronto_mia/core/factories/error_message_factory.dart';

class DeploymentPlanOverviewViewModel extends FutureViewModel<List<DeploymentPlan>> {
  DeploymentPlanService get _deploymentPlanService =>
      locator<DeploymentPlanService>();
  NavigationService get _navigationService => locator<NavigationService>();
  ErrorMessageFactory get _errorMessageFactory =>
      locator<ErrorMessageFactory>();

  String errorMessage;
  bool adminModeEnabled = false;

  DeploymentPlanOverviewViewModel({@required this.adminModeEnabled});

  @override
  Future<List<DeploymentPlan>> futureToRun() => _getAvailableDeploymentPlans();

  @override
  void onError(dynamic error) {
    errorMessage = _errorMessageFactory.getErrorMessage(error);
  }

  void toggleAdminMode() {
    adminModeEnabled = !adminModeEnabled;
    notifyListeners();
  }

  void openPdf (DeploymentPlan deploymentPlan) {
    final pdfViewArguments = PdfViewArguments(
      pdfPath: deploymentPlan.link,
      title: "Einsatzplan ${deploymentPlan.availableFrom}",
      subTitle: "gültig bis ${deploymentPlan.availableUntil}",
    );
    _navigationService.navigateTo(
      HomeViewRoutes.pdfView,
      id: 1,
      arguments: pdfViewArguments,
    );
  }

  void createDeploymentPlan() {
    _navigationService.navigateTo(
      HomeViewRoutes.deploymentPlanEditView,
      id: 1,
    );
  }

  Future<List<DeploymentPlan>> _getAvailableDeploymentPlans() async {
    return _deploymentPlanService.getAvailableDeploymentPlans();
  }
}