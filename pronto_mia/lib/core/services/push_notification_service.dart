import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/configuration_service.dart';

class PushNotificationService {
  final _fcm = FirebaseMessaging.instance;

  String _webPushCertificateKey;

  Future<ConfigurationService> get _configurationService =>
      locator.getAsync<ConfigurationService>();

  Future<void> init() async {
    final notificationSettings = await _fcm.requestPermission();

    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      // TODO: Implement additional message listeners
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    }

    if (kIsWeb) {
      _webPushCertificateKey =
      (await _configurationService).getValue<String>('webPushCertificateKey');
    }
  }

  Future<String> getToken() async {
    return _fcm.getToken(vapidKey: _webPushCertificateKey);
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
