import 'package:logging/logging.dart';
import 'package:pronto_mia/core/models/user.dart';
import 'package:pronto_mia/core/services/jwt_token_service.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/logging_service.dart';

class UserService {
  Future<JwtTokenService> get _jwtTokenService =>
      locator.getAsync<JwtTokenService>();
  Future<LoggingService> get _loggingService =>
      locator.getAsync<LoggingService>();

  Future<User> getCurrentUser() async {
    final userId = await (await _jwtTokenService).getUserId();
    final username = await (await _jwtTokenService).getUsername();

    if (userId == null || username == null) {
      (await _loggingService)
          .log("UserService", Level.WARNING, "No user could be fetched.");
      return null;
    }

    return User(userId, username);
  }
}
