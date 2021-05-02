import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import 'package:http/io_client.dart';

import 'package:pronto_mia/core/services/jwt_token_service.dart';
import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/configuration_service.dart';

class GraphQLService {
  Future<ConfigurationService> get _configurationService =>
      locator.getAsync<ConfigurationService>();
  Future<JwtTokenService> get _jwtTokenService =>
      locator.getAsync<JwtTokenService>();

  GraphQLClient _graphQLClient;

  Future<void> init() async {
    IOClient ioClient;
    final apiPath = (await _configurationService).getValue<String>('apiPath');
    final enforceValidCertificate =
        (await _configurationService).getValue<bool>('enforceValidCertificate');

    if (!kIsWeb && !enforceValidCertificate) {
      final httpClient = HttpClient();
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      ioClient = IOClient(httpClient);
    }

    final httpLink = HttpLink(apiPath, httpClient: ioClient);
    final authLink = AuthLink(getToken: _getJwtToken);
    final link = authLink.concat(httpLink);

    final policies = Policies(
      fetch: FetchPolicy.noCache,
    );

    _graphQLClient = GraphQLClient(
      link: link,
      cache: GraphQLCache(),
      defaultPolicies: DefaultPolicies(
        query: policies,
        mutate: policies,
      ),
    );
  }

  Future<Map<String, dynamic>> query(
    String query, {
    Map<String, dynamic> variables,
    bool useCache = true,
  }) async {
    final queryOptions = QueryOptions(
      document: gql(query),
      variables: variables,
    );

    if (useCache) {
      queryOptions.policies = Policies(fetch: FetchPolicy.networkOnly);
    }

    var queryResult = await _graphQLClient.query(queryOptions);
    if (queryResult.hasException) {
      if (useCache && !_isNetworkAvailable(queryResult.exception)) {
        queryOptions.policies = Policies(fetch: FetchPolicy.cacheOnly);
        queryResult = await _graphQLClient.query(queryOptions);
      }

      if (queryResult.hasException) {
        throw queryResult.exception;
      }
    }

    return queryResult.data;
  }

  Future<Map<String, dynamic>> mutate(String mutation,
      {Map<String, dynamic> variables}) async {
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

  Future<String> _getJwtToken() async {
    try {
      final token = await (await _jwtTokenService).getToken();
      return 'Bearer $token';
    } catch (_) {
      return '';
    }
  }

  // ToDo: Replace with #39 globally.
  static bool _isNetworkAvailable(OperationException exception) {
    if (exception.linkException is NetworkException) {
      return false;
    }

    if (exception.linkException is ServerException) {
      final serverException = exception.linkException as ServerException;
      if (serverException.parsedResponse == null) {
        return false;
      }
    }

    return true;
  }
}
