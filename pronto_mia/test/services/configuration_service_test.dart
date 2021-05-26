import 'package:flutter_test/flutter_test.dart';
import 'package:pronto_mia/core/services/configuration_service.dart';

import '../setup/test_helpers.dart';

void main() {
  group('ConfigurationService', () {
    ConfigurationService authenticationService;
    setUp(() {
      registerServices();
      authenticationService = ConfigurationService();
    });
    tearDown(() => unregisterServices());

    group('init', () {

    });
  });
}