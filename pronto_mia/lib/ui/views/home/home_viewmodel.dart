import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/app.locator.dart';
import 'package:pronto_mia/app/app.router.dart';

class HomeViewModel extends IndexTrackingViewModel {
  final _navigationService = locator<NavigationService>();
  
  void navigateTo(int index) {
    setIndex(index);

    switch (index) {
      case 0:
        _navigationService.navigateTo(HomeViewRoutes.uploadFileView, id: 1);
        return;
      case 1:
        _navigationService.navigateTo(HomeViewRoutes.downloadFileView, id: 1);
        return;
      default:
        _navigationService.navigateTo(HomeViewRoutes.uploadFileView, id: 1);
        return;
    }
  }
}
