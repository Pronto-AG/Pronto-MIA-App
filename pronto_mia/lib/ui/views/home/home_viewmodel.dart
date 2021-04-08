import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/app.locator.dart';
import 'package:pronto_mia/app/app.router.dart';

class HomeViewModel extends IndexTrackingViewModel {
  final _navigationService = locator<NavigationService>();

  String get title => _title;
  final _title = 'Pronto MIA';

  void navigateTo(int index) {
    setIndex(index);

    switch (index) {
      case 0:
        _navigationService.navigateTo(HomeViewRoutes.deploymentPlanView, id: 1);
        return;
      default:
        _navigationService.navigateTo(HomeViewRoutes.deploymentPlanView, id: 1);
        return;
    }
  }
}
