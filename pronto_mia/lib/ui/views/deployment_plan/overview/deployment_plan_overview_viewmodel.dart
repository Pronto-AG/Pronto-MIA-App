import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/app/app.router.dart';
import 'package:pronto_mia/core/models/deployment_plan.dart';
import 'package:pronto_mia/core/services/deployment_plan_service.dart';
import 'package:pronto_mia/core/factories/error_message_factory.dart';

class DeploymentPlanOverviewViewModel
    extends FutureViewModel<List<DeploymentPlan>> {
  DeploymentPlanService get _deploymentPlanService =>
      locator.get<DeploymentPlanService>();
  NavigationService get _navigationService => locator<NavigationService>();
  ErrorMessageFactory get _errorMessageFactory =>
      locator.get<ErrorMessageFactory>();

  String get errorMessage => _errorMessage;
  String _errorMessage;
  bool adminModeEnabled = false;

  DeploymentPlanOverviewViewModel({@required this.adminModeEnabled});

  @override
  Future<List<DeploymentPlan>> futureToRun() async {
    try{
      return _getAvailableDeploymentPlans();
    } catch(e) {
      _errorMessage = await _errorMessageFactory.getErrorMessage(
      "DeploymentPlanOverviewViewModel", e);
      rethrow;
    }
  }

  void toggleAdminMode() {
    adminModeEnabled = !adminModeEnabled;
    notifyListeners();
  }

  void openPdf(DeploymentPlan deploymentPlan) {
    final dateFormat = DateFormat('dd.MM.yyyy');
    final availableFromFormatted =
        dateFormat.format(deploymentPlan.availableFrom);
    final availableUntilFormatted =
        dateFormat.format(deploymentPlan.availableUntil);
    final pdfViewArguments = PdfViewArguments(
      pdfPath: deploymentPlan.link,
      // TODO: Add description
      title: 'Einsatzplan',
      subTitle: '$availableFromFormatted - $availableUntilFormatted',
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
