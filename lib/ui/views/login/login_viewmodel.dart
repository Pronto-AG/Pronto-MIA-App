import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:informbob_app/app/app.router.dart';
import 'package:informbob_app/app/app.locator.dart';

class LoginViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  final _title = 'Login';
  String get title => _title;

  void login() {
    _navigationService.navigateTo(Routes.homeView);
  }
}
