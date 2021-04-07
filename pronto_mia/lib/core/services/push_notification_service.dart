import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:global_configuration/global_configuration.dart';

class PushNotificationService {
  final _configuration = GlobalConfiguration();
  final _fcm = FirebaseMessaging.instance;

  String _webPushCertificateKey;

  Future<void> initialise() async {
    final notificationSettings = await _fcm.requestPermission();

    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    }

    if (kIsWeb) {
      _webPushCertificateKey =
          _configuration.getValue<String>('webPushCertificateKey');
    }
  }

  Future<String> getToken() async {
    return _fcm.getToken(vapidKey: _webPushCertificateKey);
  }

  void _handleForegroundMessage(RemoteMessage message) {
    // ignore: avoid_print
    print('Message was received!');

    if (message.notification != null) {
      // ignore: avoid_print
      print('Message contained a notification: ${message.notification.body}');
    }
  }
}
