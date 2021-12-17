import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pronto_mia/core/models/internal_news.dart';
import 'package:pronto_mia/ui/shared/custom_dialogs.dart';

import 'package:pronto_mia/ui/views/internal_news/view/internal_news_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

import '../setup/test_helpers.dart';

void main() {
  group('InternalNewsViewViewModel', () {
    InternalNewsViewModel internalNewsViewModel;
    InternalNews news = InternalNews();
    setUp(() {
      registerServices();
      internalNewsViewModel = InternalNewsViewModel(internalNews: news);
    });
    tearDown(() => unregisterServices());

    group('futureToRun', () {
      test('returns available internal news on default mode', () async {
        final internalNewsService = getAndRegisterMockInternalNewsService();
        when(internalNewsService.getInternalNewsById(news.id)).thenAnswer(
          (realInvocation) => Future.value(news),
        );

        expect(
          await internalNewsViewModel.futureToRun(),
          isInstanceOf<InternalNews>(),
        );
        verify(internalNewsService.getInternalNewsById(InternalNews().id))
            .called(1);
      });
    });

    group('onError', () {
      test('calls error handling on error', () async {
        final errorService = getAndRegisterMockErrorService();
        when(errorService.getErrorMessage(captureAny)).thenReturn('test');

        await internalNewsViewModel.onError(Exception());
        expect(internalNewsViewModel.errorMessage, equals('test'));
        verify(
          errorService.handleError(
            'InternalNewsViewModel',
            argThat(isException),
          ),
        ).called(1);
        verify(errorService.getErrorMessage(argThat(isException))).called(1);
      });
    });

    group('getInternalNewsTitle', () {
      test('returns title', () {
        final internalNewsService = getAndRegisterMockInternalNewsService();

        internalNewsViewModel.getInternalNewsTitle(
          InternalNews(),
        );
        verify(internalNewsService.getInternalNewsTitle(argThat(anything)));
      });
    });

    group('getInternalNewsDate', () {
      test('returns date', () {
        final internalNewsService = getAndRegisterMockInternalNewsService();

        internalNewsViewModel.getInternalNewsDate(
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

        internalNewsViewModel.getInternalNewsImage(
          InternalNews(),
        );
        verify(
          internalNewsService.getInternalNewsImage(
            argThat(anything),
          ),
        );
      });
    });

    group('dispose', () {
      test('removes listener from service', () {
        final internalNewsService = getAndRegisterMockInternalNewsService();

        internalNewsViewModel.dispose();
        verify(
          internalNewsService.removeListener(argThat(anything)),
        ).called(1);
      });
    });
  });
}
