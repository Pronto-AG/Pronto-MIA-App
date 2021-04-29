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
      locator<DeploymentPlanService>();
  NavigationService get _navigationService => locator<NavigationService>();
  ErrorMessageFactory get _errorMessageFactory =>
      locator<ErrorMessageFactory>();

  final bool adminModeEnabled;
  String errorMessage;

  DeploymentPlanOverviewViewModel({@required this.adminModeEnabled});

  @override
  Future<List<DeploymentPlan>> futureToRun() {
    if (adminModeEnabled) {
      return _getDeploymentPlans();
    } else {
      return _getAvailableDeploymentPlans();
    }
  }

  @override
  void onError(dynamic error) {
    errorMessage = _errorMessageFactory.getErrorMessage(error);
  }

  Future<void> openPdf(DeploymentPlan deploymentPlan) async {
    final dateFormat = DateFormat('dd.MM.yyyy');
    final availableFromFormatted =
        dateFormat.format(deploymentPlan.availableFrom);
    final availableUntilFormatted =
        dateFormat.format(deploymentPlan.availableUntil);
    final pdfViewArguments = PdfViewArguments(
      pdfPath: deploymentPlan.link,
      title: deploymentPlan.description ?? 'Einsatzplan',
      subTitle: '$availableFromFormatted - $availableUntilFormatted',
    );
    await _navigationService.navigateTo(
      Routes.pdfView,
      arguments: pdfViewArguments,
    );
  }

  Future<void> createDeploymentPlan() async {
    await _navigationService.navigateTo(Routes.deploymentPlanEditView);
  }

  Future<void> editDeploymentPlan(DeploymentPlan deploymentPlan) async {
    await _navigationService.navigateTo(
      Routes.deploymentPlanEditView,
      arguments: DeploymentPlanEditViewArguments(
        deploymentPlan: deploymentPlan,
      ),
    );
  }

  Future<List<DeploymentPlan>> _getAvailableDeploymentPlans() async {
    return _deploymentPlanService.getAvailableDeploymentPlans();
  }

  Future<List<DeploymentPlan>> _getDeploymentPlans() async {
    return _deploymentPlanService.getDeploymentPlans();
  }

  Future<void> navigateFromMenu(String route, {dynamic arguments}) async {
    await _navigationService.replaceWith(route, arguments: arguments);
  }
}
