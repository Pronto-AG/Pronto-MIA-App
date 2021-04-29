import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logging/logging.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/queries/fcm_token_queries.dart';
import 'package:pronto_mia/core/services/configuration_service.dart';
import 'package:pronto_mia/core/services/graphql_service.dart';
import 'package:pronto_mia/core/services/logging_service.dart';

class PushNotificationService {
  final _fcm = FirebaseMessaging.instance;
  Future<GraphQLService> get _graphQLService =>
      locator.getAsync<GraphQLService>();
  Future<LoggingService> get _loggingService =>
      locator.getAsync<LoggingService>();

  String _pushMessageServerVapidPublicKey;

  Future<ConfigurationService> get _configurationService =>
      locator.getAsync<ConfigurationService>();

  Future<void> init() async {
    // TODO: Improve permission request
    final notificationSettings = await _fcm.requestPermission();

    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      // TODO: Implement additional message listeners
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    } else {
      // ToDo: Throw error if not worked, ask again, or deactivate completely
    }

    _pushMessageServerVapidPublicKey = (await _configurationService)
        .getValue<String>('pushMessageServerVapidPublicKey');
  }

  Future<void> registerToken() async {
    final token =
        await _fcm.getToken(vapidKey: _pushMessageServerVapidPublicKey);
    final queryVariables = {"fcmToken": token};
    await (await _graphQLService)
        .mutate(FcmTokenQueries.registerFcmToken, queryVariables);
  }

  Future<void> unregisterToken() async {
    final token =
        await _fcm.getToken(vapidKey: _pushMessageServerVapidPublicKey);
    final queryVariables = {"fcmToken": token};
    await (await _graphQLService)
        .mutate(FcmTokenQueries.unregisterFcmToken, queryVariables);
  }

  // TODO: Improve foreground message handling
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    (await _loggingService)
        .log("PushNotificationService", Level.INFO, "Message was received!");

    if (message.notification != null) {
      (await _loggingService).log("PushNotificationService", Level.INFO,
          'Message contained a notification: ${message.notification.body}');
    }
  }
}
