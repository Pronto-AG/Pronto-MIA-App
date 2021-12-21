import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pronto_mia/core/models/educational_content.dart';
import 'package:pronto_mia/ui/shared/custom_dialogs.dart';

import 'package:pronto_mia/ui/views/educational_content/overview/educational_content_overview_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

import '../setup/test_helpers.dart';

void main() {
  group('EducationalContentOverviewViewModel', () {
    EducationalContentOverviewViewModel educationalContentOverviewViewModel;
    setUp(() {
      registerServices();
      educationalContentOverviewViewModel =
          EducationalContentOverviewViewModel();
    });
    tearDown(() => unregisterServices());

    group('futureToRun', () {
      test('returns available educational content on default mode', () async {
        final educationalContentService =
            getAndRegisterMockEducationalContentService();
        when(educationalContentService.getAvailableEducationalContent())
            .thenAnswer(
          (realInvocation) => Future.value([EducationalContent()]),
        );

        expect(
          await educationalContentOverviewViewModel.futureToRun(),
          hasLength(1),
        );
        verify(educationalContentService.getAvailableEducationalContent())
            .called(1);
      });

      test('returns all educational content on admin mode', () async {
        educationalContentOverviewViewModel =
            EducationalContentOverviewViewModel(
          adminModeEnabled: true,
        );
        final educationalContentService =
            getAndRegisterMockEducationalContentService();
        when(educationalContentService.getEducationalContent()).thenAnswer(
          (realInvocation) => Future.value([EducationalContent()]),
        );

        expect(
          await educationalContentOverviewViewModel.futureToRun(),
          hasLength(1),
        );
        verify(educationalContentService.getEducationalContent()).called(1);
      });
    });

    group('onError', () {
      test('calls error handling on error', () async {
        final errorService = getAndRegisterMockErrorService();
        when(errorService.getErrorMessage(captureAny)).thenReturn('test');

        await educationalContentOverviewViewModel.onError(Exception());
        expect(
            educationalContentOverviewViewModel.errorMessage, equals('test'));
        verify(
          errorService.handleError(
            'EducationalContentOverviewViewModel',
            argThat(isException),
          ),
        ).called(1);
        verify(errorService.getErrorMessage(argThat(isException))).called(1);
      });
    });

    group('editEducationalContent', () {
      test('opens form as standalone without data change', () async {
        final navigationService = getAndRegisterMockNavigationService();

        await educationalContentOverviewViewModel.editEducationalContent(
          educationalContent: EducationalContent(),
        );
        verify(
          navigationService.navigateWithTransition(
            argThat(anything),
            transition: NavigationTransition.LeftToRight,
          ),
        ).called(1);
      });

      group('getEducationalContentFileExtension', () {
        test('calls service', () {
          final educationalContentService =
              getAndRegisterMockEducationalContentService();
          educationalContentOverviewViewModel
              .getEducationalContentFileExtension(EducationalContent(
                  title: "test",
                  description: 'test',
                  link: "https://localhost/test.mp4"));
          verify(
            educationalContentService.getEducationalContentFileExtension(
              argThat(anything),
            ),
          ).called(1);
        });
      });

      group('openPdf', () {
        test('opens a view containing a pdf', () {
          final educationalContentService =
              getAndRegisterMockEducationalContentService();
          educationalContentOverviewViewModel.openPdf(EducationalContent(
              title: "test",
              description: 'test',
              link: "https://localhost/test.mp4"));
          verify(
            educationalContentService.openPdf(
              argThat(anything),
            ),
          ).called(1);
        });
      });

      test('opens form as standalone with data change', () async {
        final navigationService = getAndRegisterMockNavigationService();
        final educationalContentService =
            getAndRegisterMockEducationalContentService();
        when(
          navigationService.navigateWithTransition(
            captureAny,
            transition: captureAnyNamed('transition'),
          ),
        ).thenAnswer(
          (realInvocation) => Future.value(true),
        );

        await educationalContentOverviewViewModel.editEducationalContent(
          educationalContent: EducationalContent(),
        );
        verify(
          navigationService.navigateWithTransition(
            argThat(anything),
            transition: NavigationTransition.LeftToRight,
          ),
        ).called(1);
        verify(educationalContentService.getAvailableEducationalContent())
            .called(1);
      });
    });

    group('publishEducationalContent', () {
      test('publishes educational content on dialog confirmed', () async {
        final dialogService = getAndRegisterMockDialogService();
        final educationalContentService =
            getAndRegisterMockEducationalContentService();
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

        await educationalContentOverviewViewModel.publishEducationalContent(
          EducationalContent(id: 1),
        );
        verify(
          dialogService.showConfirmationDialog(
            title: 'Schulungsvideo veröffentlichen',
            description:
                'Wollen sie das Schulungsvideo "null" wirklich veröffentlichen?',
            cancelTitle: 'Nein',
            confirmationTitle: 'Ja',
            barrierDismissible: false,
            dialogPlatform: DialogPlatform.Material,
          ),
        ).called(1);
        verify(
          educationalContentService.publishEducationalContent(
            1,
            argThat(anything),
            argThat(anything),
          ),
        ).called(1);
      });

      test('does not publish on dialog cancel', () async {
        final dialogService = getAndRegisterMockDialogService();
        final educationalContentService =
            getAndRegisterMockEducationalContentService();

        await educationalContentOverviewViewModel.publishEducationalContent(
          EducationalContent(id: 1),
        );
        verify(
          dialogService.showConfirmationDialog(
            title: 'Schulungsvideo veröffentlichen',
            description:
                'Wollen sie das Schulungsvideo "null" wirklich veröffentlichen?',
            cancelTitle: 'Nein',
            confirmationTitle: 'Ja',
            barrierDismissible: false,
            dialogPlatform: DialogPlatform.Material,
          ),
        ).called(1);
        verifyNever(
          educationalContentService.publishEducationalContent(
            argThat(anything),
            argThat(anything),
            argThat(anything),
          ),
        );
      });
    });

    group('hideEducationalContent', () {
      test('hides educational content on dialog confirmed', () async {
        final dialogService = getAndRegisterMockDialogService();
        final educationalContentService =
            getAndRegisterMockEducationalContentService();
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

        await educationalContentOverviewViewModel.hideEducationalContent(
          EducationalContent(id: 1),
        );
        verify(
          dialogService.showConfirmationDialog(
            title: 'Schulungsvideo verstecken',
            description:
                'Wollen sie das Schulungsvideo "null" wirklich verstecken?',
            cancelTitle: 'Nein',
            confirmationTitle: 'Ja',
            barrierDismissible: false,
            dialogPlatform: DialogPlatform.Material,
          ),
        ).called(1);
        verify(educationalContentService.hideEducationalContent(1)).called(1);
      });

      test('does not hide on dialog cancel', () async {
        final dialogService = getAndRegisterMockDialogService();
        final educationalContentService =
            getAndRegisterMockEducationalContentService();

        await educationalContentOverviewViewModel.hideEducationalContent(
          EducationalContent(id: 1),
        );
        verify(
          dialogService.showConfirmationDialog(
            title: 'Schulungsvideo verstecken',
            description:
                'Wollen sie das Schulungsvideo "null" wirklich verstecken?',
            cancelTitle: 'Nein',
            confirmationTitle: 'Ja',
            barrierDismissible: false,
            dialogPlatform: DialogPlatform.Material,
          ),
        ).called(1);
        verifyNever(
          educationalContentService.hideEducationalContent(argThat(anything)),
        );
      });
    });

    group('getEducationalContentTitle', () {
      test('returns title', () {
        final educationalContentService =
            getAndRegisterMockEducationalContentService();

        educationalContentOverviewViewModel.getEducationalContentTitle(
          EducationalContent(),
        );
        verify(educationalContentService
            .getEducationalContentTitle(argThat(anything)));
      });
    });

    group('filterEducationalContent', () {
      test('returns correct result', () async {
        final educationalContentService =
            getAndRegisterMockEducationalContentService();
        await educationalContentOverviewViewModel
            .filterEducationalContent('test');
        verify(
          educationalContentService.filterEducationalContent(
            argThat(anything),
          ),
        ).called(1);
      });
    });

    group('openEducationalContent', () {
      test('opens pdf with educational content', () async {
        final navigationService = getAndRegisterMockNavigationService();

        await educationalContentOverviewViewModel
            .openEducationalContent(EducationalContent(
          id: 1,
          title: 'test',
          description: 'test',
        ));
        verify(
          navigationService.navigateWithTransition(
            argThat(anything),
          ),
        ).called(1);
      });
    });

    group('removeItems', () {
      test('removes more than one educational content', () async {
        final educationalContentService =
            getAndRegisterMockEducationalContentService();

        await educationalContentOverviewViewModel.removeItems(
          <EducationalContent>[
            EducationalContent(
              id: 1,
              title: 'test',
              description: 'test',
            ),
            EducationalContent(
              id: 2,
              title: 'test',
              description: 'test',
            ),
          ],
        );
        verify(
          educationalContentService.removeEducationalContent(
            argThat(anything),
          ),
        ).called(2);
      });
    });

    group('dispose', () {
      test('removes listener from service', () {
        final educationalContentService =
            getAndRegisterMockEducationalContentService();

        educationalContentOverviewViewModel.dispose();
        verify(
          educationalContentService.removeListener(argThat(anything)),
        ).called(1);
      });
    });
  });
}
