import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/deployment_plan.dart';
import 'package:pronto_mia/core/services/deployment_plan_service.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/ui/shared/custom_dialogs.dart';
import 'package:pronto_mia/ui/views/deployment_plan/edit/deployment_plan_edit_view.dart';

class DeploymentPlanOverviewViewModel
    extends FutureViewModel<List<DeploymentPlan>> {
  static String contextIdentifier = "DeploymentPlanOverviewViewModel";

  DeploymentPlanService get _deploymentPlanService =>
      locator.get<DeploymentPlanService>();
  NavigationService get _navigationService => locator.get<NavigationService>();
  DialogService get _dialogService => locator.get<DialogService>();
  ErrorService get _errorService => locator.get<ErrorService>();

  final bool adminModeEnabled;
  String get errorMessage => _errorMessage;
  String _errorMessage;

  DeploymentPlanOverviewViewModel({this.adminModeEnabled = false}) {
    _deploymentPlanService.addListener(_notifyDataChanged);
  }

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
    super.onError(error);
    await _errorService.handleError(
        DeploymentPlanOverviewViewModel.contextIdentifier, error);
    _errorMessage = _errorService.getErrorMessage(error);
    notifyListeners();
  }

  Future<void> openPdf(DeploymentPlan deploymentPlan) async {
    _deploymentPlanService.openPdf(deploymentPlan);
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
      dataHasChanged = dialogResponse?.confirmed ?? false;
    } else {
      final navigationResponse = await _navigationService.navigateWithTransition(
        DeploymentPlanEditView(deploymentPlan: deploymentPlan),
        transition: NavigationTransition.LeftToRight,
      );
      dataHasChanged = navigationResponse is bool && navigationResponse == true;
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

  Future<void> publishDeploymentPlan(DeploymentPlan deploymentPlan) async {
    final deploymentPlanTitle = getDeploymentPlanTitle(deploymentPlan);
    final response = await _dialogService.showConfirmationDialog(
        title: "Einsatzplan veröffentlichen",
        description: 'Wollen sie den Einsatzplan "$deploymentPlanTitle" '
            "wirklich veröffentlichen?",
        cancelTitle: "Nein",
        confirmationTitle: "Ja",
        dialogPlatform: DialogPlatform.Material);

    if (!(response?.confirmed ?? false)) {
      return;
    }

    await _deploymentPlanService.publishDeploymentPlan(
        deploymentPlan.id,
        "Einsatzplan veröffentlicht",
        'Der Einsatzplan "$deploymentPlanTitle" wurde soeben veröffentlicht.');

    await initialise();
  }

  Future<void> hideDeploymentPlan(DeploymentPlan deploymentPlan) async {
    final deploymentPlanTitle = getDeploymentPlanTitle(deploymentPlan);

    final response = await _dialogService.showConfirmationDialog(
        title: "Einsatzplan verstecken",
        description: 'Wollen sie den Einsatzplan "$deploymentPlanTitle" '
            "wirklich verstecken?",
        cancelTitle: "Nein",
        confirmationTitle: "Ja",
        dialogPlatform: DialogPlatform.Material);

    if (!(response?.confirmed ?? false)) {
      return;
    }

    await _deploymentPlanService.hideDeploymentPlan(deploymentPlan.id);
    await initialise();
  }

  String getDeploymentPlanTitle(DeploymentPlan deploymentPlan) {
    return _deploymentPlanService.getDeploymentPlanTitle(deploymentPlan);
  }

  String getDeploymentPlanSubtitle(DeploymentPlan deploymentPlan) {
    return _deploymentPlanService.getDeploymentPlanAvailability(deploymentPlan);
  }

  void _notifyDataChanged() {
    initialise();
  }

  @override
  void dispose() {
    _deploymentPlanService.removeListener(_notifyDataChanged);
    super.dispose();
  }
}
