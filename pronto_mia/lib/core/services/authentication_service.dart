import 'package:logging/logging.dart';
import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/graphql_service.dart';
import 'package:pronto_mia/core/queries/authentication_queries.dart';
import 'package:pronto_mia/core/services/jwt_token_service.dart';
import 'package:pronto_mia/core/services/push_notification_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:pronto_mia/core/services/logging_service.dart';

class AuthenticationService {
  Future<GraphQLService> get _graphQLService =>
      locator.getAsync<GraphQLService>();
  Future<JwtTokenService> get _jwtTokenService =>
      locator.getAsync<JwtTokenService>();
  Future<PushNotificationService> get _pushNotificationService =>
      locator.getAsync<PushNotificationService>();
  Future<LoggingService> get _loggingService =>
      locator.getAsync<LoggingService>();

  Future<bool> isAuthenticated() async {
    final token = await (await _jwtTokenService).getToken();
    var tokenValid = false;

    if (token != null && token.isNotEmpty) {
      try {
        tokenValid = !JwtDecoder.isExpired(token);
      } catch (e) {
        (await _loggingService).log("AuthenticationService", Level.WARNING,
            "JWT token could not be decoded");
        tokenValid = false;
      }
    }

    return tokenValid;
  }

  Future<void> logout() async {
    await (await _jwtTokenService).setToken('');
    await (await _pushNotificationService).unregisterToken();
  }

  Future<void> login(String userName, String password) async {
    final queryVariables = {
      'userName': userName,
      'password': password,
    };

    final data = await (await _graphQLService).query(
      AuthenticationQueries.authenticate,
      queryVariables,
    );

    final token = data['authenticate'] as String;
    await (await _jwtTokenService).setToken(token);
    await (await _pushNotificationService).registerToken();
  }
}
