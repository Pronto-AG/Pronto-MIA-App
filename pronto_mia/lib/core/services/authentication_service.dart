import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/queries/authentication_queries.dart';
import 'package:pronto_mia/core/services/graphql_service.dart';
import 'package:pronto_mia/core/services/jwt_token_service.dart';
import 'package:pronto_mia/core/services/push_notification_service.dart';

/// A service, responsible for authentication functionality
///
/// Contains methods to modify and access authentication information.
class AuthenticationService {
  Future<GraphQLService> get _graphQLService =>
      locator.getAsync<GraphQLService>();
  Future<JwtTokenService> get _jwtTokenService =>
      locator.getAsync<JwtTokenService>();
  Future<PushNotificationService> get _pushNotificationService =>
      locator.getAsync<PushNotificationService>();

  /// Checks if the current user is authenticated.
  ///
  /// Returns wether the current user is authenticated as [bool].
  /// The authentication check is performed by determining if the user has a
  /// valid JWT token.
  Future<bool> isAuthenticated() async {
    return (await _jwtTokenService).hasValidToken();
  }

  /// Performs the logout of the current user and disables notifications.
  ///
  /// The logout is performed by deleting the current JWT token.
  Future<void> logout() async {
    await (await _jwtTokenService).setToken('');
    await (await _pushNotificationService).disableNotifications();
  }

  /// Performs login, persists login information and enables notifications.
  ///
  /// Takes [String] username and [String] password as input.
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

  /// Changes the current users password.
  ///
  /// Takes the [String] current password and a [String] new password as an
  /// input.
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
