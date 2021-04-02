import 'package:graphql/client.dart';

import 'package:pronto_mia/app/app.locator.dart';
import 'package:pronto_mia/core/services/graphql_service.dart';
import 'package:pronto_mia/core/queries/authenticate.dart';
import 'package:pronto_mia/core/services/token_service.dart';

class AuthenticationService {
  final _graphQLService = locator<GraphQLService>();
  final _tokenService = locator<TokenService>();

  Future<bool> isAuthenticated() async {
    final token = await _tokenService.getToken();
    if (token != null) {
      return true;
    } else {
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

    final result = await _graphQLService.query(options);

    if (result.data != null) {
      await _tokenService.setToken(result.data['authenticate'] as String);
    }

    return result;
  }
}
