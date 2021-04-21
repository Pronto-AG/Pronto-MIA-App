import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/graphql_service.dart';
import 'package:pronto_mia/core/queries/authentication_queries.dart';
import 'package:pronto_mia/core/services/jwt_token_service.dart';

class AuthenticationService {
  Future<GraphQLService> get _graphQLService =>
      locator.getAsync<GraphQLService>();
  Future<JwtTokenService> get _jwtTokenService =>
      locator.getAsync<JwtTokenService>();

  Future<bool> isAuthenticated() async {
    final token = await (await _jwtTokenService).getToken();
    // TODO: Check token validity
    if (token != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> login(String userName, String password) async {
    final queryVariables = {
      'userName': userName,
      'password': password,
    };

    final data = await (await _graphQLService).query(
      AuthenticationQueries.authenticate,
      queryVariables
    );
    final token = data['authenticate'] as String;
    await (await _jwtTokenService).setToken(token);
  }
}
