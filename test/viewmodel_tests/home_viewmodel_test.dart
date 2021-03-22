import 'package:flutter_test/flutter_test.dart';

import 'package:informbob_app/ui/views/home/home_viewmodel.dart';
import '../setup/test_helpers.dart';

void main() {
  group('HomeViewModelTest', () {
    setUp(() => registerServices());
    // tearDown(() => unregisterServices());

    group('loadCounter', () {
      test('When called should load counter', () async {
        getAndRegisterStorageServiceMock(counter: 5);
        final model = HomeViewModel();
        await model.loadCounter();
        expect(model.counter, 5);
      });
    });
  });
}
