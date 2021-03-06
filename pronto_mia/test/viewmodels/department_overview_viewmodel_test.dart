import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/core/models/department.dart';
import 'package:pronto_mia/core/models/user.dart';
import 'package:pronto_mia/ui/shared/custom_dialogs.dart';
import 'package:pronto_mia/ui/views/department/overview/department_overview_viewmodel.dart';

import '../setup/test_helpers.dart';

void main() {
  group('DepartmentOverviewViewModel', () {
    DepartmentOverviewViewModel departmentOverviewViewModel;
    setUp(() {
      registerServices();
      departmentOverviewViewModel = DepartmentOverviewViewModel();
    });
    tearDown(() => unregisterServices());

    group('futureToRun', () {
      test('returns departments', () async {
        final departmentService = getAndRegisterMockDepartmentService();
        when(departmentService.getDepartments()).thenAnswer(
          (realInvocation) => Future.value([Department()]),
        );

        expect(await departmentOverviewViewModel.futureToRun(), hasLength(1));
        verify(departmentService.getDepartments()).called(1);
      });
    });

    group('onError', () {
      test('calls error handling on error', () async {
        final errorService = getAndRegisterMockErrorService();
        when(errorService.getErrorMessage(captureAny)).thenReturn('test');

        await departmentOverviewViewModel.onError(Exception());
        expect(departmentOverviewViewModel.errorMessage, equals('test'));
        verify(
          errorService.handleError(
            'DepartmentOverviewViewModel',
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

        await departmentOverviewViewModel.fetchCurrentUser();
        expect(departmentOverviewViewModel.currentUser, isNotNull);
        verify(userService.getCurrentUser()).called(1);
      });
    });

    group('editDepartment', () {
      test('opens form as standalone without data change', () async {
        final navigationService = getAndRegisterMockNavigationService();

        await departmentOverviewViewModel.editDepartment(
          department: Department(),
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

        await departmentOverviewViewModel.editDepartment(
          department: Department(),
          asDialog: true,
        );
        verifyNever(
          dialogService.showCustomDialog(
            variant: DialogType.custom,
            title: 'opens form as dialog without data change',
            customData: anyNamed('customData'),
          ),
        );
      });

      test('opens form as standalone with data change', () async {
        final navigationService = getAndRegisterMockNavigationService();
        final departmentService = getAndRegisterMockDepartmentService();
        when(
          navigationService.navigateWithTransition(
            captureAny,
            transition: captureAnyNamed('transition'),
          ),
        ).thenAnswer((realInvocation) => Future.value(true));

        await departmentOverviewViewModel.editDepartment(
          department: Department(),
        );
        verify(
          navigationService.navigateWithTransition(
            argThat(anything),
            transition: NavigationTransition.LeftToRight,
          ),
        ).called(1);
        verify(departmentService.getDepartments()).called(1);
      });

      test('opens form as dialog with data change', () async {
        final dialogService = getAndRegisterMockDialogService();
        final departmentService = getAndRegisterMockDepartmentService();
        when(
          dialogService.showCustomDialog(
            variant: captureAnyNamed('variant'),
            title: 'opens form as dialog with data change',
            customData: captureAnyNamed('customData'),
          ),
        ).thenAnswer(
          (realInvocation) => Future.value(DialogResponse(confirmed: true)),
        );

        await departmentOverviewViewModel.editDepartment(
          department: Department(),
          asDialog: true,
        );
        verifyNever(
          dialogService.showCustomDialog(
            variant: DialogType.custom,
            title: 'opens form as dialog with data change',
            customData: anyNamed('customData'),
          ),
        );
        verifyNever(departmentService.getDepartments());
      });
    });

    group('removeDepartments', () {
      test('removes department successfully as standalone', () async {
        departmentOverviewViewModel = DepartmentOverviewViewModel();
        final departmentService = getAndRegisterMockDepartmentService();
        final navigationService = getAndRegisterMockNavigationService();

        await departmentOverviewViewModel.removeDepartment(Department(id: 1));
        expect(departmentOverviewViewModel.hasError, false);
        verify(departmentService.removeDepartment(1)).called(1);
      });
    });

    group('removeItems', () {
      test('removes more than one department', () async {
        final departmentService = getAndRegisterMockDepartmentService();

        await departmentOverviewViewModel.removeItems(
          <Department>[
            Department(
              id: 1,
            ),
            Department(
              id: 2,
            ),
          ],
        );
        verify(
          departmentService.removeDepartment(
            argThat(anything),
          ),
        ).called(2);
      });
    });

    group('filterDepartments', () {
      test('filters departments', () async {
        final departmentService = getAndRegisterMockDepartmentService();
        when(departmentService.filterDepartment('test')).thenAnswer(
          (realInvocation) => Future.value([Department()]),
        );

        await departmentOverviewViewModel.filterDepartments('test');
        expect(departmentOverviewViewModel.hasError, false);
        verify(departmentService.filterDepartment('test')).called(1);
      });
    });
  });
}
