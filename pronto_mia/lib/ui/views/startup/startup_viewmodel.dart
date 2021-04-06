import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/app.locator.dart';
import 'package:pronto_mia/core/services/authentication_service.dart';
import 'package:pronto_mia/app/app.router.dart';

class StartUpViewModel extends BaseViewModel {
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();

  Future<void> handleStartUp() async {
    final isAuthenticated = await _authenticationService.isAuthenticated();

    if (isAuthenticated) {
      _navigationService.replaceWith(Routes.homeView);
    } else {
      _navigationService.replaceWith(Routes.loginView);
    }
  }
}