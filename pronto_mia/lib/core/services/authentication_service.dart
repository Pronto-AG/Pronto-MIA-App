import 'package:graphql/client.dart';

import 'package:pronto_mia/app/app.locator.dart';
import 'package:pronto_mia/core/services/graphql_service.dart';
import 'package:pronto_mia/core/queries/authenticate.dart';
import 'package:pronto_mia/core/services/jwt_token_service.dart';

class AuthenticationService {
  final _graphQLService = locator<GraphQLService>();
  final _jwtTokenService = locator<JwtTokenService>();

  Future<bool> isAuthenticated() async {
    final token = await _jwtTokenService.getToken();
    if (token != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> login(String userName, String password) async {
    final queryVariables = {
      'userName': userName,
      'password': password,
    };

    final data = await _graphQLService.query(
        Authenticate.authenticate, queryVariables);

    final token = data['authenticate'] as String;

    if (token != null) {
      await _jwtTokenService.setToken(token);
      return true;
    } else {
      return false;
    }
  }
}
