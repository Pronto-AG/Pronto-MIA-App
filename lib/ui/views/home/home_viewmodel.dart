import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:informbob_app/core/services/storage_service.dart';
import 'package:informbob_app/app/app.locator.dart';
import 'package:informbob_app/app/app.router.dart';

class HomeViewModel extends BaseViewModel {
  final _storageService = locator<StorageService>();
  final _navigationService = locator<NavigationService>();

  final _title = 'Home View';
  String get title => _title;

  int _counter = 0;
  int get counter => _counter;

  Future loadCounter() async {
    _counter = await _storageService.getCounterValue();
    notifyListeners();
  }

  void incrementCounter() {
    _counter++;
    _storageService.saveCounterValue(_counter);
    notifyListeners();
  }

  void getData(int i) {
    _navigationService.navigateTo(Routes.launchesView);
  }
}
