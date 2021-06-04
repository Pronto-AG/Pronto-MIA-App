import 'package:logging/logging.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/access_control_list.dart';
import 'package:pronto_mia/core/queries/user_queries.dart';
import 'package:pronto_mia/core/services/logging_service.dart';
import 'package:pronto_mia/core/models/user.dart';
import 'package:pronto_mia/core/services/graphql_service.dart';

class UserService {
  Future<LoggingService> get _loggingService =>
      locator.getAsync<LoggingService>();
  Future<GraphQLService> get _graphQLService =>
      locator.getAsync<GraphQLService>();

  Future<User> getCurrentUser() async {
    final data = await (await _graphQLService).query(UserQueries.currentUser);
    final user = User.fromJson(data['user'] as Map<String, dynamic>);

    if (user.id == null) {
      (await _loggingService)
          .log("UserService", Level.WARNING, "No user could be fetched.");
      return null;
    }

    return user;
  }

  Future<List<User>> getUsers() async {
    final data = await (await _graphQLService).query(UserQueries.users);
    final dtoList = data['users'] as List<Object>;
    final userList = dtoList
        .map((dto) => User.fromJson(dto as Map<String, dynamic>))
        .toList();

    return userList;
  }

  Future<void> createUser(
    String userName,
    String password,
    int departmentId,
    AccessControlList accessControlList,
  ) async {
    final queryVariables = {
      'userName': userName,
      'password': password,
      'departmentId': departmentId,
      'accessControlList': accessControlList.toJson(),
    };
    await (await _graphQLService).mutate(
      UserQueries.createUser,
      variables: queryVariables,
    );
  }

  Future<void> updateUser(
    int id, {
    String userName,
    String password,
    int departmentId,
    AccessControlList accessControlList,
  }) async {
    final queryVariables = {
      'id': id,
      'userName': userName,
      'password': password,
      'departmentId': departmentId,
      'accessControlList': accessControlList?.toJson(),
    };
    await (await _graphQLService).mutate(
      UserQueries.updateUser,
      variables: queryVariables,
    );
  }

  Future<void> removeUser(int id) async {
    final queryVariables = {'id': id};
    await (await _graphQLService).mutate(
      UserQueries.removeUser,
      variables: queryVariables,
    );
  }
}
