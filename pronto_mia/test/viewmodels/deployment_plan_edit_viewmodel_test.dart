import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:pronto_mia/core/models/deployment_plan.dart';
import 'package:pronto_mia/core/models/simple_file.dart';
import 'package:pronto_mia/core/models/department.dart';
import 'package:pronto_mia/ui/views/deployment_plan/edit/deployment_plan_edit_viewmodel.dart';

import '../setup/test_helpers.dart';

void main() {
  group('DepartmentEditViewModel', () {
    DeploymentPlanEditViewModel deploymentPlanEditViewModel;
    setUp(() {
      registerServices();
      deploymentPlanEditViewModel = DeploymentPlanEditViewModel();
    });
    tearDown(() => unregisterServices());

    group('fetchDepartments', () {
      test('fetches departments', () async {
        final departmentService = getAndRegisterMockDepartmentService();
        when(
          departmentService.getDepartments()
        ).thenAnswer((realInvocation) => Future.value([Department()]));

        await deploymentPlanEditViewModel.fetchDepartments();
        expect(deploymentPlanEditViewModel.availableDepartments, isNotNull);
        verify(departmentService.getDepartments()).called(1);
      });
    });

    group('openPdf', () {
      test('opens pdf from file picker', () async {
        final deploymentPlanService = getAndRegisterMockDeploymentPlanService();
        deploymentPlanEditViewModel.setPdfUpload(SimpleFile());

        await deploymentPlanEditViewModel.openPdf();
        verify(deploymentPlanService.openPdfSimpleFile(argThat(anything)));
      });

      test('opens pdf from deployment plan', () async {
        deploymentPlanEditViewModel = DeploymentPlanEditViewModel(
          deploymentPlan: DeploymentPlan(),
        );
        final deploymentPlanService = getAndRegisterMockDeploymentPlanService();

        await deploymentPlanEditViewModel.openPdf();
        verify(deploymentPlanService.openPdf(argThat(anything)));
      });
    });

    group('submitForm', () {
      test('sets message on empty start date', () async {
        await deploymentPlanEditViewModel.submitForm();
        expect(
          deploymentPlanEditViewModel.validationMessage,
          equals('Bitte Startdatum eingeben.'),
        );
      });

      test('sets message on empty end date', () async {
        deploymentPlanEditViewModel.formValueMap['availableFrom'] =
          '2011-10-05T14:48:00.000Z';

        await deploymentPlanEditViewModel.submitForm();
        expect(
          deploymentPlanEditViewModel.validationMessage,
          equals('Bitte Enddatum eingeben.'),
        );
      });

      test('sets message on end date before start date', () async {
        deploymentPlanEditViewModel.formValueMap['availableFrom'] =
          '2011-10-05T14:48:00.000Z';
        deploymentPlanEditViewModel.formValueMap['availableUntil'] =
          '2010-10-05T14:48:00.000Z';

        await deploymentPlanEditViewModel.submitForm();
        expect(
          deploymentPlanEditViewModel.validationMessage,
          equals('Das Startdatum muss vor dem Enddatum liegen.'),
        );
      });

      test('sets message on empty department', () async {
        deploymentPlanEditViewModel.formValueMap['availableFrom'] =
          '2011-10-05T14:48:00.000Z';
        deploymentPlanEditViewModel.formValueMap['availableUntil'] =
          '2012-10-05T14:48:00.000Z';

        await deploymentPlanEditViewModel.submitForm();
        expect(
          deploymentPlanEditViewModel.validationMessage,
          equals('Bitte Abteilung auswählen.'),
        );
      });

      test('sets message on empty file upload', () async {
        deploymentPlanEditViewModel.formValueMap['availableFrom'] =
          '2011-10-05T14:48:00.000Z';
        deploymentPlanEditViewModel.formValueMap['availableUntil'] =
          '2012-10-05T14:48:00.000Z';
        deploymentPlanEditViewModel.setDepartment(Department());

        await deploymentPlanEditViewModel.submitForm();
        expect(
          deploymentPlanEditViewModel.validationMessage,
          equals('Bitte Einsatzplan als PDF-Datei hochladen.'),
        );
      });

      test('creates deployment plan successfully as standalone', () async {
        final deploymentPlanService = getAndRegisterMockDeploymentPlanService();
        final navigationService = getAndRegisterMockNavigationService();
        deploymentPlanEditViewModel.formValueMap['description'] = 'test';
        deploymentPlanEditViewModel.formValueMap['availableFrom'] =
        '2011-10-05T14:48:00.000Z';
        deploymentPlanEditViewModel.formValueMap['availableUntil'] =
        '2012-10-05T14:48:00.000Z';
        deploymentPlanEditViewModel.formValueMap['pdfPath'] =
        'test';
        deploymentPlanEditViewModel.setDepartment(Department(id: 1));
        deploymentPlanEditViewModel.setPdfUpload(SimpleFile());

        await deploymentPlanEditViewModel.submitForm();
        expect(deploymentPlanEditViewModel.validationMessage, isNull);
        verify(deploymentPlanService.createDeploymentPlan(
          'test',
          DateTime.parse('2011-10-05T14:48:00.000Z'),
          DateTime.parse('2012-10-05T14:48:00.000Z'),
          argThat(isNotNull),
          1,
        )).called(1);
        verify(navigationService.back(result: true));
      });

      test('creates deployment plan successfully as dialog', () async {
        deploymentPlanEditViewModel = DeploymentPlanEditViewModel(
          isDialog: true,
        );
        final deploymentPlanService = getAndRegisterMockDeploymentPlanService();
        final dialogService = getAndRegisterMockDialogService();
        deploymentPlanEditViewModel.formValueMap['description'] = 'test';
        deploymentPlanEditViewModel.formValueMap['availableFrom'] =
        '2011-10-05T14:48:00.000Z';
        deploymentPlanEditViewModel.formValueMap['availableUntil'] =
        '2012-10-05T14:48:00.000Z';
        deploymentPlanEditViewModel.formValueMap['pdfPath'] =
        'test';
        deploymentPlanEditViewModel.setDepartment(Department(id: 1));
        deploymentPlanEditViewModel.setPdfUpload(SimpleFile());

        await deploymentPlanEditViewModel.submitForm();
        expect(deploymentPlanEditViewModel.validationMessage, isNull);
        verify(deploymentPlanService.createDeploymentPlan(
            'test',
            DateTime.parse('2011-10-05T14:48:00.000Z'),
            DateTime.parse('2012-10-05T14:48:00.000Z'),
            argThat(isNotNull),
            1,
        )).called(1);
        verify(dialogService.completeDialog(argThat(anything)));
      });

      test('edits department successfully as standalone', () async {
        deploymentPlanEditViewModel = DeploymentPlanEditViewModel(
          deploymentPlan: DeploymentPlan(
            id: 1,
            description: 'foo',
            availableFrom: DateTime.parse('2011-10-05T14:48:00.000Z'),
            availableUntil: DateTime.parse('2012-10-05T14:48:00.000Z'),
            link: 'http://example.com/',
            department: Department(id: 1),
          ),
        );
        final deploymentPlanService = getAndRegisterMockDeploymentPlanService();
        final navigationService = getAndRegisterMockNavigationService();
        deploymentPlanEditViewModel.formValueMap['description'] = 'bar';
        deploymentPlanEditViewModel.formValueMap['availableFrom'] =
        '2011-10-05T14:48:00.000Z';
        deploymentPlanEditViewModel.formValueMap['availableUntil'] =
        '2012-10-05T14:48:00.000Z';
        deploymentPlanEditViewModel.formValueMap['pdfPath'] =
        'test';
        deploymentPlanEditViewModel.setDepartment(Department(id: 1));

        await deploymentPlanEditViewModel.submitForm();
        expect(deploymentPlanEditViewModel.validationMessage, isNull);
        verify(deploymentPlanService.updateDeploymentPlan(
          1,
          description: 'bar',
        )).called(1);
        verify(navigationService.back(result: true));
      });

      test('edits department successfully as dialog', () async {
        deploymentPlanEditViewModel = DeploymentPlanEditViewModel(
          isDialog: true,
          deploymentPlan: DeploymentPlan(
            id: 1,
            description: 'foo',
            availableFrom: DateTime.parse('2011-10-05T14:48:00.000Z'),
            availableUntil: DateTime.parse('2012-10-05T14:48:00.000Z'),
            link: 'http://example.com/',
            department: Department(id: 1),
          ),
        );
        final deploymentPlanService = getAndRegisterMockDeploymentPlanService();
        final dialogService = getAndRegisterMockDialogService();
        deploymentPlanEditViewModel.formValueMap['description'] = 'bar';
        deploymentPlanEditViewModel.formValueMap['availableFrom'] =
        '2011-10-05T14:48:00.000Z';
        deploymentPlanEditViewModel.formValueMap['availableUntil'] =
        '2012-10-05T14:48:00.000Z';
        deploymentPlanEditViewModel.formValueMap['pdfPath'] =
        'test';
        deploymentPlanEditViewModel.setDepartment(Department(id: 1));

        await deploymentPlanEditViewModel.submitForm();
        expect(deploymentPlanEditViewModel.validationMessage, isNull);
        verify(deploymentPlanService.updateDeploymentPlan(
          1,
          description: 'bar',
        )).called(1);
        verify(dialogService.completeDialog(argThat(anything)));
      });
    });

    group('removeDeploymentPlan', () {
      test('removes deployment plan successfully as standalone', () async {
        deploymentPlanEditViewModel = DeploymentPlanEditViewModel(
          deploymentPlan: DeploymentPlan(id: 1),
        );
        final deploymentPlanService = getAndRegisterMockDeploymentPlanService();
        final navigationService = getAndRegisterMockNavigationService();

        await deploymentPlanEditViewModel.removeDeploymentPlan();
        expect(deploymentPlanEditViewModel.validationMessage, isNull);
        verify(deploymentPlanService.removeDeploymentPlan(1)).called(1);
        verify(navigationService.back(result: true));
      });

      test('removes deployment plan successfully as dialog', () async {
        deploymentPlanEditViewModel = DeploymentPlanEditViewModel(
          isDialog: true,
          deploymentPlan: DeploymentPlan(id: 1),
        );
        final deploymentPlanService = getAndRegisterMockDeploymentPlanService();
        final dialogService = getAndRegisterMockDialogService();

        await deploymentPlanEditViewModel.removeDeploymentPlan();
        expect(deploymentPlanEditViewModel.validationMessage, isNull);
        verify(deploymentPlanService.removeDeploymentPlan(1)).called(1);
        verify(dialogService.completeDialog(argThat(anything)));
      });
    });

    group('getDeploymentPlanTitle', () {
      test('returns subtitle', () {
        final deploymentPlanService = getAndRegisterMockDeploymentPlanService();

        deploymentPlanEditViewModel.getDeploymentPlanTitle(
          DeploymentPlan(),
        );
        verify(
          deploymentPlanService.getDeploymentPlanTitle(
            argThat(anything),
          ),
        ).called(1);
      });
    });

    group('getDeploymentPlanSubtitle', () {
      test('returns subtitle', () {
        final deploymentPlanService = getAndRegisterMockDeploymentPlanService();

        deploymentPlanEditViewModel.getDeploymentPlanSubtitle(
          DeploymentPlan(),
        );
        verify(
          deploymentPlanService.getDeploymentPlanAvailability(
            argThat(anything),
          ),
        ).called(1);
      });
    });
  });
}