import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/core/models/user.dart';
import 'package:pronto_mia/ui/views/user/overview/user_overview_viewmodel.dart';
import 'package:pronto_mia/ui/shared/custom_dialogs.dart';

import '../setup/test_helpers.dart';

void main() {
  group('DepartmentOverviewViewModel', () {
    UserOverviewViewModel userOverviewViewModel;
    setUp(() {
      registerServices();
      userOverviewViewModel = UserOverviewViewModel();
    });
    tearDown(() => unregisterServices());

    group('futureToRun', () {
      test('returns users', () async {
        final userService = getAndRegisterMockUserService();
        when(userService.getUsers()).thenAnswer(
              (realInvocation) => Future.value([User()]),
        );

        expect(await userOverviewViewModel.futureToRun(), hasLength(1));
        verify(userService.getUsers()).called(1);
      });
    });

    group('onError', () {
      test('calls error handling on error', () async {
        final errorService = getAndRegisterMockErrorService();
        when(errorService.getErrorMessage(captureAny)).thenReturn('test');

        await userOverviewViewModel.onError(Exception());
        expect(userOverviewViewModel.errorMessage, equals('test'));
        verify(
          errorService.handleError(
            'UserOverviewViewModel',
            argThat(isException),
          ),
        ).called(1);
        verify(errorService.getErrorMessage(argThat(isException))).called(1);
      });
    });

    group('fetchCurrentUser', () {
      test('fetches current user', () async {
        final userService = getAndRegisterMockUserService();
        when(userService.getCurrentUser()).thenAnswer(
              (realInvocation) => Future.value(User()),
        );

        await userOverviewViewModel.fetchCurrentUser();
        expect(userOverviewViewModel.currentUser, isNotNull);
        verify(userService.getCurrentUser()).called(1);
      });
    });

    group('editUser', () {
      test('opens form as standalone without data change', () async {
        final navigationService = getAndRegisterMockNavigationService();

        await userOverviewViewModel.editUser(
          user: User(),
        );
        verify(
          navigationService.navigateWithTransition(
            argThat(anything),
            transition: NavigationTransition.LeftToRight,
          ),
        ).called(1);
      });

      test('opens form as dialog without data change', () async {
        final dialogService = getAndRegisterMockDialogService();

        await userOverviewViewModel.editUser(
          user: User(),
          asDialog: true,
        );
        verify(
          dialogService.showCustomDialog(
            variant: DialogType.custom,
            customData: anyNamed('customData'),
          ),
        );
      });

      test('opens form as standalone with data change', () async {
        final navigationService = getAndRegisterMockNavigationService();
        final userService = getAndRegisterMockUserService();
        when(
          navigationService.navigateWithTransition(
            captureAny,
            transition: captureAnyNamed('transition'),
          ),
        ).thenAnswer((realInvocation) => Future.value(true));

        await userOverviewViewModel.editUser(
          user: User(),
        );
        verify(
          navigationService.navigateWithTransition(
            argThat(anything),
            transition: NavigationTransition.LeftToRight,
          ),
        ).called(1);
        verify(userService.getUsers()).called(1);
      });

      test('opens form as dialog with data change', () async {
        final dialogService = getAndRegisterMockDialogService();
        final userService = getAndRegisterMockUserService();
        when(
          dialogService.showCustomDialog(
            variant: captureAnyNamed('variant'),
            customData: captureAnyNamed('customData'),
          ),
        ).thenAnswer(
              (realInvocation) => Future.value(DialogResponse(confirmed: true)),
        );

        await userOverviewViewModel.editUser(
          user: User(),
          asDialog: true,
        );
        verify(
          dialogService.showCustomDialog(
            variant: DialogType.custom,
            customData: anyNamed('customData'),
          ),
        );
        verify(userService.getUsers()).called(1);
      });
    });
  });
}