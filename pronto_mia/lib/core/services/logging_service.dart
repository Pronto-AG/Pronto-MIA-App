import 'package:logging/logging.dart';
import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/configuration_service.dart';

/// A service, that is globally responsible for logging purposes.
class LoggingService {
  Future<ConfigurationService> get _configurationService =>
      locator.getAsync<ConfigurationService>();

  /// Determines current log level from configuration and registers logger.
  Future<void> init() async {
    final logLevel = (await _configurationService).getValue<String>('logLevel');

    Logger.root.level = _getLevelFromString(logLevel);
    Logger.root.onRecord.listen((record) {
      // ignore: avoid_print
      print('${record.time} ${record.loggerName} [${record.level.name}]: '
          '${record.message}');
    });
  }

  Level _getLevelFromString(String logLevel) {
    if (logLevel == null || logLevel.isEmpty) {
      return Level.INFO;
    }

    for (final Level level in Level.LEVELS) {
      if (level.name.toLowerCase() == logLevel.toLowerCase()) {
        return level;
      }
    }

    return Level.INFO;
  }

  /// Logs a message with level and context.
  ///
  /// Takes the [String] context, [Level] level and [Object] message as an
  /// input.
  void log(String logContext, Level logLevel, Object message) {
    final logger = Logger(logContext);
    logger.log(logLevel, message);
  }
}
