import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/graphql_service.dart';
import 'package:pronto_mia/core/queries/authentication_queries.dart';
import 'package:pronto_mia/core/services/jwt_token_service.dart';
import 'package:pronto_mia/core/services/push_notification_service.dart';

class AuthenticationService {
  Future<GraphQLService> get _graphQLService =>
      locator.getAsync<GraphQLService>();
  Future<JwtTokenService> get _jwtTokenService =>
      locator.getAsync<JwtTokenService>();
  Future<PushNotificationService> get _pushNotificationService =>
      locator.getAsync<PushNotificationService>();

  Future<bool> isAuthenticated() async {
    return (await _jwtTokenService).hasValidToken();
  }

  Future<void> logout() async {
    await (await _jwtTokenService).setToken('');
    await (await _pushNotificationService).disableNotifications();
  }

  Future<void> login(String userName, String password) async {
    final queryVariables = {
      'userName': userName,
      'password': password,
    };

    final data = await (await _graphQLService).query(
      AuthenticationQueries.authenticate,
      variables: queryVariables,
      useCache: false,
    );

    final token = data['authenticate'] as String;
    await (await _jwtTokenService).setToken(token);
    await (await _pushNotificationService).enableNotifications();
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    final queryVariables = {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    };

    final data = await (await _graphQLService).query(
      AuthenticationQueries.changePassword,
      variables: queryVariables,
    );

    final token = data['changePassword'] as String;
    await (await _jwtTokenService).setToken(token);
  }
}
