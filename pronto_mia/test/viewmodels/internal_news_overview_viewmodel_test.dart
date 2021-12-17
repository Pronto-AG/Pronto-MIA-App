import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pronto_mia/core/models/internal_news.dart';
import 'package:pronto_mia/ui/shared/custom_dialogs.dart';

import 'package:pronto_mia/ui/views/internal_news/overview/internal_news_overview_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

import '../setup/test_helpers.dart';

void main() {
  group('InternalNewsOverviewViewModel', () {
    InternalNewsOverviewViewModel internalNewsOverviewViewModel;
    setUp(() {
      registerServices();
      internalNewsOverviewViewModel = InternalNewsOverviewViewModel();
    });
    tearDown(() => unregisterServices());

    group('futureToRun', () {
      test('returns available internal news on default mode', () async {
        final internalNewsService = getAndRegisterMockInternalNewsService();
        when(internalNewsService.getAvailableInternalNews()).thenAnswer(
          (realInvocation) => Future.value([InternalNews()]),
        );

        expect(
          await internalNewsOverviewViewModel.futureToRun(),
          hasLength(1),
        );
        verify(internalNewsService.getAvailableInternalNews()).called(1);
      });

      test('returns all internal news on admin mode', () async {
        internalNewsOverviewViewModel = InternalNewsOverviewViewModel(
          adminModeEnabled: true,
        );
        final internalNewsService = getAndRegisterMockInternalNewsService();
        when(internalNewsService.getInternalNews()).thenAnswer(
          (realInvocation) => Future.value([InternalNews()]),
        );

        expect(
          await internalNewsOverviewViewModel.futureToRun(),
          hasLength(1),
        );
        verify(internalNewsService.getInternalNews()).called(1);
      });
    });

    group('onError', () {
      test('calls error handling on error', () async {
        final errorService = getAndRegisterMockErrorService();
        when(errorService.getErrorMessage(captureAny)).thenReturn('test');

        await internalNewsOverviewViewModel.onError(Exception());
        expect(internalNewsOverviewViewModel.errorMessage, equals('test'));
        verify(
          errorService.handleError(
            'InternalNewsOverviewViewModel',
            argThat(isException),
          ),
        ).called(1);
        verify(errorService.getErrorMessage(argThat(isException))).called(1);
      });
    });

    group('editInternalNews', () {
      test('opens form as standalone without data change', () async {
        final navigationService = getAndRegisterMockNavigationService();

        await internalNewsOverviewViewModel.editInternalNews(
          internalNews: InternalNews(),
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

      //   await internalNewsOverviewViewModel.editInternalNews(
      //     internalNews: InternalNews(),
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
        final internalNewsService = getAndRegisterMockInternalNewsService();
        when(
          navigationService.navigateWithTransition(
            captureAny,
            transition: captureAnyNamed('transition'),
          ),
        ).thenAnswer(
          (realInvocation) => Future.value(true),
        );

        await internalNewsOverviewViewModel.editInternalNews(
          internalNews: InternalNews(),
        );
        verify(
          navigationService.navigateWithTransition(
            argThat(anything),
            transition: NavigationTransition.LeftToRight,
          ),
        ).called(1);
        verify(internalNewsService.getAvailableInternalNews()).called(1);
      });

      // test('opens form as dialog with data change', () async {
      //   final dialogService = getAndRegisterMockDialogService();
      //   final internalNewsService = getAndRegisterMockInternalNewsService();
      //   when(
      //     dialogService.showCustomDialog(
      //       variant: captureAnyNamed('variant'),
      //       title: 'opens form as dialog with data change',
      //       customData: captureAnyNamed('customData'),
      //     ),
      //   ).thenAnswer(
      //     (realInvocation) => Future.value(DialogResponse(confirmed: true)),
      //   );

      //   await internalNewsOverviewViewModel.editInternalNews(
      //     internalNews: InternalNews(),
      //     asDialog: true,
      //   );
      //   verifyNever(
      //     dialogService.showCustomDialog(
      //       variant: DialogType.custom,
      //       title: 'opens form as dialog with data change',
      //       customData: anyNamed('customData'),
      //     ),
      //   );
      //   verifyNever(internalNewsService.getAvailableInternalNews());
      // });
    });

    group('publishInternalNews', () {
      test('publishes internal news on dialog confirmed', () async {
        final dialogService = getAndRegisterMockDialogService();
        final internalNewsService = getAndRegisterMockInternalNewsService();
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

        await internalNewsOverviewViewModel.publishInternalNews(
          InternalNews(id: 1),
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
          internalNewsService.publishInternalNews(
            1,
            argThat(anything),
            argThat(anything),
          ),
        ).called(1);
      });

      test('does not publish on dialog cancel', () async {
        final dialogService = getAndRegisterMockDialogService();
        final internalNewsService = getAndRegisterMockInternalNewsService();

        await internalNewsOverviewViewModel.publishInternalNews(
          InternalNews(id: 1),
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
          internalNewsService.publishInternalNews(
            argThat(anything),
            argThat(anything),
            argThat(anything),
          ),
        );
      });
    });

    group('hideInternalNews', () {
      test('hides internal news on dialog confirmed', () async {
        final dialogService = getAndRegisterMockDialogService();
        final internalNewsService = getAndRegisterMockInternalNewsService();
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

        await internalNewsOverviewViewModel.hideInternalNews(
          InternalNews(id: 1),
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
        verify(internalNewsService.hideInternalNews(1)).called(1);
      });

      test('does not hide on dialog cancel', () async {
        final dialogService = getAndRegisterMockDialogService();
        final internalNewsService = getAndRegisterMockInternalNewsService();

        await internalNewsOverviewViewModel.hideInternalNews(
          InternalNews(id: 1),
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
          internalNewsService.hideInternalNews(argThat(anything)),
        );
      });
    });

    group('getInternalNewsTitle', () {
      test('returns title', () {
        final internalNewsService = getAndRegisterMockInternalNewsService();

        internalNewsOverviewViewModel.getInternalNewsTitle(
          InternalNews(),
        );
        verify(internalNewsService.getInternalNewsTitle(argThat(anything)));
      });
    });

    group('getInternalNewsDate', () {
      test('returns date', () {
        final internalNewsService = getAndRegisterMockInternalNewsService();

        internalNewsOverviewViewModel.getInternalNewsDate(
          InternalNews(),
        );
        verify(
          internalNewsService.getInternalNewsDate(
            argThat(anything),
          ),
        );
      });
    });

    group('getInternalNewsImage', () {
      test('returns image', () {
        final internalNewsService = getAndRegisterMockInternalNewsService();

        internalNewsOverviewViewModel.getInternalNewsImage(
          InternalNews(),
        );
        verify(
          internalNewsService.getInternalNewsImage(
            argThat(anything),
          ),
        );
      });
    });

    group('filterInternalNews', () {
      test('returns correct result', () async {
        final internalNewsService = getAndRegisterMockInternalNewsService();
        await internalNewsOverviewViewModel.filterInternalNews('test');
        verify(
          internalNewsService.filterInternalNews(
            argThat(anything),
          ),
        ).called(1);
      });
    });

    group('openInternalNews', () {
      test('opens internal news', () async {
        final navigationService = getAndRegisterMockNavigationService();

        await internalNewsOverviewViewModel.openInternalNews(InternalNews(
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
      test('removes more than one internal news', () async {
        final internalNewsService = getAndRegisterMockInternalNewsService();

        await internalNewsOverviewViewModel.removeItems(
          <InternalNews>[
            InternalNews(
              id: 1,
              title: 'test',
              description: 'test',
              availableFrom: DateTime.now(),
            ),
            InternalNews(
              id: 2,
              title: 'test',
              description: 'test',
              availableFrom: DateTime.now(),
            ),
          ],
        );
        verify(
          internalNewsService.removeInternalNews(
            argThat(anything),
          ),
        ).called(2);
      });
    });

    group('dispose', () {
      test('removes listener from service', () {
        final internalNewsService = getAndRegisterMockInternalNewsService();

        internalNewsOverviewViewModel.dispose();
        verify(
          internalNewsService.removeListener(argThat(anything)),
        ).called(1);
      });
    });
  });
}
