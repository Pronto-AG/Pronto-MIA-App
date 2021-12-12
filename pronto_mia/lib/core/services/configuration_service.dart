import 'package:flutter/foundation.dart';
import 'package:global_configuration/global_configuration.dart';

/// A service, responsible for accessing the configuration.
///
/// Acts as a wrapper for [GlobalConfiguration].
class ConfigurationService {
  final _configuration = GlobalConfiguration();

  /// Loads configuration files according to the current build mode.
  Future<void> init() async {
    await _configuration.loadFromAsset('app_settings.json');
    await _configuration.loadFromAsset('app_settings_mailer.json');

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
