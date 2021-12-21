import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:pronto_mia/ui/views/department/edit/department_edit_viewmodel.dart';
import 'package:pronto_mia/core/models/department.dart';

import '../setup/test_helpers.dart';

void main() {
  group('DepartmentEditViewModel', () {
    DepartmentEditViewModel departmentEditViewModel;
    setUp(() {
      registerServices();
      departmentEditViewModel = DepartmentEditViewModel();
    });
    tearDown(() => unregisterServices());

    group('submitForm', () {
      test('sets message on empty name', () async {
        await departmentEditViewModel.submitForm();
        expect(
          departmentEditViewModel.validationMessage,
          equals('Bitte Namen eingeben.'),
        );
      });

      test('creates department successfully as standalone', () async {
        final departmentService = getAndRegisterMockDepartmentService();
        final navigationService = getAndRegisterMockNavigationService();
        departmentEditViewModel.formValueMap['name'] = 'test';

        await departmentEditViewModel.submitForm();
        expect(departmentEditViewModel.validationMessage, isNull);
        verify(departmentService.createDepartment('test')).called(1);
        verify(navigationService.back(result: true));
      });

      test('creates department successfully as dialog', () async {
        departmentEditViewModel = DepartmentEditViewModel(isDialog: true);
        final departmentService = getAndRegisterMockDepartmentService();
        final dialogService = getAndRegisterMockDialogService();
        departmentEditViewModel.formValueMap['name'] = 'test';

        await departmentEditViewModel.submitForm();
        expect(departmentEditViewModel.validationMessage, isNull);
        verify(departmentService.createDepartment('test')).called(1);
        verify(dialogService.completeDialog(argThat(anything)));
      });

      test('edits department successfully as standalone', () async {
        departmentEditViewModel = DepartmentEditViewModel(
          department: Department(id: 1, name: 'foo'),
        );
        final departmentService = getAndRegisterMockDepartmentService();
        final navigationService = getAndRegisterMockNavigationService();
        departmentEditViewModel.formValueMap['name'] = 'bar';

        await departmentEditViewModel.submitForm();
        expect(departmentEditViewModel.validationMessage, isNull);
        verify(departmentService.updateDepartment(1, name: 'bar')).called(1);
        verify(navigationService.back(result: true));
      });

      test('edits department successfully as dialog', () async {
        departmentEditViewModel = DepartmentEditViewModel(
          isDialog: true,
          department: Department(id: 1, name: 'foo'),
        );
        final departmentService = getAndRegisterMockDepartmentService();
        final dialogService = getAndRegisterMockDialogService();
        departmentEditViewModel.formValueMap['name'] = 'bar';

        await departmentEditViewModel.submitForm();
        expect(departmentEditViewModel.validationMessage, isNull);
        verify(departmentService.updateDepartment(1, name: 'bar')).called(1);
        verify(dialogService.completeDialog(argThat(anything)));
      });
    });

    group('removeDepartment', () {
      test('removes department successfully as standalone', () async {
        departmentEditViewModel = DepartmentEditViewModel(
          department: Department(id: 1),
        );
        final departmentService = getAndRegisterMockDepartmentService();
        final navigationService = getAndRegisterMockNavigationService();

        await departmentEditViewModel.removeDepartment();
        expect(departmentEditViewModel.validationMessage, isNull);
        verify(departmentService.removeDepartment(1)).called(1);
        verify(navigationService.back(result: true));
      });

      test('removes department successfully as dialog', () async {
        departmentEditViewModel = DepartmentEditViewModel(
          isDialog: true,
          department: Department(id: 1),
        );
        final departmentService = getAndRegisterMockDepartmentService();
        final dialogService = getAndRegisterMockDialogService();

        await departmentEditViewModel.removeDepartment();
        expect(departmentEditViewModel.validationMessage, isNull);
        verify(departmentService.removeDepartment(1)).called(1);
        verify(dialogService.completeDialog(argThat(anything)));
      });
    });

    group('cancelForm', () {
      test('replaces view', () async {
        final navigationService = getAndRegisterMockNavigationService();
        departmentEditViewModel.cancelForm();
        verify(
          navigationService.replaceWithTransition(
            argThat(anything),
          ),
        ).called(1);
      });
    });
  });
}
