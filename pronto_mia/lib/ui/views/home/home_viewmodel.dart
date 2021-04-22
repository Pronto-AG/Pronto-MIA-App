import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/app/app.router.dart';

class HomeViewModel extends IndexTrackingViewModel {
  NavigationService get _navigationService => locator<NavigationService>();

  bool get adminModeEnabled => _adminModeEnabled;
  bool _adminModeEnabled = false;

  void navigateTo(int index) {
    setIndex(index);

    switch (index) {
      case 0:
        final deploymentPlanViewArguments = DeploymentPlanOverviewViewArguments(
          adminModeEnabled: adminModeEnabled,
          toggleAdminModeCallback: toggleAdminMode,
        );
        _navigationService.navigateTo(
          HomeViewRoutes.deploymentPlanOverviewView,
          id: 1,
          arguments: deploymentPlanViewArguments,
        );
        break;
    }
  }

  void toggleAdminMode() {
    _adminModeEnabled = !_adminModeEnabled;
    notifyListeners();
  }
}
