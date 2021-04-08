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

  Future<Map<String, dynamic>> query(
      String query, [Map<String, dynamic> variables]) async {
    final queryOptions = QueryOptions(
      document: gql(query),
      variables: variables,
    );

    final queryResult = await _graphQLClient.query(queryOptions);
    if (queryResult.hasException) {
      throw queryResult.exception;
    }

    return queryResult.data;
  }

  Future<Map<String, dynamic>> mutate(
      String mutation, [Map<String, dynamic> variables]) async {
    final mutationOptions = MutationOptions(
      document: gql(mutation),
      variables: variables,
    );

    final queryResult = await _graphQLClient.mutate(mutationOptions);
    if (queryResult.hasException) {
      throw queryResult.exception;
    }

    return queryResult.data;
  }
}
