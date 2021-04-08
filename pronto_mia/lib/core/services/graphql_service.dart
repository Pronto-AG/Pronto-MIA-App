import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:graphql/client.dart';
import 'package:http/io_client.dart';

import 'package:pronto_mia/core/services/jwt_token_service.dart';
import 'package:pronto_mia/app/app.locator.dart';

class GraphQLService {
  final _configuration = GlobalConfiguration();
  final _jwtTokenService = locator<JwtTokenService>();
  GraphQLClient _graphQLClient;

  void initialise() {
    IOClient ioClient;
    final apiPath = _configuration.getValue<String>('apiPath');
    final enforceValidCertificate =
        _configuration.getValue<bool>('enforceValidCertificate');

    if (!kIsWeb && !enforceValidCertificate) {
      final httpClient = HttpClient();
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      ioClient = IOClient(httpClient);
    }

    final httpLink = HttpLink(apiPath, httpClient: ioClient);
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
    final response = await _graphQLClient.mutate(options);
    return response;
  }
}
