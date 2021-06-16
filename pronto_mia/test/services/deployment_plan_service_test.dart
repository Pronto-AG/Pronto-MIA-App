import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:pronto_mia/core/models/deployment_plan.dart';
import 'package:pronto_mia/core/models/simple_file.dart';
import 'package:pronto_mia/core/queries/deployment_plan_queries.dart';
import 'package:pronto_mia/core/services/deployment_plan_service.dart';
import 'package:stacked_services/stacked_services.dart';

import '../setup/test_helpers.dart';

void main() {
  group('DeploymentPlanService', () {
    DeploymentPlanService deploymentPlanService;
    setUp(() {
      registerServices();
      deploymentPlanService = DeploymentPlanService();
    });
    tearDown(() => unregisterServices());

    group('getDeploymentPlans', () {
      test('returns deployment plans', () async {
        final graphQLService = getAndRegisterMockGraphQLService();
        when(
          graphQLService.query(
            captureAny,
            variables: captureAnyNamed('variables'),
            useCache: captureAnyNamed('useCache'),
          ),
        ).thenAnswer(
          (realInvocation) => Future.value({
            'deploymentPlans': [
              {
                'id': 1,
                'description': 'test',
                'availableFrom': DateTime.now().toIso8601String(),
                'availableUntil': DateTime.now().toIso8601String(),
              }
            ]
          }),
        );

        expect(await deploymentPlanService.getDeploymentPlans(), hasLength(1));
        verify(
          graphQLService.query(DeploymentPlanQueries.deploymentPlans),
        ).called(1);
      });
    });

    group('getDeploymentPlan', () {
      test('returns deployment plan', () async {
        final graphQLService = getAndRegisterMockGraphQLService();
        when(
          graphQLService.query(
            captureAny,
            variables: captureAnyNamed('variables'),
            useCache: captureAnyNamed('useCache'),
          ),
        ).thenAnswer(
          (realInvocation) => Future.value({
            'deploymentPlans': [
              {
                'id': 1,
                'description': 'test',
                'availableFrom': DateTime.now().toIso8601String(),
                'availableUntil': DateTime.now().toIso8601String(),
              }
            ]
          }),
        );

        expect(await deploymentPlanService.getDeploymentPlan(1), isNotNull);
        verify(
          graphQLService.query(
            DeploymentPlanQueries.deploymentPlanById,
            variables: {'id': 1},
          ),
        ).called(1);
      });
    });

    group('getAvailableDeploymentPlans', () {
      test('returns deployment plans', () async {
        final graphQLService = getAndRegisterMockGraphQLService();
        when(
          graphQLService.query(
            captureAny,
            variables: captureAnyNamed('variables'),
            useCache: captureAnyNamed('useCache'),
          ),
        ).thenAnswer(
          (realInvocation) => Future.value({
            'deploymentPlans': [
              {
                'id': 1,
                'description': 'test',
                'availableFrom': DateTime.now().toIso8601String(),
                'availableUntil': DateTime.now().toIso8601String(),
              }
            ]
          }),
        );

        expect(
          await deploymentPlanService.getAvailableDeploymentPlans(),
          hasLength(1),
        );
        verify(
          graphQLService.query(
            DeploymentPlanQueries.deploymentPlansAvailableUntil,
            variables: {'availableUntil': anything},
          ),
        ).called(1);
      });
    });

    group('createDeploymentPlan', () {
      test('creates deployment plan', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await deploymentPlanService.createDeploymentPlan(
          'test',
          DateTime.now(),
          DateTime.now(),
          SimpleFile(name: 'test.pdf', bytes: Uint8List(5)),
          1,
        );
        verify(
          graphQLService.mutate(
            DeploymentPlanQueries.createDeploymentPlan,
            variables: {
              'description': 'test',
              'availableFrom': anything,
              'availableUntil': anything,
              'file': anything,
              'departmentId': 1,
            },
          ),
        ).called(1);
      });
    });

    group('updateDeploymentPlan', () {
      test('updates deployment plan description', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await deploymentPlanService.updateDeploymentPlan(
          1,
          description: 'test',
        );
        verify(
          graphQLService.mutate(
            DeploymentPlanQueries.updateDeploymentPlan,
            variables: {
              'id': 1,
              'description': 'test',
              'availableFrom': null,
              'availableUntil': null,
              'departmentId': null,
            },
          ),
        ).called(1);
      });

      test('updates deployment plan pdf', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await deploymentPlanService.updateDeploymentPlan(
          1,
          pdfFile: SimpleFile(name: 'test.pdf', bytes: Uint8List(5)),
        );
        verify(
          graphQLService.mutate(
            DeploymentPlanQueries.updateDeploymentPlan,
            variables: {
              'id': 1,
              'file': isNotNull,
              'description': null,
              'availableFrom': null,
              'availableUntil': null,
              'departmentId': null,
            },
          ),
        ).called(1);
      });
    });

    group('removeDeploymentPlan', () {
      test('removes deployment plan', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await deploymentPlanService.removeDeploymentPlan(1);
        verify(
          graphQLService.mutate(
            DeploymentPlanQueries.removeDeploymentPlan,
            variables: {'id': 1},
          ),
        ).called(1);
      });
    });

    group('publishDeploymentPlan', () {
      test('publishes deployment plan', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await deploymentPlanService.publishDeploymentPlan(1, 'foo', 'bar');
        verify(
          graphQLService.mutate(
            DeploymentPlanQueries.publishDeploymentPlan,
            variables: {
              'id': 1,
              'title': 'foo',
              'body': 'bar',
            },
          ),
        ).called(1);
      });
    });

    group('hideDeploymentPlan', () {
      test('hides deployment plan', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await deploymentPlanService.hideDeploymentPlan(1);
        verify(
          graphQLService.mutate(
            DeploymentPlanQueries.hideDeploymentPlan,
            variables: {'id': 1},
          ),
        ).called(1);
      });
    });

    group('openPdfSimpleFile', () {
      test('opens pdf with simple file', () async {
        final navigationService = getAndRegisterMockNavigationService();

        await deploymentPlanService.openPdfSimpleFile(SimpleFile());
        verify(
          navigationService.navigateWithTransition(
            argThat(anything),
            transition: NavigationTransition.LeftToRight,
          ),
        ).called(1);
      });
    });

    group('openPdf', () {
      test('opens pdf with deployment plan', () async {
        final navigationService = getAndRegisterMockNavigationService();

        await deploymentPlanService.openPdf(DeploymentPlan(
          id: 1,
          description: 'test',
          availableFrom: DateTime.now(),
          availableUntil: DateTime.now(),
        ));
        verify(
          navigationService.navigateWithTransition(
            argThat(anything),
            transition: NavigationTransition.LeftToRight,
          ),
        ).called(1);
      });
    });

    group('openPdfWithReplace', () {
      test('opens pdf with deployment plan and replace transition', () async {
        final navigationService = getAndRegisterMockNavigationService();

        await deploymentPlanService.openPdfWithReplace(DeploymentPlan(
          id: 1,
          description: 'test',
          availableFrom: DateTime.now(),
          availableUntil: DateTime.now(),
        ));
        verify(
          navigationService.replaceWithTransition(
            argThat(anything),
            transition: NavigationTransition.LeftToRight,
          ),
        ).called(1);
      });
    });

    group('getDeploymentPlanTitle', () {
      test('returns title with description', () {
        expect(
            deploymentPlanService.getDeploymentPlanTitle(DeploymentPlan(
              description: 'test',
              availableFrom: DateTime(2021),
              availableUntil: DateTime(2022),
            )),
            equals('test'));
      });

      test('returns title without description', () {
        expect(
            deploymentPlanService.getDeploymentPlanTitle(DeploymentPlan(
              availableFrom: DateTime(2021),
              availableUntil: DateTime(2022),
            )),
            equals('Einsatzplan 01.01.2021'));
      });
    });

    group('getDeploymentPlanAvailability', () {
      test('returns correct availability format', () {
        expect(
            deploymentPlanService.getDeploymentPlanAvailability(
              DeploymentPlan(
                availableFrom: DateTime(2021),
                availableUntil: DateTime(2022),
              ),
            ),
            equals('01.01.2021 00:00 - 01.01.2022 00:00'));
      });
    });
  });
}
