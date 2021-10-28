import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logging/logging.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/queries/fcm_token_queries.dart';
import 'package:pronto_mia/core/services/configuration_service.dart';
import 'package:pronto_mia/core/services/deployment_plan_service.dart';
import 'package:pronto_mia/core/services/graphql_service.dart';
import 'package:pronto_mia/core/services/logging_service.dart';
import 'package:pronto_mia/ui/components/deployment_plan_notification.dart';
import 'package:pronto_mia/ui/shared/custom_dialogs.dart';
import 'package:stacked_services/stacked_services.dart';

/// A service, responsible for interacting with firebase cloud
/// messaging.
///
/// Contains functionality to manage notification permissions and handle
/// push messages.
class PushNotificationService {
  FirebaseMessaging _fcm;
  Future<GraphQLService> get _graphQLService =>
      locator.getAsync<GraphQLService>();
  Future<LoggingService> get _loggingService =>
      locator.getAsync<LoggingService>();
  DeploymentPlanService get _deploymentPlanService =>
      locator.get<DeploymentPlanService>();
  DialogService get _dialogService => locator.get<DialogService>();
  Future<ConfigurationService> get _configurationService =>
      locator.getAsync<ConfigurationService>();

  String _pushMessageServerVapidPublicKey;
  bool _notificationsEnabled = false;
  bool _pushDialogOpen = false;

  /// Initializes a new instance of [PushNotificationService].
  ///
  /// Takes [FirebaseMessaging] as an input.
  PushNotificationService({FirebaseMessaging fcm}) : _fcm = fcm;

  /// Initializes firebase and firebase messaging.
  ///
  /// Also reads the vapid public key from configuration.
  Future<void> init() async {
    await Firebase.initializeApp();
    _fcm = _fcm ?? FirebaseMessaging.instance;
    _pushMessageServerVapidPublicKey = (await _configurationService)
        .getValue<String>('pushMessageServerVapidPublicKey');
  }

  /// Checks if the app is authorized for notifications.
  ///
  /// Returns wether notifications are allowed as [bool].
  Future<bool> notificationsAuthorized() async {
    final notificationSettings = await _fcm.getNotificationSettings();
    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      return true;
    }
    return false;
  }

  /// Requests permission for notifications.
  ///
  /// Returns wether notifications are allowed as [bool].
  Future<bool> requestPermissions() async {
    final notificationSettings = await _fcm.requestPermission();
    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      return true;
    }
    return false;
  }

  /// Registers current device and enables notifications.
  Future<void> enableNotifications() async {
    if (!_notificationsEnabled && await notificationsAuthorized()) {
      final token =
          await _fcm.getToken(vapidKey: _pushMessageServerVapidPublicKey);

      final queryVariables = {"fcmToken": token};
      await (await _graphQLService).mutate(
        FcmTokenQueries.registerFcmToken,
        variables: queryVariables,
      );

      FirebaseMessaging.onMessage.listen(_handleMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

      _notificationsEnabled = true;
    }
  }

  /// Unregisters current device and disables notifications.
  Future<void> disableNotifications() async {
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
  }

  /// Handles initial message from firebase.
  ///
  /// Determines what to do according to the content of the message.
  Future<void> handleInitialMessage() async {
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    if (message.data != null) {
      final action = message.data['Action'].toString();
      switch (action) {
        case "publish":
          (await _loggingService).log(
            "PushNotificationService",
            Level.INFO,
            'Message is a publish',
          );
          await _handlePublishMessages(message);
          break;
        default:
          (await _loggingService).log(
            "PushNotificationService",
            Level.WARNING,
            'Message contained an unknown action: $action',
          );
      }
    }
  }

  Future<void> _handlePublishMessages(RemoteMessage message) async {
    final targetType = message.data['TargetType'].toString();
    switch (targetType) {
      case "deploymentPlan":
        (await _loggingService).log(
          "PushNotificationService",
          Level.INFO,
          'Message is a deploymentPlan',
        );
        await _handleDeploymentPlanPublish(message);
        break;
      default:
        (await _loggingService).log(
          "PushNotificationService",
          Level.WARNING,
          'Message contained an unknown target: $targetType',
        );
    }
  }

  Future<void> _handleDeploymentPlanPublish(RemoteMessage message) async {
    _deploymentPlanService.notifyDataChanged();

    final targetId = int.parse(message.data['TargetId'].toString());
    final deploymentPlan =
        await _deploymentPlanService.getDeploymentPlan(targetId);

    final deploymentPlanTitle =
        _deploymentPlanService.getDeploymentPlanTitle(deploymentPlan);

    if (_pushDialogOpen) {
      _dialogService.completeDialog(DialogResponse());
    }

    _pushDialogOpen = true;
    await _dialogService.showCustomDialog(
      variant: DialogType.custom,
      data: DeploymentPlanNotification(
        title: "Einsatzplan veröffentlicht",
        body: 'Der Einsatzplan "$deploymentPlanTitle" '
            'wurde soeben veröffentlicht.',
        onViewPressed: () async =>
            {await _deploymentPlanService.openPdfWithReplace(deploymentPlan)},
      ),
    );
    _pushDialogOpen = false;
  }
}
