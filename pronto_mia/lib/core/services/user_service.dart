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
  Future<GraphQLService> get _graphQLService =>
      locator.getAsync<GraphQLService>();

  Future<User> getCurrentUser() async {
    final userId = await (await _jwtTokenService).getUserId();
    final username = await (await _jwtTokenService).getUsername();

    if (userId == null || username == null) {
      (await _loggingService)
          .log("UserService", Level.WARNING, "No user could be fetched.");
      return null;
    }

    return User(id: userId, username: username);
  }

  Future<List<User>> getUsers() async {
    final data = await (await _graphQLService).query(UserQueries.users);
    final dtoList = data['users'] as List<Object>;
    final userList = dtoList
        .map((dto) => User.fromJson(dto as Map<String, dynamic>))
        .toList();

    return userList;
  }
}
