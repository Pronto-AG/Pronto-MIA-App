import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:pronto_mia/core/models/simple_file.dart';
import 'package:pronto_mia/ui/views/pdf/pdf_viewmodel.dart';

import '../setup/test_helpers.dart';

void main() {
  group('PdfViewModel', () {
    PdfViewModel pdfViewModel;
    setUp(() {
      registerServices();
      pdfViewModel = PdfViewModel();
    });
    tearDown(() => unregisterServices());

    group('futureToRun', () {
      test('downloads pdf on string argument', () async {
        pdfViewModel = PdfViewModel(pdfFile: 'http://example.com');
        final pdfService = getAndRegisterMockPdfService();
        when(pdfService.downloadPdf(captureAny)).thenAnswer(
          (realInvocation) => Future.value(SimpleFile()),
        );

        expect(await pdfViewModel.futureToRun(), isNotNull);
        verify(pdfService.downloadPdf(argThat(anything))).called(1);
      });

      test('returns pdf on SimpleFile argument', () async {
        pdfViewModel = PdfViewModel(pdfFile: SimpleFile());
        expect(await pdfViewModel.futureToRun(), isNotNull);
      });

      test('throws error on unknown argument', () async {
        pdfViewModel = PdfViewModel(pdfFile: 1);
        expect(
          () async => await pdfViewModel.futureToRun(),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    group('onError', () {
      test('calls error handling on error', () async {
        final errorService = getAndRegisterMockErrorService();
        when(errorService.getErrorMessage(captureAny)).thenReturn('test');

        await pdfViewModel.onError(Exception());
        expect(pdfViewModel.errorMessage, equals('test'));
        verify(
          errorService.handleError(
            'PdfViewModel',
            argThat(isException),
          ),
        ).called(1);
        verify(errorService.getErrorMessage(argThat(isException))).called(1);
      });
    });
  });
}
