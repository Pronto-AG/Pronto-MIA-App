import 'package:global_configuration/global_configuration.dart';
import 'package:flutter/foundation.dart';

class ConfigurationService {
  GlobalConfiguration _configuration = GlobalConfiguration();

  Future<void> init({GlobalConfiguration configuration}) async {
    _configuration ??= configuration;
    await _configuration.loadFromAsset('app_settings.json');

    if (kReleaseMode) {
      await _configuration.loadFromAsset('app_settings_prod.json');
    } else {
      await _configuration.loadFromAsset('app_settings_dev.json');
    }
  }

  T getValue<T>(String key) {
    return _configuration.getValue<T>(key);
  }
}
