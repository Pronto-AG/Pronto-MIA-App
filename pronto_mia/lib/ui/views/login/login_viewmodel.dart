import 'package:graphql/client.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/app.router.dart';
import 'package:pronto_mia/app/app.locator.dart';
import 'package:pronto_mia/core/services/auth_service.dart';
import 'package:pronto_mia/ui/views/login/login_view.form.dart';

class LoginViewModel extends FormViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();

  @override
  void setFormStatus() {}

  Future<void> login() async {
    print(userNameValue);
    print(passwordValue);

    final result = await runBusyFuture(
        _authService.login(userNameValue, passwordValue)
    ) as QueryResult;

    if (result == null) {
      setValidationMessage('Keine Verbindung zum Server.');
      return;
    }

    if (result.hasException) {
      setValidationMessage('Login fehlgeschlagen.');
      return;
    }

    _navigationService.replaceWith(Routes.uploadFileView);
  }
}
