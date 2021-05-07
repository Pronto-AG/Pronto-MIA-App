import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:pronto_mia/core/services/pdf_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/app/app.router.dart';
import 'package:pronto_mia/core/models/deployment_plan.dart';
import 'package:pronto_mia/core/services/deployment_plan_service.dart';
import 'package:pronto_mia/core/factories/error_message_factory.dart';
import 'package:pronto_mia/core/services/logging_service.dart';
import 'package:pronto_mia/ui/shared/custom_dialogs.dart';
import 'package:pronto_mia/ui/views/deployment_plan/edit/deployment_plan_edit_view.dart';

class DeploymentPlanOverviewViewModel
    extends FutureViewModel<List<DeploymentPlan>> {
  DeploymentPlanService get _deploymentPlanService =>
      locator.get<DeploymentPlanService>();
  NavigationService get _navigationService => locator.get<NavigationService>();
  DialogService get _dialogService => locator.get<DialogService>();
  Future<LoggingService> get _loggingService =>
      locator.getAsync<LoggingService>();
  PdfService get _pdfService => locator.get<PdfService>();

  final bool adminModeEnabled;
  String get errorMessage => _errorMessage;
  String _errorMessage;

  DeploymentPlanOverviewViewModel({this.adminModeEnabled = false});

  @override
  Future<List<DeploymentPlan>> futureToRun() async {
    if (adminModeEnabled) {
      return _getDeploymentPlans();
    } else {
      return _getAvailableDeploymentPlans();
    }
  }

  @override
  Future<void> onError(dynamic error) async {
    _errorMessage = ErrorMessageFactory.getErrorMessage(error);
    (await _loggingService)
        .log("DeploymentPlanOverviewViewModel", Level.WARNING, error);
  }

  Future<void> openPdf(DeploymentPlan deploymentPlan) async {
    if (kIsWeb) {
      final pdfFile = await _pdfService.downloadPdf(deploymentPlan.link);
      _pdfService.openPdfWeb(pdfFile);
    } else {
      final dateFormat = DateFormat('dd.MM.yyyy');
      final availableFromFormatted =
      dateFormat.format(deploymentPlan.availableFrom);
      final availableUntilFormatted =
      dateFormat.format(deploymentPlan.availableUntil);
      final pdfViewArguments = PdfViewArguments(
        pdfFile: deploymentPlan.link,
        title: deploymentPlan.description ?? 'Einsatzplan',
        subTitle: '$availableFromFormatted - $availableUntilFormatted',
      );
      await _navigationService.navigateTo(
        Routes.pdfView,
        arguments: pdfViewArguments,
      );
    }
  }

  Future<void> editDeploymentPlan({
    DeploymentPlan deploymentPlan,
    bool asDialog = false,
  }) async {
    bool dataHasChanged;
    if (asDialog) {
      final dialogResponse = await _dialogService.showCustomDialog(
        variant: DialogType.custom,
        customData: DeploymentPlanEditView(
          deploymentPlan: deploymentPlan,
          isDialog: true,
        ),
      );

      dataHasChanged = dialogResponse.confirmed;
    } else {
      final response = await _navigationService.navigateTo(
        Routes.deploymentPlanEditView,
        arguments: DeploymentPlanEditViewArguments(
          deploymentPlan: deploymentPlan,
        ),
      );

      if (response is bool && response == true) {
        dataHasChanged = true;
      } else {
        dataHasChanged = false;
      }
    }

    if (dataHasChanged) {
      await initialise();
    }
  }

  Future<List<DeploymentPlan>> _getAvailableDeploymentPlans() async {
    return _deploymentPlanService.getAvailableDeploymentPlans();
  }

  Future<List<DeploymentPlan>> _getDeploymentPlans() async {
    return _deploymentPlanService.getDeploymentPlans();
  }
}
