import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';
import 'package:logging/logging.dart';
import 'package:mockito/mockito.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/core/services/error_service.dart';

import '../setup/test_helpers.dart';

void main() {
  group('ErrorService', ()
  {
    ErrorService errorService;
    setUp(() {
      registerServices();
      errorService = ErrorService();
    });
    tearDown(() => unregisterServices());

    group('handleError', () {
      test('handles standard error', () async {
        final authenticationService = getAndRegisterMockAuthenticationService();
        final navigationService = getAndRegisterMockNavigationService();
        final loggingService = getAndRegisterMockLoggingService();

        await errorService.handleError('test', Exception());
        verifyNever(authenticationService.logout());
        verifyNever(
          navigationService.replaceWithTransition(
            argThat(anything),
            transition: anyNamed('transition'),
          ),
        );
        verify(
          loggingService.log('test', Level.WARNING, argThat(isException)),
        ).called(1);
      });

      test('handles authentication error', () async {
        final authenticationService = getAndRegisterMockAuthenticationService();
        final navigationService = getAndRegisterMockNavigationService();
        final loggingService = getAndRegisterMockLoggingService();

        await errorService.handleError(
          'test',
          OperationException(
            graphqlErrors: [
              const GraphQLError(
                message: 'test',
                extensions: {'code': 'AUTH_NOT_AUTHENTICATED'},
              ),
            ],
          ),
        );
        verify(authenticationService.logout()).called(1);
        verify(
          navigationService.replaceWithTransition(
            argThat(anything),
            transition: NavigationTransition.UpToDown,
          ),
        ).called(1);
        verify(
          loggingService.log('test', Level.WARNING, argThat(anything)),
        ).called(1);
      });
    });

    group('getErrorMessage', () {
      test('returns correct error message', () {
        expect(errorService.getErrorMessage(
          Exception()),
          equals('Es ist ein unerwarteter Fehler aufgetreten.'),
        );
      });
    });
  });
}

