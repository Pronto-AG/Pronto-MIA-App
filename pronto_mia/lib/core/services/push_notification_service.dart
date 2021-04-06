import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final _fcm = FirebaseMessaging.instance;

  Future<void> initialise() async {
    final notificationSettings = await _fcm.requestPermission();

    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // ignore: avoid_print
        print('Message was received!');

        if (message.notification != null) {
          // ignore: avoid_print
          print(
              'Message contained a notification: ${message.notification.body}'
          );
        }
      });
    }
  }

  Future<String> getToken() async {
    return _fcm.getToken(
      // ignore: lines_longer_than_80_chars
      vapidKey: 'BPD1n6GbFtXrNJuBmYaW065gUAas_6vPuMtGF2dd3aNwCEryKu53mDiFGLfM0J0lrsoNZnOYgnrEvn-3dKWaqzE',
    );
  }
}
