import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'package:pronto_mia/core/models/external_news.dart';
import 'package:pronto_mia/core/models/simple_file.dart';
import 'package:pronto_mia/core/queries/external_news_queries.dart';
import 'package:pronto_mia/core/services/external_news_service.dart';
import 'package:stacked_services/stacked_services.dart';

import '../setup/test_helpers.dart';

void main() {
  group('ExternalNewsService', () {
    ExternalNewsService externalNewsService;
    setUp(() {
      registerServices();
      externalNewsService = ExternalNewsService();
    });
    tearDown(() => unregisterServices());

    group('getExternalNews', () {
      test('returns external news', () async {
        final graphQLService = getAndRegisterMockGraphQLService();
        when(
          graphQLService.query(
            captureAny,
            variables: captureAnyNamed('variables'),
            useCache: captureAnyNamed('useCache'),
          ),
        ).thenAnswer(
          (realInvocation) => Future.value({
            'externalNews': [
              {
                'id': 1,
                'title': 'test',
                'description': 'test',
                'availableFrom': DateTime.now().toIso8601String(),
              }
            ]
          }),
        );

        expect(await externalNewsService.getExternalNews(), hasLength(1));
        verify(
          graphQLService.query(ExternalNewsQueries.externalNews),
        ).called(1);
      });
    });

    group('getExternalNewsById', () {
      test('returns external news', () async {
        final graphQLService = getAndRegisterMockGraphQLService();
        when(
          graphQLService.query(
            captureAny,
            variables: captureAnyNamed('variables'),
            useCache: captureAnyNamed('useCache'),
          ),
        ).thenAnswer(
          (realInvocation) => Future.value({
            'externalNews': [
              {
                'id': 1,
                'title': 'test',
                'description': 'test',
                'availableFrom': DateTime.now().toIso8601String(),
              }
            ]
          }),
        );

        expect(await externalNewsService.getExternalNewsById(1), isNotNull);
        verify(
          graphQLService.query(
            ExternalNewsQueries.externalNewsById,
            variables: {'id': 1},
          ),
        ).called(1);
      });
    });

    group('getAvailableExternalNews', () {
      test('returns external news', () async {
        final graphQLService = getAndRegisterMockGraphQLService();
        when(
          graphQLService.query(
            captureAny,
            variables: captureAnyNamed('variables'),
            useCache: captureAnyNamed('useCache'),
          ),
        ).thenAnswer(
          (realInvocation) => Future.value({
            'externalNews': [
              {
                'id': 1,
                'title': 'test',
                'description': 'test',
                'availableFrom': DateTime.now().toIso8601String(),
              }
            ]
          }),
        );

        expect(
          await externalNewsService.getAvailableExternalNews(),
          hasLength(1),
        );
        verify(
          graphQLService.query(
            ExternalNewsQueries.externalNewsAvailable,
          ),
        ).called(1);
      });
    });

    group('createExternalNews', () {
      test('creates external news', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await externalNewsService.createExternalNews(
          'test',
          'test',
          DateTime.now(),
          SimpleFile(name: 'test.png', bytes: Uint8List(5)),
        );
        verify(
          graphQLService.mutate(
            ExternalNewsQueries.createExternalNews,
            variables: {
              'title': 'test',
              'description': 'test',
              'availableFrom': anything,
              'file': anything,
            },
          ),
        ).called(1);
      });
    });

    group('updateExternalNews', () {
      test('updates external news title', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await externalNewsService.updateExternalNews(
          1,
          title: 'test',
        );
        verify(
          graphQLService.mutate(
            ExternalNewsQueries.updateExternalNews,
            variables: {
              'id': 1,
              'title': 'test',
              'description': null,
              'availableFrom': null,
            },
          ),
        ).called(1);
      });
      test('updates external news description', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await externalNewsService.updateExternalNews(
          1,
          description: 'test',
        );
        verify(
          graphQLService.mutate(
            ExternalNewsQueries.updateExternalNews,
            variables: {
              'id': 1,
              'title': null,
              'description': 'test',
              'availableFrom': null,
            },
          ),
        ).called(1);
      });

      test('updates external news png', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await externalNewsService.updateExternalNews(
          1,
          image: SimpleFile(name: 'test.png', bytes: Uint8List(5)),
        );
        verify(
          graphQLService.mutate(
            ExternalNewsQueries.updateExternalNews,
            variables: {
              'id': 1,
              'title': null,
              'file': isNotNull,
              'description': null,
              'availableFrom': null,
            },
          ),
        ).called(1);
      });
    });

    group('removeExternalNews', () {
      test('removes external news', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await externalNewsService.removeExternalNews(1);
        verify(
          graphQLService.mutate(
            ExternalNewsQueries.removeExternalNews,
            variables: {'id': 1},
          ),
        ).called(1);
      });
    });

    group('publishExternalNews', () {
      test('publishes external news', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await externalNewsService.publishExternalNews(1, 'foo', 'bar');
        verify(
          graphQLService.mutate(
            ExternalNewsQueries.publishExternalNews,
            variables: {
              'id': 1,
              'title': 'foo',
              'body': 'bar',
            },
          ),
        ).called(1);
      });
    });

    group('hideExternalNews', () {
      test('hides external news', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await externalNewsService.hideExternalNews(1);
        verify(
          graphQLService.mutate(
            ExternalNewsQueries.hideExternalNews,
            variables: {'id': 1},
          ),
        ).called(1);
      });
    });

    group('getExternalNewsTitle', () {
      test('returns title', () {
        expect(
            externalNewsService.getExternalNewsTitle(ExternalNews(
              title: "test",
              description: 'test',
              availableFrom: DateTime(2021),
            )),
            equals('test'));
      });
    });

    group('getExternalNewsDate', () {
      test('returns correct date format', () {
        initializeDateFormatting('de_CH', null);
        expect(
            externalNewsService.getExternalNewsDate(
              ExternalNews(
                availableFrom: DateTime(2021),
              ),
            ),
            equals('1. Januar 2021 | 00:00'));
      });
    });
  });
}
