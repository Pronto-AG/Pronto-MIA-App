import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/app.locator.dart';
import 'package:pronto_mia/app/app.router.dart';
import 'package:pronto_mia/core/models/deployment_plan.dart';
import 'package:pronto_mia/core/services/deployment_plan_service.dart';
import 'package:pronto_mia/core/factories/error_message_factory.dart';

class DeploymentPlanViewModel extends FutureViewModel<List<DeploymentPlan>> {
  DeploymentPlanService get _deploymentPlanService =>
      locator<DeploymentPlanService>();
  NavigationService get _navigationService => locator<NavigationService>();
  ErrorMessageFactory get _errorMessageFactory =>
      locator<ErrorMessageFactory>();

  String get errorMessage => _errorMessage;
  String _errorMessage;

  bool adminModeEnabled = false;

  DeploymentPlanViewModel({@required this.adminModeEnabled});

  @override
  Future<List<DeploymentPlan>> futureToRun() => _getAvailableDeploymentPlans();

  @override
  void onError(dynamic error) {
    _errorMessage = _errorMessageFactory.getErrorMessage(error);
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

  Future<List<DeploymentPlan>> _getAvailableDeploymentPlans() async {
    return _deploymentPlanService.getAvailableDeploymentPlans();
  }
}