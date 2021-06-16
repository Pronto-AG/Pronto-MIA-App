import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';
import 'package:mockito/mockito.dart';

import 'package:pronto_mia/core/services/graphql_service.dart';

import '../setup/test_helpers.dart';
import '../setup/test_helpers.mocks.dart';

void main() {
  group('GraphQLService', () {
    setUp(() {
      registerServices();
    });
    tearDown(() => unregisterServices());

    group('query', () {
      test('returns result from query', () async {
        final graphQLClient = MockGraphQLClient();
        final graphQLService = GraphQLService(graphQLClient: graphQLClient);
        when(
          graphQLClient.query(captureAny),
        ).thenAnswer(
          (realInvocation) => Future.value(QueryResult(data: {'test': 'test'})),
        );

        expect(
          await graphQLService.query('query {}'),
          {'test': 'test'},
        );
        verify(graphQLClient.query(argThat(isNotNull))).called(1);
      });

      test('throws on exception in query ', () async {
        final graphQLClient = MockGraphQLClient();
        final graphQLService = GraphQLService(graphQLClient: graphQLClient);
        when(
            graphQLClient.query(captureAny),
        ).thenAnswer(
          (realInvocation) => Future.value(
            QueryResult(exception: OperationException()),
          ),
        );

        expect(
          () async => graphQLService.query('query {}'),
          throwsA(isA<OperationException>()),
        );
        verify(graphQLClient.query(argThat(isNotNull))).called(1);
      });
    });

    group('mutate', () {
      test('returns result from mutation', () async {
        final graphQLClient = MockGraphQLClient();
        final graphQLService = GraphQLService(graphQLClient: graphQLClient);
        when(
          graphQLClient.mutate(captureAny),
        ).thenAnswer(
          (realInvocation) => Future.value(QueryResult(data: {'test': 'test'})),
        );

        expect(
          await graphQLService.mutate('mutation {}'),
          {'test': 'test'},
        );
        verify(graphQLClient.mutate(argThat(isNotNull))).called(1);
      });

      test('throws on exception in mutation', () async {
        final graphQLClient = MockGraphQLClient();
        final graphQLService = GraphQLService(graphQLClient: graphQLClient);
        when(
            graphQLClient.mutate(captureAny),
        ).thenAnswer(
              (realInvocation) => Future.value(
            QueryResult(exception: OperationException()),
          ),
        );

        expect(
          () async => graphQLService.mutate('query {}'),
          throwsA(isA<OperationException>()),
        );
        verify(graphQLClient.mutate(argThat(isNotNull))).called(1);
      });
    });
  });
}