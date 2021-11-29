import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:pronto_mia/core/models/department.dart';
import 'package:pronto_mia/core/models/profiles.dart';
import 'package:pronto_mia/core/models/user.dart';
import 'package:pronto_mia/ui/views/user/edit/user_edit_viewmodel.dart';

import '../setup/test_helpers.dart';

void main() {
  group('DepartmentEditViewModel', () {
    UserEditViewModel userEditViewModel;
    setUp(() {
      registerServices();
      userEditViewModel = UserEditViewModel();
    });
    tearDown(() => unregisterServices());

    group('fetchDepartments', () {
      test('fetches departments', () async {
        final departmentService = getAndRegisterMockDepartmentService();
        when(departmentService.getDepartments())
            .thenAnswer((realInvocation) => Future.value([Department()]));

        await userEditViewModel.fetchDepartments();
        expect(userEditViewModel.availableDepartments, isNotNull);
        verify(departmentService.getDepartments()).called(1);
      });
    });

    group('modifyAccessControlList', () {
      test('correctly modifies canViewDeploymentPlans', () {
        userEditViewModel.modifyAccessControlList(
          'canViewDeploymentPlans',
          true,
        );
        expect(
          userEditViewModel.accessControlList.canViewDeploymentPlans,
          isTrue,
        );
        expect(
          userEditViewModel.accessControlList.canViewDepartmentDeploymentPlans,
          isFalse,
        );
      });

      test('correctly modifies canViewDepartmentDeploymentPlans', () {
        userEditViewModel.modifyAccessControlList(
          'canViewDepartmentDeploymentPlans',
          true,
        );
        expect(
          userEditViewModel.accessControlList.canViewDepartmentDeploymentPlans,
          isTrue,
        );
        expect(
          userEditViewModel.accessControlList.canViewDeploymentPlans,
          isFalse,
        );
      });

      test('correctly modifies canEditDeploymentPlans', () {
        userEditViewModel.modifyAccessControlList(
          'canEditDeploymentPlans',
          true,
        );
        expect(
          userEditViewModel.accessControlList.canEditDeploymentPlans,
          isTrue,
        );
        expect(
          userEditViewModel.accessControlList.canViewDeploymentPlans,
          isTrue,
        );
        expect(
          userEditViewModel.accessControlList.canViewDepartmentDeploymentPlans,
          isFalse,
        );
        expect(
          userEditViewModel.accessControlList.canEditDepartmentDeploymentPlans,
          isFalse,
        );
      });

      test('correctly modifies canEditDepartmentDeploymentPlans', () {
        userEditViewModel.modifyAccessControlList(
          'canEditDepartmentDeploymentPlans',
          true,
        );
        expect(
          userEditViewModel.accessControlList.canEditDepartmentDeploymentPlans,
          isTrue,
        );
        expect(
          userEditViewModel.accessControlList.canViewDepartmentDeploymentPlans,
          isTrue,
        );
        expect(
          userEditViewModel.accessControlList.canEditDeploymentPlans,
          isFalse,
        );
      });

      test('correctly modifies canViewUsers', () {
        userEditViewModel.modifyAccessControlList(
          'canViewUsers',
          true,
        );
        expect(
          userEditViewModel.accessControlList.canViewUsers,
          isTrue,
        );
        expect(
          userEditViewModel.accessControlList.canViewDepartments,
          isTrue,
        );
        expect(
          userEditViewModel.accessControlList.canViewOwnDepartment,
          isFalse,
        );
        expect(
          userEditViewModel.accessControlList.canViewDepartmentUsers,
          isFalse,
        );
      });

      test('correctly modifies canViewDepartmentUsers', () {
        userEditViewModel.modifyAccessControlList(
          'canViewDepartmentUsers',
          true,
        );
        expect(
          userEditViewModel.accessControlList.canViewDepartmentUsers,
          isTrue,
        );
        expect(
          userEditViewModel.accessControlList.canViewUsers,
          isFalse,
        );
      });

      test('correctly modifies canEditUsers', () {
        userEditViewModel.modifyAccessControlList(
          'canEditUsers',
          true,
        );
        expect(
          userEditViewModel.accessControlList.canEditUsers,
          isTrue,
        );
        expect(
          userEditViewModel.accessControlList.canViewUsers,
          isTrue,
        );
        expect(
          userEditViewModel.accessControlList.canViewDepartments,
          isTrue,
        );
        expect(
          userEditViewModel.accessControlList.canViewOwnDepartment,
          isFalse,
        );
        expect(
          userEditViewModel.accessControlList.canEditDepartmentUsers,
          isFalse,
        );
      });

      test('correctly modifies canEditDepartmentUsers', () {
        userEditViewModel.modifyAccessControlList(
          'canEditDepartmentUsers',
          true,
        );
        expect(
          userEditViewModel.accessControlList.canEditDepartmentUsers,
          isTrue,
        );
        expect(
          userEditViewModel.accessControlList.canViewDepartmentUsers,
          isTrue,
        );
        expect(
          userEditViewModel.accessControlList.canViewDepartments,
          isTrue,
        );
        expect(
          userEditViewModel.accessControlList.canViewOwnDepartment,
          isFalse,
        );
        expect(
          userEditViewModel.accessControlList.canEditUsers,
          isFalse,
        );
      });

      test('correctly modifies canViewDepartments', () {
        userEditViewModel.modifyAccessControlList(
          'canViewDepartments',
          true,
        );
        expect(
          userEditViewModel.accessControlList.canViewDepartments,
          isTrue,
        );
        expect(
          userEditViewModel.accessControlList.canViewOwnDepartment,
          isFalse,
        );
      });

      test('correctly modifies canEditDepartments', () {
        userEditViewModel.modifyAccessControlList(
          'canEditDepartments',
          true,
        );
        expect(
          userEditViewModel.accessControlList.canEditDepartments,
          isTrue,
        );
        expect(
          userEditViewModel.accessControlList.canViewDepartments,
          isTrue,
        );
        expect(
          userEditViewModel.accessControlList.canEditOwnDepartment,
          isFalse,
        );
      });

      test('correctly modifies canEditOwnDepartment', () {
        userEditViewModel.modifyAccessControlList(
          'canEditOwnDepartment',
          true,
        );
        expect(
          userEditViewModel.accessControlList.canEditOwnDepartment,
          isTrue,
        );
        expect(
          userEditViewModel.accessControlList.canEditDepartments,
          isFalse,
        );
      });

      test('throws error on unknown modification', () {
        expect(
          () => userEditViewModel.modifyAccessControlList('test', true),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    group('submitForm', () {
      test('sets message on empty username', () async {
        await userEditViewModel.submitForm(List<Department>());
        expect(
          userEditViewModel.validationMessage,
          equals('Bitte Benutzernamen eingeben.'),
        );
      });

      test('sets message on empty password', () async {
        userEditViewModel.formValueMap['userName'] = 'test';

        await userEditViewModel.submitForm(List<Department>());
        expect(
          userEditViewModel.validationMessage,
          equals('Bitte Passwort eingeben.'),
        );
      });

      test('sets message on different passwords', () async {
        userEditViewModel.formValueMap['userName'] = 'test';
        userEditViewModel.formValueMap['password'] = 'test';

        await userEditViewModel.submitForm(List<Department>());
        expect(
          userEditViewModel.validationMessage,
          equals('Die angegebenen Passwörter stimmen nicht überein.'),
        );
      });

      test('sets message on empty department', () async {
        userEditViewModel.formValueMap['userName'] = 'test';
        userEditViewModel.formValueMap['password'] = 'test';
        userEditViewModel.formValueMap['passwordConfirm'] = 'test';

        await userEditViewModel.submitForm(List<Department>());
        expect(
          userEditViewModel.validationMessage,
          equals('Bitte Abteilung auswählen.'),
        );
      });

      test('creates user successfully as standalone', () async {
        final userService = getAndRegisterMockUserService();
        final navigationService = getAndRegisterMockNavigationService();
        userEditViewModel.formValueMap['userName'] = 'user';
        userEditViewModel.formValueMap['password'] = 'password';
        userEditViewModel.formValueMap['passwordConfirm'] = 'password';
        userEditViewModel
            .setDepartments(List<Department>.from([Department(id: 1)]));
        await userEditViewModel.submitForm(userEditViewModel.departments);
        expect(userEditViewModel.validationMessage, isNull);
        verify(userService.createUser(
          'user',
          'password',
          [1],
          argThat(isNotNull),
        )).called(1);
        verify(navigationService.back(result: true));
      });

      test('creates user successfully as dialog', () async {
        userEditViewModel = UserEditViewModel(
          isDialog: true,
        );
        final userService = getAndRegisterMockUserService();
        final dialogService = getAndRegisterMockDialogService();
        userEditViewModel.formValueMap['userName'] = 'user';
        userEditViewModel.formValueMap['password'] = 'password';
        userEditViewModel.formValueMap['passwordConfirm'] = 'password';
        userEditViewModel
            .setDepartments(List<Department>.from([Department(id: 1)]));

        await userEditViewModel.submitForm(userEditViewModel.departments);
        expect(userEditViewModel.validationMessage, isNull);
        verify(userService.createUser(
          'user',
          'password',
          [1],
          argThat(isNotNull),
        )).called(1);
        verify(dialogService.completeDialog(argThat(anything)));
      });

      test('edits user successfully as standalone', () async {
        userEditViewModel = UserEditViewModel(
          user: User(
            id: 1,
            userName: 'foo',
            departments: List<Department>.from([Department(id: 1)]),
            profile: profiles['empty'],
          ),
        );
        final userService = getAndRegisterMockUserService();
        final navigationService = getAndRegisterMockNavigationService();
        userEditViewModel.formValueMap['userName'] = 'bar';
        userEditViewModel.formValueMap['password'] = 'XXXXXX';
        userEditViewModel.formValueMap['passwordConfirm'] = 'XXXXXX';
        userEditViewModel
            .setDepartments(List<Department>.from([Department(id: 1)]));

        await userEditViewModel.submitForm(userEditViewModel.departments);
        expect(userEditViewModel.validationMessage, isNull);
        verify(userService.updateUser(1, userName: 'bar', departmentIds: [1]))
            .called(1);
        verify(navigationService.back(result: true));
      });

      test('edits user successfully as dialog', () async {
        userEditViewModel = UserEditViewModel(
          isDialog: true,
          user: User(
            id: 1,
            userName: 'foo',
            departments: List<Department>.from([Department(id: 1)]),
            profile: profiles['empty'],
          ),
        );
        final userService = getAndRegisterMockUserService();
        final dialogService = getAndRegisterMockDialogService();
        userEditViewModel.formValueMap['userName'] = 'bar';
        userEditViewModel.formValueMap['password'] = 'XXXXXX';
        userEditViewModel.formValueMap['passwordConfirm'] = 'XXXXXX';
        userEditViewModel
            .setDepartments(List<Department>.from([Department(id: 1)]));

        await userEditViewModel.submitForm(userEditViewModel.departments);
        expect(userEditViewModel.validationMessage, isNull);
        verify(userService.updateUser(1, userName: 'bar', departmentIds: [1]))
            .called(1);
        verify(dialogService.completeDialog(argThat(anything)));
      });
    });

    group('removeUser', () {
      test('removes user successfully as standalone', () async {
        userEditViewModel = UserEditViewModel(
          user: User(id: 1, profile: profiles['empty']),
        );
        final userService = getAndRegisterMockUserService();
        final navigationService = getAndRegisterMockNavigationService();

        await userEditViewModel.removeUser();
        expect(userEditViewModel.validationMessage, isNull);
        verify(userService.removeUser(1)).called(1);
        verify(navigationService.back(result: true));
      });

      test('removes user successfully as dialog', () async {
        userEditViewModel = UserEditViewModel(
          isDialog: true,
          user: User(id: 1, profile: profiles['empty']),
        );
        final userService = getAndRegisterMockUserService();
        final dialogService = getAndRegisterMockDialogService();

        await userEditViewModel.removeUser();
        expect(userEditViewModel.validationMessage, isNull);
        verify(userService.removeUser(1)).called(1);
        verify(dialogService.completeDialog(argThat(anything)));
      });
    });
  });
}
