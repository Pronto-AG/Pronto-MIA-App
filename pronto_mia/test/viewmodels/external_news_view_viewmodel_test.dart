import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pronto_mia/core/models/external_news.dart';
import 'package:pronto_mia/ui/shared/custom_dialogs.dart';

import 'package:pronto_mia/ui/views/external_news/view/external_news_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

import '../setup/test_helpers.dart';

void main() {
  group('ExternalNewsViewViewModel', () {
    ExternalNewsViewModel externalNewsViewModel;
    ExternalNews news = ExternalNews();
    setUp(() {
      registerServices();
      externalNewsViewModel = ExternalNewsViewModel(externalNews: news);
    });
    tearDown(() => unregisterServices());

    group('futureToRun', () {
      test('returns available external news on default mode', () async {
        final externalNewsService = getAndRegisterMockExternalNewsService();
        when(externalNewsService.getExternalNewsById(news.id)).thenAnswer(
          (realInvocation) => Future.value(news),
        );

        expect(
          await externalNewsViewModel.futureToRun(),
          isInstanceOf<ExternalNews>(),
        );
        verify(externalNewsService.getExternalNewsById(ExternalNews().id))
            .called(1);
      });
    });

    group('onError', () {
      test('calls error handling on error', () async {
        final errorService = getAndRegisterMockErrorService();
        when(errorService.getErrorMessage(captureAny)).thenReturn('test');

        await externalNewsViewModel.onError(Exception());
        expect(externalNewsViewModel.errorMessage, equals('test'));
        verify(
          errorService.handleError(
            'ExternalNewsViewModel',
            argThat(isException),
          ),
        ).called(1);
        verify(errorService.getErrorMessage(argThat(isException))).called(1);
      });
    });

    group('getExternalNewsTitle', () {
      test('returns title', () {
        final externalNewsService = getAndRegisterMockExternalNewsService();

        externalNewsViewModel.getExternalNewsTitle(
          ExternalNews(),
        );
        verify(externalNewsService.getExternalNewsTitle(argThat(anything)));
      });
    });

    group('getExternalNewsDate', () {
      test('returns date', () {
        final externalNewsService = getAndRegisterMockExternalNewsService();

        externalNewsViewModel.getExternalNewsDate(
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

        externalNewsViewModel.getExternalNewsImage(
          ExternalNews(),
        );
        verify(
          externalNewsService.getExternalNewsImage(
            argThat(anything),
          ),
        );
      });
    });

    group('dispose', () {
      test('removes listener from service', () {
        final externalNewsService = getAndRegisterMockExternalNewsService();

        externalNewsViewModel.dispose();
        verify(
          externalNewsService.removeListener(argThat(anything)),
        ).called(1);
      });
    });
  });
}
