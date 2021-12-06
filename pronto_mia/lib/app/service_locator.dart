import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/core/factories/error_message_factory.dart';
import 'package:pronto_mia/core/services/authentication_service.dart';
import 'package:pronto_mia/core/services/deployment_plan_service.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/core/services/graphql_service.dart';
import 'package:pronto_mia/core/services/jwt_token_service.dart';
import 'package:pronto_mia/core/services/pdf_service.dart';
import 'package:pronto_mia/core/services/push_notification_service.dart';
import 'package:pronto_mia/core/services/configuration_service.dart';
import 'package:pronto_mia/core/services/logging_service.dart';
import 'package:pronto_mia/core/services/user_service.dart';
import 'package:pronto_mia/core/services/image_service.dart';
import 'package:pronto_mia/core/services/department_service.dart';
import 'package:pronto_mia/core/services/external_news_service.dart';
import 'package:pronto_mia/core/services/internal_news_service.dart';
import 'package:pronto_mia/core/services/educational_content_service.dart';
import 'package:pronto_mia/ui/shared/custom_dialogs.dart';

/// Exposes the [StackedLocator] instance.
final locator = StackedLocator.instance;

/// Registers all services lazily, either sync or async.
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
  locator.registerLazySingleton<DialogService>(() => DialogService());
  locator.registerLazySingleton<DeploymentPlanService>(
      () => DeploymentPlanService());
  locator.registerLazySingleton<PdfService>(() => PdfService());
  locator.registerLazySingleton<ImageService>(() => ImageService());
  locator.registerLazySingleton<ErrorService>(() => ErrorService());
  locator.registerLazySingleton<DepartmentService>(() => DepartmentService());
  locator
      .registerLazySingleton<ExternalNewsService>(() => ExternalNewsService());
  locator
      .registerLazySingleton<InternalNewsService>(() => InternalNewsService());
  locator.registerLazySingleton<EducationalContentService>(
      () => EducationalContentService());
}
