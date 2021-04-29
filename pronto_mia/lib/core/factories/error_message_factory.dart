// TODO: Implement error distinction
import 'package:logging/logging.dart';
import 'package:pronto_mia/core/services/logging_service.dart';
import 'package:pronto_mia/app/service_locator.dart';

class ErrorMessageFactory {
  Future<LoggingService> get _loggingService =>
      locator.getAsync<LoggingService>();

  Future<String> getErrorMessage(String logContext, dynamic error) async {
    (await _loggingService).log(logContext, Level.WARNING, error);
    return 'Es ist ein unerwarteter Fehler aufgetreten.';
  }
}
