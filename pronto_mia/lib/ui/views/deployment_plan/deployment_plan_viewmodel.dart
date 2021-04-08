import 'package:flutter/cupertino.dart';
import 'package:pronto_mia/core/factories/error_message_factory.dart';
import 'package:stacked/stacked.dart';

import 'package:pronto_mia/app/app.locator.dart';
import 'package:pronto_mia/core/models/deployment_plan.dart';
import 'package:pronto_mia/core/services/deployment_plan_service.dart';

class DeploymentPlanViewModel extends FutureViewModel<List<DeploymentPlan>> {
  final _deploymentPlanService = locator<DeploymentPlanService>();
  final _errorMessageFactory = locator<ErrorMessageFactory>();

  String get errorMessage => _errorMessage;
  String _errorMessage;

  @override
  Future<List<DeploymentPlan>> futureToRun() => _getAvailableDeploymentPlans();

  @override
  void onError(dynamic error) {
    print(error);
    _errorMessage = 'Ein unerwarteter Fehler ist aufgetreten.';
    // _errorMessage = _errorMessageFactory.getErrorMessage(error as Exception);
  }

  Future<List<DeploymentPlan>> _getAvailableDeploymentPlans() async {
    return _deploymentPlanService.getAvailableDeploymentPlans();
  }
}