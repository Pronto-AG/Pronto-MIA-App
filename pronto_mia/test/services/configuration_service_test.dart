import 'package:flutter_test/flutter_test.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mockito/mockito.dart';

import 'package:pronto_mia/core/services/configuration_service.dart';

import '../setup/mocks/mock_global_configuration.dart';
import '../setup/test_helpers.dart';

void main() {
  group('ConfigurationService', () {
    MockGlobalConfiguration configuration;
    ConfigurationService configurationService;
    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      registerServices();
      configuration = MockGlobalConfiguration();
      configurationService = ConfigurationService();
    });
    tearDown(() => unregisterServices());

    group('init', () {
      /*
      test('loads all config files', () async {
        when(
          configuration.loadFromAsset(captureAny)
        ).thenAnswer((realInvocation) => Future.value());
        await configurationService.init(configuration: configuration);
        verify(configuration.loadFromAsset('app_settings.json')).called(1);
        verify(configuration.loadFromAsset('app_settings_dev.json')).called(1);
      });
       */
    });

    group('getValue', () {

    });
  });
}