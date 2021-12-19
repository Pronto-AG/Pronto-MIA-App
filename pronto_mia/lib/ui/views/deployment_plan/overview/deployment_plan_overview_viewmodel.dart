import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/deployment_plan.dart';
import 'package:pronto_mia/core/services/deployment_plan_service.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/ui/shared/custom_dialogs.dart';
import 'package:pronto_mia/ui/views/deployment_plan/edit/deployment_plan_edit_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// A view model, providing functionality for [DeploymentPlanOverviewView].
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

  /// Initializes a new instance of [DeploymentPlanOverviewViewModel].
  ///
  /// Takes a [bool] wether to execute admin level functionality as an input.
  DeploymentPlanOverviewViewModel({this.adminModeEnabled = false}) {
    _deploymentPlanService.addListener(_notifyDataChanged);
  }

  /// Gets deployment plans and stores them into [data].
  ///
  /// Returns the fetched [List] of departments.
  /// Fetches either all or only currently available deployment plans, according
  /// to [adminModeEnabled].
  @override
  Future<List<DeploymentPlan>> futureToRun() async {
    if (adminModeEnabled) {
      return _getDeploymentPlans();
    } else {
      return _getAvailableDeploymentPlans();
    }
  }

  /// Handles incoming error and sets [errorMessage] accordingly.
  ///
  /// Takes the thrown dynamic error object as an input.
  @override
  Future<void> onError(dynamic error) async {
    super.onError(error);
    await _errorService.handleError(
      DeploymentPlanOverviewViewModel.contextIdentifier,
      error,
    );
    _errorMessage = _errorService.getErrorMessage(error);
    notifyListeners();
  }

  /// Opens a view, containing a pdf file from a [DeploymentPlan].
  ///
  /// Takes a [DeploymentPlan], containing a pdf file as an input.
  Future<void> openPdf(DeploymentPlan deploymentPlan) async {
    _deploymentPlanService.openPdf(deploymentPlan);
  }

  /// Gets all deployment plans based on a filter.
  Future<List<DeploymentPlan>> filterDeploymentPlans(String filter) async =>
      _getFilteredDeploymentPlans(filter);

  /// Opens the form to create or update departments.
  ///
  /// Takes the [DeploymentPlan] to edit and a [bool] as an input wether the
  /// view should open as a dialog or standalone as an input.
  /// If the navigation or dialog resolve to data being changed, refetches
  /// the [List] of deployment plans.
  Future<void> editDeploymentPlan({
    DeploymentPlan deploymentPlan,
    bool asDialog = false,
  }) async {
    bool dataHasChanged;
    if (asDialog) {
      final dialogResponse = await _dialogService.showCustomDialog(
        variant: DialogType.custom,
        // ignore: deprecated_member_use
        customData: DeploymentPlanEditView(
          deploymentPlan: deploymentPlan,
          isDialog: true,
        ),
      );
      dataHasChanged = dialogResponse?.confirmed ?? false;
    } else {
      final navigationResponse =
          await _navigationService.navigateWithTransition(
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

  Future<List<DeploymentPlan>> _getFilteredDeploymentPlans(
    String filter,
  ) async {
    return _deploymentPlanService.filterDeploymentPlan(filter);
  }

  /// Opens the dialog to publish deployment plans.
  ///
  /// Takes the [DeploymentPlan] to publish as an input.
  /// Refetches the [List] of deployment plans after the dialog has ended.
  Future<void> publishDeploymentPlan(DeploymentPlan deploymentPlan) async {
    final deploymentPlanTitle = getDeploymentPlanTitle(deploymentPlan);
    final response = await _dialogService.showConfirmationDialog(
      title: "Einsatzplan veröffentlichen",
      description: 'Wollen sie den Einsatzplan "$deploymentPlanTitle" '
          "wirklich veröffentlichen?",
      cancelTitle: "Nein",
      confirmationTitle: "Ja",
      dialogPlatform: DialogPlatform.Material,
    );

    if (!(response?.confirmed ?? false)) {
      return;
    }

    await _deploymentPlanService.publishDeploymentPlan(
      deploymentPlan.id,
      "Einsatzplan veröffentlicht",
      'Der Einsatzplan "$deploymentPlanTitle" wurde soeben veröffentlicht.',
    );

    await initialise();
  }

  /// Opens the dialog to hide deployment plans.
  ///
  /// Takes the [DeploymentPlan] to hide as an input.
  /// Refetches the [List] of deployment plans after the dialog has ended.
  Future<void> hideDeploymentPlan(DeploymentPlan deploymentPlan) async {
    final deploymentPlanTitle = getDeploymentPlanTitle(deploymentPlan);

    final response = await _dialogService.showConfirmationDialog(
      title: "Einsatzplan verstecken",
      description: 'Wollen sie den Einsatzplan "$deploymentPlanTitle" '
          "wirklich verstecken?",
      cancelTitle: "Nein",
      confirmationTitle: "Ja",
      dialogPlatform: DialogPlatform.Material,
    );

    if (!(response?.confirmed ?? false)) {
      return;
    }

    await _deploymentPlanService.hideDeploymentPlan(deploymentPlan.id);
    await initialise();
  }

  /// Generates a title for a deployment plan
  ///
  /// Takes the [DeploymentPlan] to generate the title for as an input.
  /// Returns the generated [String] title.
  String getDeploymentPlanTitle(DeploymentPlan deploymentPlan) {
    return _deploymentPlanService.getDeploymentPlanTitle(deploymentPlan);
  }

  /// Generates a subtitle for a deployment plan
  ///
  /// Takes the [DeploymentPlan] to generate the subtitle for as an input.
  /// Returns the generated [String] subtitle.
  String getDeploymentPlanSubtitle(DeploymentPlan deploymentPlan) {
    return _deploymentPlanService.getDeploymentPlanAvailability(deploymentPlan);
  }

  /// Refetches the [List] of deployment plans.
  void _notifyDataChanged() {
    initialise();
  }

  /// Removes the listener on [DeploymentPlanService].
  @override
  void dispose() {
    _deploymentPlanService.removeListener(_notifyDataChanged);
    super.dispose();
  }

  /// Removes the [DeploymentPlan] contained in the form.
  ///
  /// After the [DeploymentPlan] has been removed successfully, closes dialog
  /// when opened as a dialog or navigates to the previous view, when opened as
  /// standalone.
  Future<void> removeDeploymentPlan(DeploymentPlan deploymentPlan) async {
    if (deploymentPlan != null) {
      await runBusyFuture(
        _deploymentPlanService.removeDeploymentPlan(deploymentPlan.id),
      );
    }
  }

  Future<void> removeItems(List<DeploymentPlan> selectedToDelete) async {
    for (var i = 0; i < selectedToDelete.length; i++) {
      removeDeploymentPlan(selectedToDelete[i]);
      data?.remove(selectedToDelete[i]);
    }
  }
}
