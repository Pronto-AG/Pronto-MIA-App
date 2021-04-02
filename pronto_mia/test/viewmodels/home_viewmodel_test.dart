import 'package:flutter_test/flutter_test.dart';

import 'package:pronto_mia/ui/views/login/login_viewmodel.dart';

import '../setup/test_helpers.dart';

void main() {
  group('HomeViewModelTest', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    group('login()', () {
      test('When login show validation message', () async {
        final model = LoginViewModel();
        await model.login();
        expect(model.validationMessage, 'Keine Verbindung zum Server.');
      });
    });
  });
}
