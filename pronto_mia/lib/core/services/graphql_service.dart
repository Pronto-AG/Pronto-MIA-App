import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import 'package:http/io_client.dart';
import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/configuration_service.dart';
import 'package:pronto_mia/core/services/jwt_token_service.dart';

/// A service, responsible for communicating with the GraphQL-API.
///
/// Contains functionality to send queries and mutations.
class GraphQLService {
  Future<ConfigurationService> get _configurationService =>
      locator.getAsync<ConfigurationService>();
  Future<JwtTokenService> get _jwtTokenService =>
      locator.getAsync<JwtTokenService>();

  GraphQLClient _graphQLClient;

  /// Initializes a new instance of [GraphQLService].
  ///
  /// Takes a [GraphQLClient] to send queries and mutations to as an input.
  GraphQLService({GraphQLClient graphQLClient})
      : _graphQLClient = graphQLClient;

  /// Initializes a new GraphQLClient, when there was none provided through
  /// the constructor.
  ///
  /// The clients default cache policy is "no cache".
  /// If the option "enforceValidCertificate" in the configuration file is set
  /// to [bool] false the client allows communication without a valid
  /// certificate.
  Future<void> init() async {
    if (_graphQLClient == null) {
      IOClient ioClient;
      final apiPath = (await _configurationService).getValue<String>('apiPath');
      final enforceValidCertificate = (await _configurationService)
          .getValue<bool>('enforceValidCertificate');

      if (!kIsWeb && !enforceValidCertificate) {
        final httpClient = HttpClient();
        httpClient.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        ioClient = IOClient(httpClient);
      }

      final httpLink = HttpLink(apiPath, httpClient: ioClient);
      final authLink = AuthLink(getToken: _getJwtToken);
      final link = authLink.concat(httpLink);

      // TODO: Review cache policies when https://github.com/zino-app/graphql-flutter/issues/871 is fixed
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
  }

  /// Sends a query to the [GraphQLClient].
  ///
  /// Takes the [String] query, [Map] variables and the option to [bool] use
  /// cache as an input.
  /// Returns the [Map] data if no exception occured.
  /// Throws errors contained in the [QueryResult].
  /// Uses cache by default, but provides the option to disable it through
  /// [useCache].
  /// When cache is active the query is first send to the network, if the
  /// network is not available the query is sent again to cache.
  Future<Map<String, dynamic>> query(
    String query, {
    Map<String, dynamic> variables,
    bool useCache = true,
  }) async {
    final queryOptions = QueryOptions(
      document: gql(query),
      variables: variables ??= {},
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

  /// Sends a mutation to the [GraphQLClient].
  ///
  /// Takes the [String] query, [Map] variables as an input.
  /// Returns the [Map] data if no exception occured.
  /// Throws errors contained in the [QueryResult].
  /// Mutations dont use cache by default and also dont provide and option for
  /// it.
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

  // TODO: Replace with Issue #39 globally.
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
