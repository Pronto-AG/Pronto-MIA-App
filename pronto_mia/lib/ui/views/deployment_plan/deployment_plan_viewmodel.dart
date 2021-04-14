import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/app.locator.dart';
import 'package:pronto_mia/app/app.router.dart';
import 'package:pronto_mia/core/models/deployment_plan.dart';
import 'package:pronto_mia/core/services/deployment_plan_service.dart';
import 'package:pronto_mia/core/factories/error_message_factory.dart';

class DeploymentPlanViewModel extends FutureViewModel<List<DeploymentPlan>> {
  final _deploymentPlanService = locator<DeploymentPlanService>();
  final _navigationService = locator<NavigationService>();
  final _errorMessageFactory = locator<ErrorMessageFactory>();

  String get errorMessage => _errorMessage;
  String _errorMessage;

  @override
  Future<List<DeploymentPlan>> futureToRun() => _getAvailableDeploymentPlans();

  @override
  void onError(dynamic error) {
    _errorMessage = _errorMessageFactory.getErrorMessage(error);
  }

  void openPdf (DeploymentPlan deploymentPlan) {
    final pdfViewArguments = PdfViewArguments(
      title: "Einsatzplan ${deploymentPlan.availableFrom}",
      subTitle: "gültig bis ${deploymentPlan.availableUntil}",
      pdfPath: deploymentPlan.link
    );
    _navigationService.navigateTo(
      HomeViewRoutes.pdfView,
      arguments: pdfViewArguments,
      id: 1,
    );
  }

  Future<List<DeploymentPlan>> _getAvailableDeploymentPlans() async {
    return _deploymentPlanService.getAvailableDeploymentPlans();
  }
}