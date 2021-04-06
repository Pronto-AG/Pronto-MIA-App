import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import 'package:http/io_client.dart';

import 'package:pronto_mia/core/services/jwt_token_service.dart';
import 'package:pronto_mia/app/app.locator.dart';

class GraphQLService {
  final _jwtTokenService = locator<JwtTokenService>();
  GraphQLClient _graphQLClient;

  GraphQLService() {
    HttpLink httpLink;
    if (kIsWeb) {
      httpLink = HttpLink('https://localhost:5001/graphql/');
    } else {
      final httpClient = HttpClient();
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final ioClient = IOClient(httpClient);
      httpLink = HttpLink(
        'https://192.168.1.110:5001/graphql/',
        httpClient: ioClient,
      );
    }

    final authLink = AuthLink(getToken: _getToken);
    final link = authLink.concat(httpLink);

    _graphQLClient = GraphQLClient(link: link, cache: GraphQLCache());
  }

  Future<String> _getToken() async {
    try {
      final token = await _jwtTokenService.getToken();
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
