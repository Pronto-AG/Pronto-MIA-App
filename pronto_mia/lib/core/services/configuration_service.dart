import 'package:global_configuration/global_configuration.dart';
import 'package:flutter/foundation.dart';

/// A service, that is responsible for accessing the configuration.
///
/// Acts as a wrapper for [GlobalConfiguration].
class ConfigurationService {
  GlobalConfiguration _configuration = GlobalConfiguration();

  /// Loads configuration files according to the current build mode
  ///
  /// Takes a [GlobalConfiguration] as an input, to overwrite the current one.
  Future<void> init({GlobalConfiguration configuration}) async {
    _configuration ??= configuration;
    await _configuration.loadFromAsset('app_settings.json');

    if (kReleaseMode) {
      await _configuration.loadFromAsset('app_settings_prod.json');
    } else {
      await _configuration.loadFromAsset('app_settings_dev.json');
    }
  }

  /// Gets a value of generic type from the currently active configuration.
  ///
  /// Takes a [String] key contained in the configuration as an input.
  /// Returns the value corresponding to [key] as a generic type.
  T getValue<T>(String key) {
    return _configuration.getValue<T>(key);
  }
}
