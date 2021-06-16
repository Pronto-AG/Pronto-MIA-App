import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pronto_mia/core/models/access_control_list.dart';

import 'package:pronto_mia/core/queries/user_queries.dart';
import 'package:pronto_mia/core/services/user_service.dart';

import '../setup/test_helpers.dart';

void main() {
  group('UserService', () {
    UserService userService;
    setUp(() {
      registerServices();
      userService = UserService();
    });
    tearDown(() => unregisterServices());

    group('getCurrentUser', () {
      test('returns user on user found', () async {
        final graphQLService = getAndRegisterMockGraphQLService();
        when(
          graphQLService.query(
            captureAny,
            variables: captureAnyNamed('variables'),
            useCache: captureAnyNamed('useCache'),
          ),
        ).thenAnswer((realInvocation) => Future.value({
              'user': {
                'id': 1,
                'userName': 'test',
              }
            }));

        expect(await userService.getCurrentUser(), isNotNull);
        verify(graphQLService.query(UserQueries.currentUser)).called(1);
      });

      test('returns null on no user found', () async {
        final graphQLService = getAndRegisterMockGraphQLService();
        final loggingService = getAndRegisterMockLoggingService();
        when(
          graphQLService.query(
            captureAny,
            variables: captureAnyNamed('variables'),
            useCache: captureAnyNamed('useCache'),
          ),
        ).thenAnswer((realInvocation) => Future.value({
              'user': {
                'id': null,
              }
            }));

        expect(await userService.getCurrentUser(), isNull);
        verify(graphQLService.query(UserQueries.currentUser)).called(1);
        verify(loggingService.log(
          'UserService',
          argThat(anything),
          argThat(anything),
        ));
      });
    });

    group('getUsers', () {
      test('returns users', () async {
        final graphQLService = getAndRegisterMockGraphQLService();
        when(
          graphQLService.query(
            captureAny,
            variables: captureAnyNamed('variables'),
            useCache: captureAnyNamed('useCache'),
          ),
        ).thenAnswer(
          (realInvocation) => Future.value({
            'users': [
              {
                'id': 1,
                'name': 'test',
              }
            ]
          }),
        );

        expect(await userService.getUsers(), hasLength(1));
        verify(graphQLService.query(UserQueries.users)).called(1);
      });
    });

    group('createUser', () {
      test('creates user', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await userService.createUser('test', '12345', 1, AccessControlList());
        verify(
          graphQLService.mutate(
            UserQueries.createUser,
            variables: {
              'userName': 'test',
              'password': '12345',
              'departmentId': 1,
              'accessControlList': anything,
            },
          ),
        ).called(1);
      });
    });

    group('updateUser', () {
      test('updates user', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await userService.updateUser(
          1,
          userName: 'test',
          accessControlList: AccessControlList(),
        );
        verify(
          graphQLService.mutate(
            UserQueries.updateUser,
            variables: {
              'id': 1,
              'userName': 'test',
              'password': null,
              'departmentId': null,
              'accessControlList': anything,
            },
          ),
        ).called(1);
      });
    });

    group('removeUser', () {
      test('removes user', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await userService.removeUser(1);
        verify(
          graphQLService.mutate(
            UserQueries.removeUser,
            variables: {'id': 1},
          ),
        ).called(1);
      });
    });
  });
}
