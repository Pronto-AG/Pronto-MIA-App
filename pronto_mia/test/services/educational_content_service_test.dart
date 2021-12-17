import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:pronto_mia/core/models/educational_content.dart';
import 'package:pronto_mia/core/models/simple_file.dart';
import 'package:pronto_mia/core/queries/educational_content_queries.dart';
import 'package:pronto_mia/core/services/educational_content_service.dart';
import 'package:stacked_services/stacked_services.dart';

import '../setup/test_helpers.dart';

void main() {
  group('EducationalContentService', () {
    EducationalContentService educationalContentService;
    setUp(() {
      registerServices();
      educationalContentService = EducationalContentService();
    });
    tearDown(() => unregisterServices());

    group('getEducationalContent', () {
      test('returns educational content', () async {
        final graphQLService = getAndRegisterMockGraphQLService();
        when(
          graphQLService.query(
            captureAny,
            variables: captureAnyNamed('variables'),
            useCache: captureAnyNamed('useCache'),
          ),
        ).thenAnswer(
          (realInvocation) => Future.value({
            'educationalContent': [
              {
                'id': 1,
                'title': 'test',
                'description': 'test',
              }
            ]
          }),
        );

        expect(await educationalContentService.getEducationalContent(),
            hasLength(1));
        verify(
          graphQLService.query(EducationalContentQueries.educationalContent),
        ).called(1);
      });
    });

    group('getEducationalContentById', () {
      test('returns educational content', () async {
        final graphQLService = getAndRegisterMockGraphQLService();
        when(
          graphQLService.query(
            captureAny,
            variables: captureAnyNamed('variables'),
            useCache: captureAnyNamed('useCache'),
          ),
        ).thenAnswer(
          (realInvocation) => Future.value({
            'educationalContent': [
              {
                'id': 1,
                'title': 'test',
                'description': 'test',
              }
            ]
          }),
        );

        expect(await educationalContentService.getEducationalContentById(1),
            isNotNull);
        verify(
          graphQLService.query(
            EducationalContentQueries.educationalContentById,
            variables: {'id': 1},
          ),
        ).called(1);
      });
    });

    group('getAvailableEducationalContent', () {
      test('returns educational content', () async {
        final graphQLService = getAndRegisterMockGraphQLService();
        when(
          graphQLService.query(
            captureAny,
            variables: captureAnyNamed('variables'),
            useCache: captureAnyNamed('useCache'),
          ),
        ).thenAnswer(
          (realInvocation) => Future.value({
            'educationalContent': [
              {
                'id': 1,
                'title': 'test',
                'description': 'test',
              }
            ]
          }),
        );

        expect(
          await educationalContentService.getAvailableEducationalContent(),
          hasLength(1),
        );
        verify(
          graphQLService.query(
            EducationalContentQueries.educationalContentAvailable,
          ),
        ).called(1);
      });
    });

    group('createEducationalContent', () {
      test('creates educational content', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await educationalContentService.createEducationalContent(
          'test',
          'test',
          SimpleFile(name: 'test.mp4', bytes: Uint8List(5)),
        );
        verify(
          graphQLService.mutate(
            EducationalContentQueries.createEducationalContent,
            variables: {
              'title': 'test',
              'description': 'test',
              'file': anything,
            },
          ),
        ).called(1);
      });
    });

    group('updateEducationalContent', () {
      test('updates educational content title', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await educationalContentService.updateEducationalContent(
          1,
          title: 'test',
        );
        verify(
          graphQLService.mutate(
            EducationalContentQueries.updateEducationalContent,
            variables: {
              'id': 1,
              'title': 'test',
              'description': null,
            },
          ),
        ).called(1);
      });
      test('updates educational content description', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await educationalContentService.updateEducationalContent(
          1,
          description: 'test',
        );
        verify(
          graphQLService.mutate(
            EducationalContentQueries.updateEducationalContent,
            variables: {
              'id': 1,
              'title': null,
              'description': 'test',
            },
          ),
        ).called(1);
      });

      test('updates educational content mp4', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await educationalContentService.updateEducationalContent(
          1,
          file: SimpleFile(name: 'test.mp4', bytes: Uint8List(5)),
        );
        verify(
          graphQLService.mutate(
            EducationalContentQueries.updateEducationalContent,
            variables: {
              'id': 1,
              'title': null,
              'file': isNotNull,
              'description': null,
            },
          ),
        ).called(1);
      });
    });

    group('removeEducationalContent', () {
      test('removes educational content', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await educationalContentService.removeEducationalContent(1);
        verify(
          graphQLService.mutate(
            EducationalContentQueries.removeEducationalContent,
            variables: {'id': 1},
          ),
        ).called(1);
      });
    });

    group('publishEducationalContent', () {
      test('publishes educational content', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await educationalContentService.publishEducationalContent(
            1, 'foo', 'bar');
        verify(
          graphQLService.mutate(
            EducationalContentQueries.publishEducationalContent,
            variables: {
              'id': 1,
              'title': 'foo',
              'body': 'bar',
            },
          ),
        ).called(1);
      });
    });

    group('hideEducationalContent', () {
      test('hides educational content', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await educationalContentService.hideEducationalContent(1);
        verify(
          graphQLService.mutate(
            EducationalContentQueries.hideEducationalContent,
            variables: {'id': 1},
          ),
        ).called(1);
      });
    });

    group('getEducationalContentTitle', () {
      test('returns title', () {
        expect(
            educationalContentService
                .getEducationalContentTitle(EducationalContent(
              title: "test",
              description: 'test',
            )),
            equals('test'));
      });
    });

    group('filterEducationalContent', () {
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
            'educationalContent': [
              {
                'id': 1,
                'title': 'test',
                'description': 'test',
              }
            ]
          }),
        );

        expect(
          await educationalContentService.filterEducationalContent('test'),
          hasLength(1),
        );
        verify(
          graphQLService.query(
            EducationalContentQueries.filterEducationalContent,
            variables: {'filter': anything},
          ),
        ).called(1);
      });
    });

    group('openEducationalContent', () {
      test('opens pdf with educational content', () async {
        final navigationService = getAndRegisterMockNavigationService();

        await educationalContentService
            .openEducationalContent(EducationalContent(
          id: 1,
          title: 'test',
          description: 'test',
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
