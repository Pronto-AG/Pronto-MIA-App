import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/ui/views/settings/settings_viewmodel.dart';

import '../setup/test_helpers.dart';

void main() {
  group('LoginViewModel', () {
    SettingsViewModel settingsViewModel;
    setUp(() {
      registerServices();
      settingsViewModel = SettingsViewModel();
    });
    tearDown(() => unregisterServices());

    group('submitForm', () {
      test('sets message on empty old password', () async {
        await settingsViewModel.submitForm();
        expect(
          settingsViewModel.validationMessage,
          equals('Bitte aktuelles Passwort eingeben.'),
        );
      });

      test('sets message on empty new password', () async {
        settingsViewModel.formValueMap['oldPassword'] = 'foo';

        await settingsViewModel.submitForm();
        expect(
          settingsViewModel.validationMessage,
          equals('Bitte neues Passwort eingeben.'),
        );
      });

      test('sets message on different passwords', () async {
        settingsViewModel.formValueMap['oldPassword'] = 'foo';
        settingsViewModel.formValueMap['newPassword'] = 'test';
        settingsViewModel.formValueMap['newPasswordConfirm'] = 'bar';

        await settingsViewModel.submitForm();
        expect(
          settingsViewModel.validationMessage,
          equals('Die angegebenen Passwörter stimmen nicht überein.'),
        );
      });

      test('changes password successfully as standalone', () async {
        final authenticationService = getAndRegisterMockAuthenticationService();
        final navigationService = getAndRegisterMockNavigationService();
        settingsViewModel.formValueMap['oldPassword'] = 'foo';
        settingsViewModel.formValueMap['newPassword'] = 'bar';
        settingsViewModel.formValueMap['newPasswordConfirm'] = 'bar';

        await settingsViewModel.submitForm();
        expect(settingsViewModel.validationMessage, isNull);
        verify(authenticationService.changePassword('foo', 'bar')).called(1);
        verify(navigationService.back(result: true));
      });

      test('changes password successfully as dialog', () async {
        settingsViewModel = SettingsViewModel(isDialog: true);
        final authenticationService = getAndRegisterMockAuthenticationService();
        final dialogService = getAndRegisterMockDialogService();
        settingsViewModel.formValueMap['oldPassword'] = 'foo';
        settingsViewModel.formValueMap['newPassword'] = 'bar';
        settingsViewModel.formValueMap['newPasswordConfirm'] = 'bar';

        await settingsViewModel.submitForm();
        expect(settingsViewModel.validationMessage, isNull);
        verify(authenticationService.changePassword('foo', 'bar')).called(1);
        verify(dialogService.completeDialog(argThat(anything)));
      });
    });

    group('logout', () {
      test('navigates to login after successful logout', () async {
        final authenticationService = getAndRegisterMockAuthenticationService();
        final navigationService = getAndRegisterMockNavigationService();

        await settingsViewModel.logout();
        verify(authenticationService.logout()).called(1);
        verify(
          navigationService.replaceWithTransition(
            argThat(anything),
            transition: NavigationTransition.UpToDown,
          ),
        );
      });
    });
  });
}
