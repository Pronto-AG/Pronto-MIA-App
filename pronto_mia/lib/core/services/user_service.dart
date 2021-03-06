import 'package:logging/logging.dart';
import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/access_control_list.dart';
import 'package:pronto_mia/core/models/user.dart';
import 'package:pronto_mia/core/queries/user_queries.dart';
import 'package:pronto_mia/core/services/graphql_service.dart';
import 'package:pronto_mia/core/services/logging_service.dart';

/// A service, responsible for accessing users.
///
/// Contains methods to modify and access user information.
class UserService {
  Future<LoggingService> get _loggingService =>
      locator.getAsync<LoggingService>();
  Future<GraphQLService> get _graphQLService =>
      locator.getAsync<GraphQLService>();

  /// Gets the currently authenticated user
  ///
  /// Returns the current [User] user.
  Future<User> getCurrentUser() async {
    try {
      final data = await (await _graphQLService).query(UserQueries.currentUser);
      final user = User.fromJson(data['user'] as Map<String, dynamic>);
      if (user.id == null) {
        (await _loggingService)
            .log("UserService", Level.WARNING, "No user could be fetched.");
        return null;
      }

      return user;
    } catch (e) {
      return null;
    }
  }

  /// Gets the list of all users.
  ///
  /// Returns a [List] list of users.
  Future<List<User>> getUsers() async {
    final data = await (await _graphQLService).query(UserQueries.users);
    final dtoList = data['users'] as List<Object>;
    final userList = dtoList
        .map((dto) => User.fromJson(dto as Map<String, dynamic>))
        .toList();

    return userList;
  }

  /// Creates a new user.
  ///
  /// Takes a [String] username, a [String] password, alongside the [Department]
  /// the user works for and a [Profile] set of permissions as an input.
  Future<void> createUser(
    String userName,
    String password,
    List<int> departmentIds,
    AccessControlList accessControlList,
  ) async {
    final queryVariables = {
      'userName': userName,
      'password': password,
      'departmentIds': departmentIds,
      'accessControlList': accessControlList.toJson(),
    };
    await (await _graphQLService).mutate(
      UserQueries.createUser,
      variables: queryVariables,
    );
  }

  /// Updates an existing user.
  ///
  /// Takes an [int] id, a [String] username, a [String] password, alongside
  /// the [Department] the user works for and a [Profile] set of permissions as
  /// an input.
  Future<void> updateUser(
    int id, {
    String userName,
    String password,
    List<int> departmentIds,
    AccessControlList accessControlList,
  }) async {
    final queryVariables = {
      'id': id,
      'userName': userName,
      'password': password,
      'departmentIds': departmentIds,
      'accessControlList': accessControlList?.toJson(),
    };
    await (await _graphQLService).mutate(
      UserQueries.updateUser,
      variables: queryVariables,
    );
  }

  /// Removes an existing user.
  ///
  /// Takes the [int] id of the user to be removed as an input.
  Future<void> removeUser(int id) async {
    final queryVariables = {'id': id};
    await (await _graphQLService).mutate(
      UserQueries.removeUser,
      variables: queryVariables,
    );
  }

  /// Returns Users based on a filter
  ///
  /// Takes the [String] name of the users to be filtered as an input.
  Future<List<User>> filterUser(String filter) async {
    final queryVariables = {'filter': filter};
    final data = await (await _graphQLService).query(
      UserQueries.filterUser,
      variables: queryVariables,
    );
    final dtoList = data['users'] as List<Object>;
    final userList = dtoList
        .map((dto) => User.fromJson(dto as Map<String, dynamic>))
        .toList();
    return userList;
  }
}
