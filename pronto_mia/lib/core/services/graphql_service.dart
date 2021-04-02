import 'package:graphql/client.dart';

import 'package:pronto_mia/core/services/token_service.dart';
import 'package:pronto_mia/app/app.locator.dart';

class GraphQLService {
  final _tokenService = locator<TokenService>();
  GraphQLClient _graphQLClient;

  GraphQLService() {
    final httpLink = HttpLink('https://localhost:5001/graphql/');
    final authLink = AuthLink(getToken: _getToken);
    final link = authLink.concat(httpLink);

    _graphQLClient = GraphQLClient(link: link, cache: GraphQLCache());
  }

  Future<String> _getToken() async {
    try {
      final token = await _tokenService.getToken();
      return 'bearer $token';
    } catch (_) {
      return '';
    }
  }

  Future<QueryResult> query(QueryOptions options) {
    return _graphQLClient.query(options);
  }

  Future<QueryResult> mutate(MutationOptions options) {
    return _graphQLClient.mutate(options);
  }
}
