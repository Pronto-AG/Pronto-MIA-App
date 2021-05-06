import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/core/factories/error_message_factory.dart';
import 'package:pronto_mia/core/services/authentication_service.dart';
import 'package:pronto_mia/core/services/deployment_plan_service.dart';
import 'package:pronto_mia/core/services/graphql_service.dart';
import 'package:pronto_mia/core/services/jwt_token_service.dart';
import 'package:pronto_mia/core/services/pdf_service.dart';
import 'package:pronto_mia/core/services/push_notification_service.dart';
import 'package:pronto_mia/core/services/configuration_service.dart';
import 'package:pronto_mia/core/services/logging_service.dart';
import 'package:pronto_mia/core/services/user_service.dart';
import 'package:pronto_mia/ui/shared/custom_dialogs.dart';

final locator = StackedLocator.instance;

void setupLocator() {
  locator.registerLazySingletonAsync<ConfigurationService>(() async {
    final configurationService = ConfigurationService();
    await configurationService.init();
    return configurationService;
  });

  locator.registerLazySingletonAsync<JwtTokenService>(() async {
    final jwtTokenService = JwtTokenService();
    await jwtTokenService.init();
    return jwtTokenService;
  });

  locator.registerLazySingletonAsync<GraphQLService>(() async {
    final graphQLService = GraphQLService();
    await graphQLService.init();
    return graphQLService;
  });

  locator.registerLazySingletonAsync<PushNotificationService>(() async {
    final pushNotificationService = PushNotificationService();
    await pushNotificationService.init();
    return pushNotificationService;
  });

  locator.registerLazySingletonAsync<LoggingService>(() async {
    final loggingService = LoggingService();
    await loggingService.init();
    return loggingService;
  });

  locator.registerLazySingleton<UserService>(() => UserService());
  locator.registerLazySingleton<AuthenticationService>(
      () => AuthenticationService());
  locator.registerLazySingleton<NavigationService>(() => NavigationService());
  locator.registerLazySingleton<DialogService>(
      () => DialogService());
  locator.registerLazySingleton<DeploymentPlanService>(
      () => DeploymentPlanService());
  locator.registerLazySingleton<PdfService>(() => PdfService());
  locator
      .registerLazySingleton<ErrorMessageFactory>(() => ErrorMessageFactory());
}
