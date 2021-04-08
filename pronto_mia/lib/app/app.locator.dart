// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../core/factories/error_message_factory.dart';
import '../core/services/authentication_service.dart';
import '../core/services/deployment_plan_service.dart';
import '../core/services/graphql_service.dart';
import '../core/services/jwt_token_service.dart';
import '../core/services/pdf_service.dart';
import '../core/services/push_notification_service.dart';

final locator = StackedLocator.instance;

void setupLocator() {
  locator.registerLazySingleton<NavigationService>(() => NavigationService());
  locator.registerLazySingleton<JwtTokenService>(() => JwtTokenService());
  locator.registerLazySingleton<GraphQLService>(() => GraphQLService());
  locator.registerLazySingleton<AuthenticationService>(
      () => AuthenticationService());
  locator.registerLazySingleton<PdfService>(() => PdfService());
  locator.registerLazySingleton<PushNotificationService>(
      () => PushNotificationService());
  locator.registerLazySingleton<DeploymentPlanService>(
      () => DeploymentPlanService());
  locator
      .registerLazySingleton<ErrorMessageFactory>(() => ErrorMessageFactory());
}
