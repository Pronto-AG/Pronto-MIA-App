import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:pronto_mia/core/queries/authentication_queries.dart';
import 'package:pronto_mia/core/services/authentication_service.dart';

import '../setup/test_helpers.dart';

void main() {
  group('AuthenticationService', () {
    AuthenticationService authenticationService;
    setUp(() {
      registerServices();
      authenticationService = AuthenticationService();
    });
    tearDown(() => unregisterServices());

    group('login', () {
      test('sets token and enables notifications on successful login',
          () async {
        final graphQLService = getAndRegisterMockGraphQLService();
        final jwtTokenService = getAndRegisterMockJwtTokenService();
        final pushNotificationService =
            getAndRegisterMockPushNotificationService();
        when(graphQLService.query(
          captureAny,
          variables: captureAnyNamed('variables'),
          useCache: captureAnyNamed('useCache'),
        )).thenAnswer(
          (realInvocation) => Future.value({'authenticate': '12345'}),
        );

        await authenticationService.login('admin', '12345');
        verify(
          graphQLService.query(
            AuthenticationQueries.authenticate,
            variables: {
              'userName': 'admin',
              'password': '12345',
            },
            useCache: false,
          ),
        ).called(1);
        verify(jwtTokenService.setToken('12345')).called(1);
        verify(pushNotificationService.enableNotifications()).called(1);
      });

      test('throws exception on failed login', () {
        final graphQLService = getAndRegisterMockGraphQLService();
        final jwtTokenService = getAndRegisterMockJwtTokenService();
        final pushNotificationService =
            getAndRegisterMockPushNotificationService();
        when(graphQLService.query(
          AuthenticationQueries.authenticate,
          variables: {
            'userName': 'admin',
            'password': '12345',
          },
          useCache: false,
        )).thenThrow(Exception());

        expect(authenticationService.login('admin', '12345'), throwsException);
        verifyNever(jwtTokenService.setToken(argThat(anything)));
        verifyNever(pushNotificationService.enableNotifications());
      });
    });

    group('logout', () {
      test('removes token and disables notifications on successful logout',
          () async {
        final jwtTokenService = getAndRegisterMockJwtTokenService();
        final pushNotificationService =
            getAndRegisterMockPushNotificationService();

        await authenticationService.logout();
        verify(jwtTokenService.setToken('')).called(1);
        verify(pushNotificationService.disableNotifications());
      });
    });

    group('isAuthenticated', () {
      test('returns token status', () async {
        final jwtTokenService = getAndRegisterMockJwtTokenService();
        when(jwtTokenService.hasValidToken())
            .thenAnswer((realInvocation) => Future.value(true));

        expect(await authenticationService.isAuthenticated(), equals(true));
        verify(jwtTokenService.hasValidToken()).called(1);
      });
    });
  });
}
