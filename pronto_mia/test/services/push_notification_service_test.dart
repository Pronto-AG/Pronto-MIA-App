import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:pronto_mia/core/services/push_notification_service.dart';

import '../setup/test_helpers.dart';
import '../setup/test_helpers.mocks.dart';

void main() {
  group('PushNotificationservice', () {
    setUp(() {
      registerServices();
    });
    tearDown(() => unregisterServices());

    group('notificationsAuthorized', () {
      test('returns true when authorized', () async {
        final fcm = MockFirebaseMessaging();
        final pushNotificationService = PushNotificationService(fcm: fcm);
        when(
          fcm.getNotificationSettings(),
        ).thenAnswer(
          (realInvocation) => Future.value(
            const NotificationSettings(
              authorizationStatus: AuthorizationStatus.authorized,
            ),
          ),
        );

        expect(await pushNotificationService.notificationsAuthorized(), isTrue);
        verify(fcm.getNotificationSettings()).called(1);
      });

      test('returns false when not authorized', () async {
        final fcm = MockFirebaseMessaging();
        final pushNotificationService = PushNotificationService(fcm: fcm);
        when(
          fcm.getNotificationSettings(),
        ).thenAnswer(
          (realInvocation) => Future.value(
            const NotificationSettings(
              authorizationStatus: AuthorizationStatus.denied,
            ),
          ),
        );

        expect(
          await pushNotificationService.notificationsAuthorized(),
          isFalse,
        );
        verify(fcm.getNotificationSettings()).called(1);
      });
    });

    group('requestPermissions', () {
      test('returns true when authorized', () async {
        final fcm = MockFirebaseMessaging();
        final pushNotificationService = PushNotificationService(fcm: fcm);
        when(
          fcm.requestPermission(),
        ).thenAnswer(
          (realInvocation) => Future.value(
            const NotificationSettings(
              authorizationStatus: AuthorizationStatus.authorized,
            ),
          ),
        );

        expect(await pushNotificationService.requestPermissions(), isTrue);
        verify(fcm.requestPermission()).called(1);
      });

      test('returns false when not authorized', () async {
        final fcm = MockFirebaseMessaging();
        final pushNotificationService = PushNotificationService(fcm: fcm);
        when(fcm.requestPermission()).thenAnswer(
          (realInvocation) => Future.value(
            const NotificationSettings(
              authorizationStatus: AuthorizationStatus.denied,
            ),
          ),
        );

        expect(
          await pushNotificationService.requestPermissions(),
          isFalse,
        );
        verify(fcm.requestPermission()).called(1);
      });
    });
  });
}
