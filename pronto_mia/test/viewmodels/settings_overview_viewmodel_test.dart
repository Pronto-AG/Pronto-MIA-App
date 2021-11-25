import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/ui/views/settings/settings_overview_viewmodel.dart';

import '../setup/test_helpers.dart';

void main() {
  group('SettingsOverviewViewModel', () {
    SettingsOverviewViewModel settingsOverviewViewModel;
    setUp(() {
      registerServices();
      settingsOverviewViewModel = SettingsOverviewViewModel();
    });
    tearDown(() => unregisterServices());

    group('getUser', () {
      test('displays the user with role and avatar', () async {
        final userService = getAndRegisterMockUserService();

        await settingsOverviewViewModel.futureToRun();
        verify(userService.getCurrentUser()).called(1);
      });
    });

    group('openOverview', () {
      test('opens form as standalone without data change', () async {
        final navigationService = getAndRegisterMockNavigationService();

        await settingsOverviewViewModel.openSettings();
        verify(
          navigationService.navigateWithTransition(
            argThat(anything),
          ),
        ).called(1);
      });

      group('logout', () {
        test('navigates to login after successful logout', () async {
          final authenticationService =
              getAndRegisterMockAuthenticationService();
          final navigationService = getAndRegisterMockNavigationService();

          await settingsOverviewViewModel.logout();
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
  });
}
