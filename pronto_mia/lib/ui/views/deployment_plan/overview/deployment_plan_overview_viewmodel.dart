import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:pronto_mia/core/services/logging_service.dart';
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
  NavigationService get _navigationService => locator.get<NavigationService>();
  ErrorMessageFactory get _errorMessageFactory =>
      locator.get<ErrorMessageFactory>();
  Future<LoggingService> get _loggingService =>
      locator.getAsync<LoggingService>();

  final bool adminModeEnabled;
  String get errorMessage => _errorMessage;
  String _errorMessage;

  DeploymentPlanOverviewViewModel({this.adminModeEnabled = false});

  @override
  Future<List<DeploymentPlan>> futureToRun() {
    if (adminModeEnabled) {
      return _getDeploymentPlans();
    } else {
      return _getAvailableDeploymentPlans();
    }
  }

  @override
  Future<void> onError(dynamic error) async {
    _errorMessage = _errorMessageFactory.getErrorMessage(error);
    (await _loggingService)
        .log("DeploymentPlanOverviewViewModel", Level.WARNING, error);
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
    final dataHasChanged = await _navigationService.navigateTo(
      Routes.deploymentPlanEditView,
    );
    if (dataHasChanged is bool && dataHasChanged) {
      await initialise();
    }
  }

  Future<void> editDeploymentPlan(DeploymentPlan deploymentPlan) async {
    final dataHasChanged = await _navigationService.navigateTo(
      Routes.deploymentPlanEditView,
      arguments: DeploymentPlanEditViewArguments(
        deploymentPlan: deploymentPlan,
      ),
    );

    if (dataHasChanged is bool && dataHasChanged) {
      await initialise();
    }
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
