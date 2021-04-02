import 'dart:io';
import 'package:graphql/client.dart';
import 'package:http/io_client.dart';

import 'package:pronto_mia/core/services/token_service.dart';
import 'package:pronto_mia/app/app.locator.dart';

class GraphQLService {
  final _tokenService = locator<TokenService>();
  GraphQLClient _graphQLClient;

  GraphQLService() {
    HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    IOClient ioClient = new IOClient(httpClient);

    final httpLink = HttpLink(
      'https://192.168.1.110:5001/graphql/',
      httpClient: ioClient,
    );
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

  Future<QueryResult> query(QueryOptions options) async {
    final response = await _graphQLClient.query(options);
    return response;
  }

  Future<QueryResult> mutate(MutationOptions options) async {
    return _graphQLClient.mutate(options);
  }
}
