import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pronto_mia/core/models/educational_content.dart';
import 'package:pronto_mia/ui/shared/custom_dialogs.dart';

import 'package:pronto_mia/ui/views/educational_content/view/educational_content_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

import '../setup/test_helpers.dart';

void main() {
  group('EducationalContentViewViewModel', () {
    EducationalContentViewModel educationalContentViewModel;
    EducationalContent news = EducationalContent();
    setUp(() {
      registerServices();
      educationalContentViewModel =
          EducationalContentViewModel(educationalContent: news);
    });
    tearDown(() => unregisterServices());

    group('futureToRun', () {
      test('returns available educational content on default mode', () async {
        final educationalContentService =
            getAndRegisterMockEducationalContentService();
        when(educationalContentService.getEducationalContentById(news.id))
            .thenAnswer(
          (realInvocation) => Future.value(news),
        );

        expect(
          await educationalContentViewModel.futureToRun(),
          isInstanceOf<EducationalContent>(),
        );
        verify(educationalContentService
                .getEducationalContentById(EducationalContent().id))
            .called(1);
      });
    });

    group('onError', () {
      test('calls error handling on error', () async {
        final errorService = getAndRegisterMockErrorService();
        when(errorService.getErrorMessage(captureAny)).thenReturn('test');

        await educationalContentViewModel.onError(Exception());
        expect(educationalContentViewModel.errorMessage, equals('test'));
        verify(
          errorService.handleError(
            'EducationalContentViewModel',
            argThat(isException),
          ),
        ).called(1);
        verify(errorService.getErrorMessage(argThat(isException))).called(1);
      });
    });

    group('getEducationalContentTitle', () {
      test('returns title', () {
        final educationalContentService =
            getAndRegisterMockEducationalContentService();

        educationalContentViewModel.getEducationalContentTitle(
          EducationalContent(),
        );
        verify(educationalContentService
            .getEducationalContentTitle(argThat(anything)));
      });
    });

    group('dispose', () {
      test('removes listener from service', () {
        final educationalContentService =
            getAndRegisterMockEducationalContentService();

        educationalContentViewModel.dispose();
        verify(
          educationalContentService.removeListener(argThat(anything)),
        ).called(1);
      });
    });
  });
}
