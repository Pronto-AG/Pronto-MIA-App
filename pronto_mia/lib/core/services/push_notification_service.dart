import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/queries/fcm_token_queries.dart';
import 'package:pronto_mia/core/services/configuration_service.dart';
import 'package:pronto_mia/core/services/graphql_service.dart';

class PushNotificationService {
  final _fcm = FirebaseMessaging.instance;
  Future<GraphQLService> get _graphQLService =>
      locator.getAsync<GraphQLService>();

  String _webPushCertificateKey;

  Future<ConfigurationService> get _configurationService =>
      locator.getAsync<ConfigurationService>();

  Future<void> init() async {
    // TODO: Improve permission request
    final notificationSettings = await _fcm.requestPermission();
    print(notificationSettings.authorizationStatus);

    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      // TODO: Implement additional message listeners
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    } else {
      // ToDo: Throw error if not worked, ask again, or deactivate completely
    }

    if (kIsWeb) {
      _webPushCertificateKey = (await _configurationService)
          .getValue<String>('webPushCertificateKey');
    }
  }

  Future<void> registerToken() async {
    final token = await _fcm.getToken(vapidKey: _webPushCertificateKey);
    final queryVariables = {"fcmToken": token};
    await (await _graphQLService)
        .mutate(FcmTokenQueries.registerFcmToken, queryVariables);
  }

  Future<void> unregisterToken() async {
    final token = await _fcm.getToken(vapidKey: _webPushCertificateKey);
    final queryVariables = {"fcmToken": token};
    await (await _graphQLService)
        .mutate(FcmTokenQueries.unregisterFcmToken, queryVariables);
  }

  // TODO: Improve foreground message handling
  void _handleForegroundMessage(RemoteMessage message) {
    // ignore: avoid_print
    print('Message was received!');

    if (message.notification != null) {
      // ignore: avoid_print
      print('Message contained a notification: ${message.notification.body}');
    }
  }
}
