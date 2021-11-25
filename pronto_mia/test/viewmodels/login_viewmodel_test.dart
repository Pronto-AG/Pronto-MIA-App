import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/ui/views/login/login_viewmodel.dart';

import '../setup/test_helpers.dart';

void main() {
  group('LoginViewModel', () {
    LoginViewModel loginViewModel;
    setUp(() {
      registerServices();
      loginViewModel = LoginViewModel();
    });
    tearDown(() => unregisterServices());

    group('submitForm', () {
      test('sets message on empty username', () async {
        await loginViewModel.submitForm();
        expect(
          loginViewModel.validationMessage,
          equals('Bitte Benutzernamen eingeben.'),
        );
      });

      test('sets message on empty password', () async {
        loginViewModel.formValueMap['userName'] = 'test';

        await loginViewModel.submitForm();
        expect(
          loginViewModel.validationMessage,
          equals('Bitte Passwort eingeben.'),
        );
      });

      test('navigates on successful login', () async {
        final authenticationService = getAndRegisterMockAuthenticationService();
        final navigationService = getAndRegisterMockNavigationService();
        loginViewModel.formValueMap['userName'] = 'foo';
        loginViewModel.formValueMap['password'] = 'bar';

        await loginViewModel.submitForm();
        expect(loginViewModel.validationMessage, isNull);
        verify(authenticationService.login('foo', 'bar')).called(1);
        verify(
          navigationService.replaceWithTransition(
            argThat(anything),
            transition: NavigationTransition.UpToDown,
          ),
        );
      });
    });
    // group('onError', () {
    //     test('calls error handling on error', () async {
    //       final errorService = getAndRegisterMockErrorService();
    //       when(errorService.getErrorMessage(captureAny)).thenReturn('test');

    //       await loginViewModel.onError(Exception());
    //       expect(loginViewModel.errorMessage, equals('test'));
    //       verify(
    //         errorService.handleError(
    //           'DepartmentOverviewViewModel',
    //           argThat(isException),
    //         ),
    //       ).called(1);
    //       verify(errorService.getErrorMessage(argThat(isException))).called(1);
    //     });
    //   }
    // );
  });
}
