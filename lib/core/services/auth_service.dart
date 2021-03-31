import 'package:graphql/client.dart';

import 'package:informbob_app/app/app.locator.dart';
import 'package:informbob_app/app/gql_client.dart';
import 'package:informbob_app/core/queries/authenticate.dart';
import 'package:informbob_app/core/services/token_service.dart';

class AuthService {
  final GraphQLClient _gqlClient = GqlConfig.client;
  final TokenService _tokenService = locator<TokenService>();

  Future<bool> isAuthenticated() async {
    try {
      final token = await _tokenService.getToken();
      print(token);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<QueryResult> login(String userName, String password) async {
    final QueryOptions options = QueryOptions(
      document: gql(Authenticate.authenticate),
      variables: <String, dynamic>{
        'userName': userName,
        'password': password,
      },
    );

    final result = await _gqlClient.query(options);

    if (result.data != null) {
      await _tokenService.setToken(result.data['authenticate'] as String);
    }

    return result;
  }
}
