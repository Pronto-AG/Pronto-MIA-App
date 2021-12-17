import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pronto_mia/core/models/external_news.dart';
import 'package:pronto_mia/ui/shared/custom_dialogs.dart';

import 'package:pronto_mia/ui/views/external_news/overview/external_news_overview_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

import '../setup/test_helpers.dart';

void main() {
  group('ExternalNewsOverviewViewModel', () {
    ExternalNewsOverviewViewModel externalNewsOverviewViewModel;
    setUp(() {
      registerServices();
      externalNewsOverviewViewModel = ExternalNewsOverviewViewModel();
    });
    tearDown(() => unregisterServices());

    group('futureToRun', () {
      test('returns available external news on default mode', () async {
        final externalNewsService = getAndRegisterMockExternalNewsService();
        when(externalNewsService.getAvailableExternalNews()).thenAnswer(
          (realInvocation) => Future.value([ExternalNews()]),
        );

        expect(
          await externalNewsOverviewViewModel.futureToRun(),
          hasLength(1),
        );
        verify(externalNewsService.getAvailableExternalNews()).called(1);
      });

      test('returns all external news on admin mode', () async {
        externalNewsOverviewViewModel = ExternalNewsOverviewViewModel(
          adminModeEnabled: true,
        );
        final externalNewsService = getAndRegisterMockExternalNewsService();
        when(externalNewsService.getExternalNews()).thenAnswer(
          (realInvocation) => Future.value([ExternalNews()]),
        );

        expect(
          await externalNewsOverviewViewModel.futureToRun(),
          hasLength(1),
        );
        verify(externalNewsService.getExternalNews()).called(1);
      });
    });

    group('onError', () {
      test('calls error handling on error', () async {
        final errorService = getAndRegisterMockErrorService();
        when(errorService.getErrorMessage(captureAny)).thenReturn('test');

        await externalNewsOverviewViewModel.onError(Exception());
        expect(externalNewsOverviewViewModel.errorMessage, equals('test'));
        verify(
          errorService.handleError(
            'ExternalNewsOverviewViewModel',
            argThat(isException),
          ),
        ).called(1);
        verify(errorService.getErrorMessage(argThat(isException))).called(1);
      });
    });

    group('editExternalNews', () {
      test('opens form as standalone without data change', () async {
        final navigationService = getAndRegisterMockNavigationService();

        await externalNewsOverviewViewModel.editExternalNews(
          externalNews: ExternalNews(),
        );
        verify(
          navigationService.navigateWithTransition(
            argThat(anything),
            transition: NavigationTransition.LeftToRight,
          ),
        ).called(1);
      });

      // test('opens form as dialog without data change', () async {
      //   final dialogService = getAndRegisterMockDialogService();

      //   await externalNewsOverviewViewModel.editExternalNews(
      //     externalNews: ExternalNews(),
      //     asDialog: true,
      //   );
      //   verifyNever(
      //     dialogService.showCustomDialog(
      //       variant: DialogType.custom,
      //       title: 'opens form as dialog without data change',
      //       customData: anyNamed('customData'),
      //     ),
      //   );
      // });

      test('opens form as standalone with data change', () async {
        final navigationService = getAndRegisterMockNavigationService();
        final externalNewsService = getAndRegisterMockExternalNewsService();
        when(
          navigationService.navigateWithTransition(
            captureAny,
            transition: captureAnyNamed('transition'),
          ),
        ).thenAnswer(
          (realInvocation) => Future.value(true),
        );

        await externalNewsOverviewViewModel.editExternalNews(
          externalNews: ExternalNews(),
        );
        verify(
          navigationService.navigateWithTransition(
            argThat(anything),
            transition: NavigationTransition.LeftToRight,
          ),
        ).called(1);
        verify(externalNewsService.getAvailableExternalNews()).called(1);
      });

      // test('opens form as dialog with data change', () async {
      //   final dialogService = getAndRegisterMockDialogService();
      //   final externalNewsService = getAndRegisterMockExternalNewsService();
      //   when(
      //     dialogService.showCustomDialog(
      //       variant: captureAnyNamed('variant'),
      //       title: 'opens form as dialog with data change',
      //       customData: captureAnyNamed('customData'),
      //     ),
      //   ).thenAnswer(
      //     (realInvocation) => Future.value(DialogResponse(confirmed: true)),
      //   );

      //   await externalNewsOverviewViewModel.editExternalNews(
      //     externalNews: ExternalNews(),
      //     asDialog: true,
      //   );
      //   verifyNever(
      //     dialogService.showCustomDialog(
      //       variant: DialogType.custom,
      //       title: 'opens form as dialog with data change',
      //       customData: anyNamed('customData'),
      //     ),
      //   );
      //   verifyNever(externalNewsService.getAvailableExternalNews());
      // });
    });

    group('publishExternalNews', () {
      test('publishes external news on dialog confirmed', () async {
        final dialogService = getAndRegisterMockDialogService();
        final externalNewsService = getAndRegisterMockExternalNewsService();
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

        await externalNewsOverviewViewModel.publishExternalNews(
          ExternalNews(id: 1),
        );
        verify(
          dialogService.showConfirmationDialog(
            title: 'Neuigkeit veröffentlichen',
            description:
                'Wollen sie die Neuigkeit "null" wirklich veröffentlichen?',
            cancelTitle: 'Nein',
            confirmationTitle: 'Ja',
            barrierDismissible: false,
            dialogPlatform: DialogPlatform.Material,
          ),
        ).called(1);
        verify(
          externalNewsService.publishExternalNews(
            1,
            argThat(anything),
            argThat(anything),
          ),
        ).called(1);
      });

      test('does not publish on dialog cancel', () async {
        final dialogService = getAndRegisterMockDialogService();
        final externalNewsService = getAndRegisterMockExternalNewsService();

        await externalNewsOverviewViewModel.publishExternalNews(
          ExternalNews(id: 1),
        );
        verify(
          dialogService.showConfirmationDialog(
            title: 'Neuigkeit veröffentlichen',
            description:
                'Wollen sie die Neuigkeit "null" wirklich veröffentlichen?',
            cancelTitle: 'Nein',
            confirmationTitle: 'Ja',
            barrierDismissible: false,
            dialogPlatform: DialogPlatform.Material,
          ),
        ).called(1);
        verifyNever(
          externalNewsService.publishExternalNews(
            argThat(anything),
            argThat(anything),
            argThat(anything),
          ),
        );
      });
    });

    group('hideExternalNews', () {
      test('hides external news on dialog confirmed', () async {
        final dialogService = getAndRegisterMockDialogService();
        final externalNewsService = getAndRegisterMockExternalNewsService();
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

        await externalNewsOverviewViewModel.hideExternalNews(
          ExternalNews(id: 1),
        );
        verify(
          dialogService.showConfirmationDialog(
            title: 'Neuigkeit verstecken',
            description: 'Wollen sie die Neuigkeit "null" wirklich verstecken?',
            cancelTitle: 'Nein',
            confirmationTitle: 'Ja',
            barrierDismissible: false,
            dialogPlatform: DialogPlatform.Material,
          ),
        ).called(1);
        verify(externalNewsService.hideExternalNews(1)).called(1);
      });

      test('does not hide on dialog cancel', () async {
        final dialogService = getAndRegisterMockDialogService();
        final externalNewsService = getAndRegisterMockExternalNewsService();

        await externalNewsOverviewViewModel.hideExternalNews(
          ExternalNews(id: 1),
        );
        verify(
          dialogService.showConfirmationDialog(
            title: 'Neuigkeit verstecken',
            description: 'Wollen sie die Neuigkeit "null" wirklich verstecken?',
            cancelTitle: 'Nein',
            confirmationTitle: 'Ja',
            barrierDismissible: false,
            dialogPlatform: DialogPlatform.Material,
          ),
        ).called(1);
        verifyNever(
          externalNewsService.hideExternalNews(argThat(anything)),
        );
      });
    });

    group('getExternalNewsTitle', () {
      test('returns title', () {
        final externalNewsService = getAndRegisterMockExternalNewsService();

        externalNewsOverviewViewModel.getExternalNewsTitle(
          ExternalNews(),
        );
        verify(externalNewsService.getExternalNewsTitle(argThat(anything)));
      });
    });

    group('getExternalNewsDate', () {
      test('returns date', () {
        final externalNewsService = getAndRegisterMockExternalNewsService();

        externalNewsOverviewViewModel.getExternalNewsDate(
          ExternalNews(),
        );
        verify(
          externalNewsService.getExternalNewsDate(
            argThat(anything),
          ),
        );
      });
    });

    group('getExternalNewsImage', () {
      test('returns image', () {
        final externalNewsService = getAndRegisterMockExternalNewsService();

        externalNewsOverviewViewModel.getExternalNewsImage(
          ExternalNews(),
        );
        verify(
          externalNewsService.getExternalNewsImage(
            argThat(anything),
          ),
        );
      });
    });

    group('filterExternalNews', () {
      test('returns correct result', () async {
        final externalNewsService = getAndRegisterMockExternalNewsService();
        await externalNewsOverviewViewModel.filterExternalNews('test');
        verify(
          externalNewsService.filterExternalNews(
            argThat(anything),
          ),
        ).called(1);
      });
    });

    group('openExternalNews', () {
      test('opens external news', () async {
        final navigationService = getAndRegisterMockNavigationService();

        await externalNewsOverviewViewModel.openExternalNews(ExternalNews(
          id: 1,
          title: 'test',
          description: 'test',
          availableFrom: DateTime.now(),
        ));
        verify(
          navigationService.navigateWithTransition(
            argThat(anything),
          ),
        ).called(1);
      });
    });

    group('removeItems', () {
      test('removes more than one external news', () async {
        final externalNewsService = getAndRegisterMockExternalNewsService();

        await externalNewsOverviewViewModel.removeItems(
          <ExternalNews>[
            ExternalNews(
              id: 1,
              title: 'test',
              description: 'test',
              availableFrom: DateTime.now(),
            ),
            ExternalNews(
              id: 2,
              title: 'test',
              description: 'test',
              availableFrom: DateTime.now(),
            ),
          ],
        );
        verify(
          externalNewsService.removeExternalNews(
            argThat(anything),
          ),
        ).called(2);
      });
    });

    group('dispose', () {
      test('removes listener from service', () {
        final externalNewsService = getAndRegisterMockExternalNewsService();

        externalNewsOverviewViewModel.dispose();
        verify(
          externalNewsService.removeListener(argThat(anything)),
        ).called(1);
      });
    });
  });
}
