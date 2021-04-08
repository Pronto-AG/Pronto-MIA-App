import 'package:graphql/client.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/app.router.dart';
import 'package:pronto_mia/app/app.locator.dart';
import 'package:pronto_mia/core/services/authentication_service.dart';
import 'package:pronto_mia/ui/views/login/login_view.form.dart';

class LoginViewModel extends FormViewModel {
  final _navigationService = locator<NavigationService>();
  final _authenticationService = locator<AuthenticationService>();

  @override
  void setFormStatus() {}

  Future<void> login() async {
    final isLoggedIn = await runBusyFuture(
      _authenticationService.login(userNameValue, passwordValue),
    ) as bool;

    // TODO: Add specific check if server is unreachable
    if (isLoggedIn) {
      _navigationService.replaceWith(Routes.homeView);
    } else {
      setValidationMessage('Login fehlgeschlagen');
    }
  }
}
