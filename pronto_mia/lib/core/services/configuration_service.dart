import 'package:global_configuration/global_configuration.dart';
import 'package:flutter/foundation.dart';

class ConfigurationService {
  final _configuration = GlobalConfiguration();

  Future<void> init() async {
    await _configuration.loadFromAsset('app_settings.json');

    if (kReleaseMode) {
      await _configuration.loadFromAsset('app_settings_prod.json');
    } else {
      await _configuration.loadFromAsset('app_settings_dev.json');
    }
    var logLevel = _configuration.getValue<String>("LogLevel");
    if (logLevel == null || logLevel.isEmpty) {
      logLevel = "info";
    }
  }

  T getValue<T>(String key) {
    return _configuration.getValue<T>(key);
  }
}
