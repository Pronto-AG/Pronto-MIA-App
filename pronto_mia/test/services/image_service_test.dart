import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:pronto_mia/core/services/image_service.dart';

import '../setup/test_helpers.dart';
import '../setup/test_helpers.mocks.dart';

void main() {
  group('ImageService', () {
    setUp(() {
      registerServices();
    });
    tearDown(() => unregisterServices());

    group('downloadImage', () {
      test('downloads image', () async {
        final cacheManager = MockCacheManager();
        final imageService = ImageService(cacheManager: cacheManager);

        expect(
            await imageService.downloadImage('http://example.com'), isNotNull);
        verify(cacheManager.getSingleFile('http://example.com'));
      });
    });
  });
}
