import 'package:firebase_core/firebase_core.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/authentication_service.dart';
import 'package:pronto_mia/app/app.router.dart';

class StartUpViewModel extends BaseViewModel {
  AuthenticationService get _authenticationService =>
      locator<AuthenticationService>();
  NavigationService get _navigationService => locator<NavigationService>();

  Future<void> handleStartUp() async {
    await Firebase.initializeApp();

    final isAuthenticated = await _authenticationService.isAuthenticated();
    if (isAuthenticated) {
      _navigationService.replaceWith(Routes.homeView);
    } else {
      _navigationService.replaceWith(Routes.loginView);
    }
  }
}
