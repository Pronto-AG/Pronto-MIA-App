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
  bool _notificationsEnabled = false;

  Future<ConfigurationService> get _configurationService =>
      locator.getAsync<ConfigurationService>();

  Future<void> init() async {
    _pushMessageServerVapidPublicKey = (await _configurationService)
        .getValue<String>('pushMessageServerVapidPublicKey');
  }

  Future<bool> notificationsAuthorized() async {
    final notificationSettings = await _fcm.getNotificationSettings();
    print(notificationSettings.authorizationStatus);
    if (notificationSettings.authorizationStatus == AuthorizationStatus.authorized) {
      return true;
    }
    return false;
  }

  Future<bool> requestPermissions() async {
    final notificationSettings = await _fcm.requestPermission();
    if (notificationSettings.authorizationStatus == AuthorizationStatus.authorized) {
      return true;
    }
    return false;
  }

  Future<void> enableNotifications() async {
    print('notificationsEnabled $_notificationsEnabled');
    if (!_notificationsEnabled && await notificationsAuthorized()) {
      final token = await _fcm.getToken(vapidKey: _pushMessageServerVapidPublicKey);

      final queryVariables = {"fcmToken": token};
      await (await _graphQLService).mutate(
        FcmTokenQueries.registerFcmToken,
        variables: queryVariables,
      );

      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      _notificationsEnabled = true;
    }
    print('notificationsEnabled $_notificationsEnabled');
  }

  Future<void> disableNotifications() async {
    print('notificationsEnabled $_notificationsEnabled');
    if (_notificationsEnabled) {
      final token =
      await _fcm.getToken(vapidKey: _pushMessageServerVapidPublicKey);
      final queryVariables = {"fcmToken": token};
      await (await _graphQLService).mutate(
        FcmTokenQueries.unregisterFcmToken,
        variables: queryVariables,
      );

      _notificationsEnabled = false;
    }
    print('notificationsEnabled $_notificationsEnabled');
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
