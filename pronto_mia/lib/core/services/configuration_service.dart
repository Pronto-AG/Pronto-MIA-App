import 'package:global_configuration/global_configuration.dart';
import 'package:flutter/foundation.dart';

class ConfigurationService {
  final _configuration = GlobalConfiguration();

  Future<void> init() async {
    await _configuration.loadFromPath('../config/app_settings.json');

    if (kReleaseMode) {
      await _configuration.loadFromPath('../config/app_settings_prod.json');
    } else {
      await _configuration.loadFromPath('../config/app_settings_dev.json');
    }
  }

  T getValue<T>(String key) {
    return _configuration.getValue<T>(key);
  }
}