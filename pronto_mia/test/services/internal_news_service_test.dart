import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'package:pronto_mia/core/models/internal_news.dart';
import 'package:pronto_mia/core/models/simple_file.dart';
import 'package:pronto_mia/core/queries/internal_news_queries.dart';
import 'package:pronto_mia/core/services/internal_news_service.dart';
import 'package:stacked_services/stacked_services.dart';

import '../setup/test_helpers.dart';

void main() {
  group('InternalNewsService', () {
    InternalNewsService internalNewsService;
    setUp(() {
      registerServices();
      internalNewsService = InternalNewsService();
    });
    tearDown(() => unregisterServices());

    group('getInternalNews', () {
      test('returns internal news', () async {
        final graphQLService = getAndRegisterMockGraphQLService();
        when(
          graphQLService.query(
            captureAny,
            variables: captureAnyNamed('variables'),
            useCache: captureAnyNamed('useCache'),
          ),
        ).thenAnswer(
          (realInvocation) => Future.value({
            'internalNews': [
              {
                'id': 1,
                'title': 'test',
                'description': 'test',
                'availableFrom': DateTime.now().toIso8601String(),
              }
            ]
          }),
        );

        expect(await internalNewsService.getInternalNews(), hasLength(1));
        verify(
          graphQLService.query(InternalNewsQueries.internalNews),
        ).called(1);
      });
    });

    group('getInternalNewsById', () {
      test('returns internal news', () async {
        final graphQLService = getAndRegisterMockGraphQLService();
        when(
          graphQLService.query(
            captureAny,
            variables: captureAnyNamed('variables'),
            useCache: captureAnyNamed('useCache'),
          ),
        ).thenAnswer(
          (realInvocation) => Future.value({
            'internalNews': [
              {
                'id': 1,
                'title': 'test',
                'description': 'test',
                'availableFrom': DateTime.now().toIso8601String(),
              }
            ]
          }),
        );

        expect(await internalNewsService.getInternalNewsById(1), isNotNull);
        verify(
          graphQLService.query(
            InternalNewsQueries.internalNewsById,
            variables: {'id': 1},
          ),
        ).called(1);
      });
    });

    group('getAvailableInternalNews', () {
      test('returns internal news', () async {
        final graphQLService = getAndRegisterMockGraphQLService();
        when(
          graphQLService.query(
            captureAny,
            variables: captureAnyNamed('variables'),
            useCache: captureAnyNamed('useCache'),
          ),
        ).thenAnswer(
          (realInvocation) => Future.value({
            'internalNews': [
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
          await internalNewsService.getAvailableInternalNews(),
          hasLength(1),
        );
        verify(
          graphQLService.query(
            InternalNewsQueries.internalNewsAvailable,
          ),
        ).called(1);
      });
    });

    group('getInternalNewsImage', () {
      test('returns internal news image', () async {
        final imageService = getAndRegisterMockImageService();

        when(
          imageService.downloadImage(captureAny),
        ).thenAnswer(
          (realInvocation) => Future.value(
            SimpleFile(name: 'test.png', bytes: Uint8List(5)),
          ),
        );

        await internalNewsService.getInternalNewsImage(InternalNews(
          id: 1,
          title: 'test',
          description: 'test',
          availableFrom: DateTime.now(),
          link: 'link',
        ));
        verify(
          imageService.downloadImage('link'),
        ).called(1);
      });
    });

    group('createInternalNews', () {
      test('creates internal news', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await internalNewsService.createInternalNews(
          'test',
          'test',
          DateTime.now(),
          SimpleFile(name: 'test.png', bytes: Uint8List(5)),
        );
        verify(
          graphQLService.mutate(
            InternalNewsQueries.createInternalNews,
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

    group('updateInternalNews', () {
      test('updates internal news title', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await internalNewsService.updateInternalNews(
          1,
          title: 'test',
        );
        verify(
          graphQLService.mutate(
            InternalNewsQueries.updateInternalNews,
            variables: {
              'id': 1,
              'title': 'test',
              'description': null,
              'availableFrom': null,
            },
          ),
        ).called(1);
      });
      test('updates internal news description', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await internalNewsService.updateInternalNews(
          1,
          description: 'test',
        );
        verify(
          graphQLService.mutate(
            InternalNewsQueries.updateInternalNews,
            variables: {
              'id': 1,
              'title': null,
              'description': 'test',
              'availableFrom': null,
            },
          ),
        ).called(1);
      });

      test('updates internal news available from', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await internalNewsService.updateInternalNews(
          1,
          availableFrom: DateTime.now(),
        );
        verify(
          graphQLService.mutate(
            InternalNewsQueries.updateInternalNews,
            variables: {
              'id': 1,
              'title': null,
              'description': null,
              'availableFrom': anything,
            },
          ),
        ).called(1);
      });

      test('updates internal news png', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await internalNewsService.updateInternalNews(
          1,
          image: SimpleFile(name: 'test.png', bytes: Uint8List(5)),
        );
        verify(
          graphQLService.mutate(
            InternalNewsQueries.updateInternalNews,
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

    group('removeInternalNews', () {
      test('removes internal news', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await internalNewsService.removeInternalNews(1);
        verify(
          graphQLService.mutate(
            InternalNewsQueries.removeInternalNews,
            variables: {'id': 1},
          ),
        ).called(1);
      });
    });

    group('publishInternalNews', () {
      test('publishes internal news', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await internalNewsService.publishInternalNews(1, 'foo', 'bar');
        verify(
          graphQLService.mutate(
            InternalNewsQueries.publishInternalNews,
            variables: {
              'id': 1,
              'title': 'foo',
              'body': 'bar',
            },
          ),
        ).called(1);
      });
    });

    group('hideInternalNews', () {
      test('hides internal news', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await internalNewsService.hideInternalNews(1);
        verify(
          graphQLService.mutate(
            InternalNewsQueries.hideInternalNews,
            variables: {'id': 1},
          ),
        ).called(1);
      });
    });

    group('getInternalNewsTitle', () {
      test('returns title', () {
        expect(
            internalNewsService.getInternalNewsTitle(InternalNews(
              title: "test",
              description: 'test',
              availableFrom: DateTime(2021),
            )),
            equals('test'));
      });
    });

    group('getInternalNewsDate', () {
      test('returns correct date format', () {
        initializeDateFormatting('de_CH', null);
        expect(
            internalNewsService.getInternalNewsDate(
              InternalNews(
                availableFrom: DateTime(2021),
              ),
            ),
            equals('1. Januar 2021 | 00:00'));
      });
    });

    group('filterInternalNews', () {
      test('returns correct result', () async {
        final graphQLService = getAndRegisterMockGraphQLService();
        when(
          graphQLService.query(
            captureAny,
            variables: captureAnyNamed('variables'),
            useCache: captureAnyNamed('useCache'),
          ),
        ).thenAnswer(
          (realInvocation) => Future.value({
            'internalNews': [
              {
                'id': 1,
                'title': 'test',
                'description': 'test',
                'availableFrom': DateTime.now().toIso8601String(),
              },
            ],
          }),
        );

        expect(
          await internalNewsService.filterInternalNews('test'),
          hasLength(1),
        );
        verify(
          graphQLService.query(
            InternalNewsQueries.filterInternalNews,
            variables: {'filter': anything},
          ),
        ).called(1);
      });
    });

    group('openInternalNews', () {
      test('opens internal news', () async {
        final navigationService = getAndRegisterMockNavigationService();

        await internalNewsService.openInternalNews(InternalNews(
          id: 1,
          title: 'test',
          description: 'test',
          availableFrom: DateTime.now(),
        ));
        verify(
          navigationService.navigateWithTransition(
            argThat(anything),
            transition: NavigationTransition.LeftToRight,
          ),
        ).called(1);
      });
    });
  });
}
