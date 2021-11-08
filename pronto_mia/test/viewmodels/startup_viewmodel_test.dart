import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:mockito/mockito.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/ui/views/deployment_plan/overview/deployment_plan_overview_view.dart';
import 'package:pronto_mia/ui/views/external_news/overview/external_news_overview_view.dart';
import 'package:pronto_mia/ui/views/login/login_view.dart';
import 'package:pronto_mia/ui/views/startup/startup_viewmodel.dart';

import '../setup/test_helpers.dart';

void main() {
  group('StartupViewModel', () {
    StartUpViewModel startupViewModel;
    setUp(() {
      registerServices();
      startupViewModel = StartUpViewModel();
    });
    tearDown(() => unregisterServices());

    group('onFutureError', () {
      test('calls error handling on error', () async {
        final errorService = getAndRegisterMockErrorService();
        when(errorService.getErrorMessage(captureAny)).thenReturn('test');

        await startupViewModel.onFutureError(Exception(), null);
        expect(startupViewModel.errorMessage, equals('test'));
        verify(
          errorService.handleError(
            'StartUpViewModel',
            argThat(isException),
          ),
        ).called(1);
        verify(errorService.getErrorMessage(argThat(isException))).called(1);
      });
    });

    group('handleStartup', () {
      test('navigates to deployment plan overview on user authenticated',
          () async {
        final authenticationService = getAndRegisterMockAuthenticationService();
        final pushNotificationservice =
            getAndRegisterMockPushNotificationService();
        final loggingService = getAndRegisterMockLoggingService();
        final navigationService = getAndRegisterMockNavigationService();
        when(authenticationService.isAuthenticated())
            .thenAnswer((realInvocation) => Future.value(true));
        when(pushNotificationservice.requestPermissions())
            .thenAnswer((realInvocation) => Future.value(true));

        await startupViewModel.handleStartUp();
        verify(
          loggingService.log(
            'StartUpViewModel',
            Level.INFO,
            'User already authenticated. Redirecting...',
          ),
        );
        verify(
          navigationService.replaceWithTransition(
            argThat(isA<DeploymentPlanOverviewView>()),
            transition: NavigationTransition.UpToDown,
          ),
        );
      });

      test('navigates to login on user not authenticated', () async {
        final authenticationService = getAndRegisterMockAuthenticationService();
        final pushNotificationservice =
            getAndRegisterMockPushNotificationService();
        final loggingService = getAndRegisterMockLoggingService();
        final navigationService = getAndRegisterMockNavigationService();
        when(authenticationService.isAuthenticated())
            .thenAnswer((realInvocation) => Future.value(false));
        when(pushNotificationservice.requestPermissions())
            .thenAnswer((realInvocation) => Future.value(false));

        await startupViewModel.handleStartUp();
        verify(
          loggingService.log(
            'StartUpViewModel',
            Level.INFO,
            'User not yet authenticated',
          ),
        );
        verify(
          navigationService.replaceWithTransition(
            argThat(isA<ExternalNewsOverviewView>()),
            transition: NavigationTransition.UpToDown,
          ),
        );
      });
    });
  });
}
