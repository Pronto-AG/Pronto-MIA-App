import 'package:flutter_test/flutter_test.dart';
import 'package:informbob_app/app/app.locator.dart';
import 'package:informbob_app/core/services/storage_service.dart';

import '../setup/test_helpers.dart';
import 'package:informbob_app/ui/views/home/home_viewmodel.dart';

void main() {
  group('HomeViewModelTest', () {
    setUp(() => registerServices());
    // tearDown(() => unregisterServices());

    group('loadCounter', () {
      test('When called should load counter', () async {
        var storageService = getAndRegisterStorageServiceMock(counter: 5);
        var model = HomeViewModel();
        await model.loadCounter();
        expect(model.counter, 5);
      });
    });
  });
}