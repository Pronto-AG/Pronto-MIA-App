import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:pronto_mia/core/services/pdf_service.dart';

import '../setup/test_helpers.dart';
import '../setup/test_helpers.mocks.dart';

void main() {
  group('PdfService', () {
    setUp(() {
      registerServices();
    });
    tearDown(() => unregisterServices());

    group('downloadPdf', () {
      test('downloads pdf', () async {
        final cacheManager = MockCacheManager();
        final pdfService = PdfService(cacheManager: cacheManager);
        final jwtTokenService = getAndRegisterMockJwtTokenService();
        when(
            jwtTokenService.getToken()
        ).thenAnswer((realInvocation) => Future.value('12345'));

        expect(await pdfService.downloadPdf('http://example.com'), isNotNull);
        verify(jwtTokenService.getToken()).called(1);
        verify(cacheManager.getSingleFile('http://example.com', headers: {"Authorization": "Bearer 12345"}));
      });
    });
  });
}