// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../core/services/authentication_service.dart';
import '../core/services/graphql_service.dart';
import '../core/services/jwt_token_service.dart';
import '../core/services/pdf_service.dart';
import '../core/services/push_notification_service.dart';

final locator = StackedLocator.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => JwtTokenService());
  locator.registerLazySingleton(() => GraphQLService());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => PdfService());
  locator.registerLazySingleton(() => PushNotificationService());
}
