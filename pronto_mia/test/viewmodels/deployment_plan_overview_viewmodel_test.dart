import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pronto_mia/core/models/deployment_plan.dart';
import 'package:pronto_mia/ui/shared/custom_dialogs.dart';

import 'package:pronto_mia/ui/views/deployment_plan/overview/deployment_plan_overview_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

import '../setup/test_helpers.dart';

void main() {
  group('DeploymentPlanOverviewViewModel', () {
    DeploymentPlanOverviewViewModel deploymentPlanOverviewViewModel;
    setUp(() {
      registerServices();
      deploymentPlanOverviewViewModel = DeploymentPlanOverviewViewModel();
    });
    tearDown(() => unregisterServices());

    group('futureToRun', () {
      test('returns available departments on default mode', () async {
        final deploymentPlanService = getAndRegisterMockDeploymentPlanService();
        when(deploymentPlanService.getAvailableDeploymentPlans()).thenAnswer(
          (realInvocation) => Future.value([DeploymentPlan()]),
        );

        expect(
          await deploymentPlanOverviewViewModel.futureToRun(),
          hasLength(1),
        );
        verify(deploymentPlanService.getAvailableDeploymentPlans()).called(1);
      });

      test('returns all departments on admin mode', () async {
        deploymentPlanOverviewViewModel = DeploymentPlanOverviewViewModel(
          adminModeEnabled: true,
        );
        final deploymentPlanService = getAndRegisterMockDeploymentPlanService();
        when(deploymentPlanService.getDeploymentPlans()).thenAnswer(
          (realInvocation) => Future.value([DeploymentPlan()]),
        );

        expect(
          await deploymentPlanOverviewViewModel.futureToRun(),
          hasLength(1),
        );
        verify(deploymentPlanService.getDeploymentPlans()).called(1);
      });
    });

    group('onError', () {
      test('calls error handling on error', () async {
        final errorService = getAndRegisterMockErrorService();
        when(errorService.getErrorMessage(captureAny)).thenReturn('test');

        await deploymentPlanOverviewViewModel.onError(Exception());
        expect(deploymentPlanOverviewViewModel.errorMessage, equals('test'));
        verify(
          errorService.handleError(
            'DeploymentPlanOverviewViewModel',
            argThat(isException),
          ),
        ).called(1);
        verify(errorService.getErrorMessage(argThat(isException))).called(1);
      });
    });

    group('openPdf', () {
      test('opens PDF', () async {
        final deploymentPlanService = getAndRegisterMockDeploymentPlanService();

        await deploymentPlanOverviewViewModel.openPdf(DeploymentPlan());
        verify(deploymentPlanService.openPdf(argThat(anything))).called(1);
      });
    });

    group('editDeploymentPlan', () {
      test('opens form as standalone without data change', () async {
        final navigationService = getAndRegisterMockNavigationService();

        await deploymentPlanOverviewViewModel.editDeploymentPlan(
          deploymentPlan: DeploymentPlan(),
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

        await deploymentPlanOverviewViewModel.editDeploymentPlan(
          deploymentPlan: DeploymentPlan(),
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
        final deploymentPlanService = getAndRegisterMockDeploymentPlanService();
        when(
          navigationService.navigateWithTransition(
            captureAny,
            transition: captureAnyNamed('transition'),
          ),
        ).thenAnswer(
          (realInvocation) => Future.value(true),
        );

        await deploymentPlanOverviewViewModel.editDeploymentPlan(
          deploymentPlan: DeploymentPlan(),
        );
        verify(
          navigationService.navigateWithTransition(
            argThat(anything),
            transition: NavigationTransition.LeftToRight,
          ),
        ).called(1);
        verify(deploymentPlanService.getAvailableDeploymentPlans()).called(1);
      });

      test('opens form as dialog with data change', () async {
        final dialogService = getAndRegisterMockDialogService();
        final deploymentPlanService = getAndRegisterMockDeploymentPlanService();
        when(
          dialogService.showCustomDialog(
            variant: captureAnyNamed('variant'),
            title: 'opens form as dialog with data change',
            customData: captureAnyNamed('customData'),
          ),
        ).thenAnswer(
          (realInvocation) => Future.value(DialogResponse(confirmed: true)),
        );

        await deploymentPlanOverviewViewModel.editDeploymentPlan(
          deploymentPlan: DeploymentPlan(),
          asDialog: true,
        );
        verifyNever(
          dialogService.showCustomDialog(
            variant: DialogType.custom,
            title: 'opens form as dialog with data change',
            customData: anyNamed('customData'),
          ),
        );
        verifyNever(deploymentPlanService.getAvailableDeploymentPlans());
      });
    });

    group('publishDeploymentPlan', () {
      test('publishes deployment plan on dialog confirmed', () async {
        final dialogService = getAndRegisterMockDialogService();
        final deploymentPlanService = getAndRegisterMockDeploymentPlanService();
        when(
          dialogService.showConfirmationDialog(
            title: captureAnyNamed('title'),
            description: captureAnyNamed('description'),
            cancelTitle: captureAnyNamed('cancelTitle'),
            confirmationTitle: captureAnyNamed('confirmationTitle'),
            barrierDismissible: captureAnyNamed('barrierDismissible'),
            dialogPlatform: captureAnyNamed('dialogPlatform'),
          ),
        ).thenAnswer(
          (realInvocation) => Future.value(DialogResponse(confirmed: true)),
        );

        await deploymentPlanOverviewViewModel.publishDeploymentPlan(
          DeploymentPlan(id: 1),
        );
        verify(
          dialogService.showConfirmationDialog(
            title: 'Einsatzplan veröffentlichen',
            description:
                'Wollen sie den Einsatzplan "null" wirklich veröffentlichen?',
            cancelTitle: 'Nein',
            confirmationTitle: 'Ja',
            barrierDismissible: false,
            dialogPlatform: DialogPlatform.Material,
          ),
        ).called(1);
        verify(
          deploymentPlanService.publishDeploymentPlan(
            1,
            argThat(anything),
            argThat(anything),
          ),
        ).called(1);
      });

      test('does not publish on dialog cancel', () async {
        final dialogService = getAndRegisterMockDialogService();
        final deploymentPlanService = getAndRegisterMockDeploymentPlanService();

        await deploymentPlanOverviewViewModel.publishDeploymentPlan(
          DeploymentPlan(id: 1),
        );
        verify(
          dialogService.showConfirmationDialog(
            title: 'Einsatzplan veröffentlichen',
            description:
                'Wollen sie den Einsatzplan "null" wirklich veröffentlichen?',
            cancelTitle: 'Nein',
            confirmationTitle: 'Ja',
            barrierDismissible: false,
            dialogPlatform: DialogPlatform.Material,
          ),
        ).called(1);
        verifyNever(
          deploymentPlanService.publishDeploymentPlan(
            argThat(anything),
            argThat(anything),
            argThat(anything),
          ),
        );
      });
    });

    group('hideDeploymentPlan', () {
      test('hides deployment plan on dialog confirmed', () async {
        final dialogService = getAndRegisterMockDialogService();
        final deploymentPlanService = getAndRegisterMockDeploymentPlanService();
        when(
          dialogService.showConfirmationDialog(
            title: captureAnyNamed('title'),
            description: captureAnyNamed('description'),
            cancelTitle: captureAnyNamed('cancelTitle'),
            confirmationTitle: captureAnyNamed('confirmationTitle'),
            barrierDismissible: captureAnyNamed('barrierDismissible'),
            dialogPlatform: captureAnyNamed('dialogPlatform'),
          ),
        ).thenAnswer(
          (realInvocation) => Future.value(DialogResponse(confirmed: true)),
        );

        await deploymentPlanOverviewViewModel.hideDeploymentPlan(
          DeploymentPlan(id: 1),
        );
        verify(
          dialogService.showConfirmationDialog(
            title: 'Einsatzplan verstecken',
            description:
                'Wollen sie den Einsatzplan "null" wirklich verstecken?',
            cancelTitle: 'Nein',
            confirmationTitle: 'Ja',
            barrierDismissible: false,
            dialogPlatform: DialogPlatform.Material,
          ),
        ).called(1);
        verify(deploymentPlanService.hideDeploymentPlan(1)).called(1);
      });

      test('does not hide on dialog cancel', () async {
        final dialogService = getAndRegisterMockDialogService();
        final deploymentPlanService = getAndRegisterMockDeploymentPlanService();

        await deploymentPlanOverviewViewModel.hideDeploymentPlan(
          DeploymentPlan(id: 1),
        );
        verify(
          dialogService.showConfirmationDialog(
            title: 'Einsatzplan verstecken',
            description:
                'Wollen sie den Einsatzplan "null" wirklich verstecken?',
            cancelTitle: 'Nein',
            confirmationTitle: 'Ja',
            barrierDismissible: false,
            dialogPlatform: DialogPlatform.Material,
          ),
        ).called(1);
        verifyNever(
          deploymentPlanService.hideDeploymentPlan(argThat(anything)),
        );
      });
    });

    group('getDeploymentPlanTitle', () {
      test('returns title', () {
        final deploymentPlanService = getAndRegisterMockDeploymentPlanService();

        deploymentPlanOverviewViewModel.getDeploymentPlanTitle(
          DeploymentPlan(),
        );
        verify(deploymentPlanService.getDeploymentPlanTitle(argThat(anything)));
      });
    });

    group('getDeploymentPlanSubTitle', () {
      test('returns subtitle', () {
        final deploymentPlanService = getAndRegisterMockDeploymentPlanService();

        deploymentPlanOverviewViewModel.getDeploymentPlanSubtitle(
          DeploymentPlan(),
        );
        verify(
          deploymentPlanService.getDeploymentPlanAvailability(
            argThat(anything),
          ),
        );
      });
    });

    group('removeItems', () {
      test('removes more than one deployment plan', () async {
        final deploymentPlanService = getAndRegisterMockDeploymentPlanService();

        await deploymentPlanOverviewViewModel.removeItems(
          <DeploymentPlan>[
            DeploymentPlan(
              id: 1,
            ),
            DeploymentPlan(
              id: 2,
            ),
          ],
        );
        verify(
          deploymentPlanService.removeDeploymentPlan(
            argThat(anything),
          ),
        ).called(2);
      });
    });

    group('filterDeploymentPlans', () {
      test('filters a deployment plan', () async {
        final deploymentPlanService = getAndRegisterMockDeploymentPlanService();

        await deploymentPlanOverviewViewModel.filterDeploymentPlans(
          'test',
        );
        verify(
          deploymentPlanService.filterDeploymentPlan(
            argThat(anything),
          ),
        ).called(1);
      });
    });

    group('dispose', () {
      test('removes listener from service', () {
        final deploymentPlanService = getAndRegisterMockDeploymentPlanService();

        deploymentPlanOverviewViewModel.dispose();
        verify(
          deploymentPlanService.removeListener(argThat(anything)),
        ).called(1);
      });
    });
  });
}
