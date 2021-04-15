import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/app.locator.dart';
import 'package:pronto_mia/app/app.router.dart';

class HomeViewModel extends IndexTrackingViewModel {
  NavigationService get _navigationService => locator<NavigationService>();

  bool get adminModeEnabled => _adminModeEnabled;
  bool _adminModeEnabled = false;

  void navigateTo(int index) {
    setIndex(index);

    switch (index) {
      case 0:
        final deploymentPlanViewArguments = DeploymentPlanViewArguments(
          adminModeEnabled: adminModeEnabled,
          toggleAdminModeCallback: toggleAdminMode
        );
        _navigationService.navigateTo(HomeViewRoutes.deploymentPlanView,
          id: 1,
          arguments: deploymentPlanViewArguments
        );
        break;
      case 1:
        _navigationService.navigateTo(HomeViewRoutes.uploadFileView, id: 1);
        break;
    }
  }

  void toggleAdminMode() {
    _adminModeEnabled = !_adminModeEnabled;
    notifyListeners();
  }
}
