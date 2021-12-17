import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql/client.dart';
import 'package:logging/logging.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/authentication_service.dart';
import 'package:pronto_mia/core/services/department_service.dart';
import 'package:pronto_mia/core/services/deployment_plan_service.dart';
import 'package:pronto_mia/core/services/external_news_service.dart';
import 'package:pronto_mia/core/services/internal_news_service.dart';
import 'package:pronto_mia/core/services/educational_content_service.dart';
import 'package:pronto_mia/core/services/appointment_service.dart';
import 'package:pronto_mia/core/services/inquiry_service.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/core/services/graphql_service.dart';
import 'package:pronto_mia/core/services/jwt_token_service.dart';
import 'package:pronto_mia/core/services/logging_service.dart';
import 'package:pronto_mia/core/services/pdf_service.dart';
import 'package:pronto_mia/core/services/image_service.dart';
import 'package:pronto_mia/core/services/push_notification_service.dart';
import 'package:pronto_mia/core/services/user_service.dart';
import 'package:stacked_services/stacked_services.dart';

import 'test_helpers.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<GraphQLService>(returnNullOnMissingStub: true),
  MockSpec<JwtTokenService>(returnNullOnMissingStub: true),
  MockSpec<PushNotificationService>(returnNullOnMissingStub: true),
  MockSpec<LoggingService>(returnNullOnMissingStub: true),
  MockSpec<PdfService>(returnNullOnMissingStub: true),
  MockSpec<ImageService>(returnNullOnMissingStub: true),
  MockSpec<NavigationService>(returnNullOnMissingStub: true),
  MockSpec<AuthenticationService>(returnNullOnMissingStub: true),
  MockSpec<ErrorService>(returnNullOnMissingStub: true),
  MockSpec<DepartmentService>(returnNullOnMissingStub: true),
  MockSpec<UserService>(returnNullOnMissingStub: true),
  MockSpec<DialogService>(returnNullOnMissingStub: true),
  MockSpec<DeploymentPlanService>(returnNullOnMissingStub: true),
  MockSpec<ExternalNewsService>(returnNullOnMissingStub: true),
  MockSpec<InternalNewsService>(returnNullOnMissingStub: true),
  MockSpec<EducationalContentService>(returnNullOnMissingStub: true),
  MockSpec<AppointmentService>(returnNullOnMissingStub: true),
  MockSpec<InquiryService>(returnNullOnMissingStub: true),
  MockSpec<GraphQLClient>(returnNullOnMissingStub: true),
  MockSpec<SharedPreferences>(returnNullOnMissingStub: true),
  MockSpec<FlutterSecureStorage>(returnNullOnMissingStub: true),
  MockSpec<Logger>(returnNullOnMissingStub: true),
  MockSpec<CacheManager>(returnNullOnMissingStub: true),
  MockSpec<FirebaseMessaging>(returnNullOnMissingStub: true),
])
GraphQLService getAndRegisterMockGraphQLService() {
  _removeRegistrationIfExists<GraphQLService>();
  final service = MockGraphQLService();
  locator.registerSingletonAsync<GraphQLService>(() => Future.value(service));
  return service;
}

JwtTokenService getAndRegisterMockJwtTokenService() {
  _removeRegistrationIfExists<JwtTokenService>();
  final service = MockJwtTokenService();
  locator.registerSingletonAsync<JwtTokenService>(() => Future.value(service));
  return service;
}

PushNotificationService getAndRegisterMockPushNotificationService() {
  _removeRegistrationIfExists<PushNotificationService>();
  final service = MockPushNotificationService();
  locator.registerSingletonAsync<PushNotificationService>(
    () => Future.value(service),
  );
  return service;
}

LoggingService getAndRegisterMockLoggingService() {
  _removeRegistrationIfExists<LoggingService>();
  final service = MockLoggingService();
  locator.registerSingletonAsync<LoggingService>(() => Future.value(service));
  return service;
}

PdfService getAndRegisterMockPdfService() {
  _removeRegistrationIfExists<PdfService>();
  final service = MockPdfService();
  locator.registerSingleton<PdfService>(service);
  return service;
}

ImageService getAndRegisterMockImageService() {
  _removeRegistrationIfExists<ImageService>();
  final service = MockImageService();
  locator.registerSingleton<ImageService>(service);
  return service;
}

NavigationService getAndRegisterMockNavigationService() {
  _removeRegistrationIfExists<NavigationService>();
  final service = MockNavigationService();
  locator.registerSingleton<NavigationService>(service);
  return service;
}

AuthenticationService getAndRegisterMockAuthenticationService() {
  _removeRegistrationIfExists<AuthenticationService>();
  final service = MockAuthenticationService();
  locator.registerSingleton<AuthenticationService>(service);
  return service;
}

ErrorService getAndRegisterMockErrorService() {
  _removeRegistrationIfExists<ErrorService>();
  final service = MockErrorService();
  locator.registerSingleton<ErrorService>(service);
  return service;
}

DepartmentService getAndRegisterMockDepartmentService() {
  _removeRegistrationIfExists<DepartmentService>();
  final service = MockDepartmentService();
  locator.registerSingleton<DepartmentService>(service);
  return service;
}

UserService getAndRegisterMockUserService() {
  _removeRegistrationIfExists<UserService>();
  final service = MockUserService();
  locator.registerSingleton<UserService>(service);
  return service;
}

DialogService getAndRegisterMockDialogService() {
  _removeRegistrationIfExists<DialogService>();
  final service = MockDialogService();
  locator.registerSingleton<DialogService>(service);
  return service;
}

DeploymentPlanService getAndRegisterMockDeploymentPlanService() {
  _removeRegistrationIfExists<DeploymentPlanService>();
  final service = MockDeploymentPlanService();
  locator.registerSingleton<DeploymentPlanService>(service);
  return service;
}

ExternalNewsService getAndRegisterMockExternalNewsService() {
  _removeRegistrationIfExists<ExternalNewsService>();
  final service = MockExternalNewsService();
  locator.registerSingleton<ExternalNewsService>(service);
  return service;
}

InternalNewsService getAndRegisterMockInternalNewsService() {
  _removeRegistrationIfExists<InternalNewsService>();
  final service = MockInternalNewsService();
  locator.registerSingleton<InternalNewsService>(service);
  return service;
}

EducationalContentService getAndRegisterMockEducationalContentService() {
  _removeRegistrationIfExists<EducationalContentService>();
  final service = MockEducationalContentService();
  locator.registerSingleton<EducationalContentService>(service);
  return service;
}

AppointmentService getAndRegisterMockAppointmentService() {
  _removeRegistrationIfExists<AppointmentService>();
  final service = MockAppointmentService();
  locator.registerSingleton<AppointmentService>(service);
  return service;
}

InquiryService getAndRegisterMockInquiryService() {
  _removeRegistrationIfExists<InquiryService>();
  final service = MockInquiryService();
  locator.registerSingleton<InquiryService>(service);
  return service;
}

void registerServices() {
  getAndRegisterMockGraphQLService();
  getAndRegisterMockJwtTokenService();
  getAndRegisterMockPushNotificationService();
  getAndRegisterMockLoggingService();
  getAndRegisterMockPdfService();
  getAndRegisterMockImageService();
  getAndRegisterMockNavigationService();
  getAndRegisterMockAuthenticationService();
  getAndRegisterMockErrorService();
  getAndRegisterMockDepartmentService();
  getAndRegisterMockUserService();
  getAndRegisterMockDialogService();
  getAndRegisterMockDeploymentPlanService();
  getAndRegisterMockExternalNewsService();
  getAndRegisterMockInternalNewsService();
  getAndRegisterMockEducationalContentService();
  getAndRegisterMockAppointmentService();
  getAndRegisterMockInquiryService();
}

void unregisterServices() {
  locator.unregister<GraphQLService>();
  locator.unregister<JwtTokenService>();
  locator.unregister<PushNotificationService>();
  locator.unregister<LoggingService>();
  locator.unregister<PdfService>();
  locator.unregister<ImageService>();
  locator.unregister<NavigationService>();
  locator.unregister<AuthenticationService>();
  locator.unregister<ErrorService>();
  locator.unregister<DepartmentService>();
  locator.unregister<UserService>();
  locator.unregister<DialogService>();
  locator.unregister<DeploymentPlanService>();
  locator.unregister<ExternalNewsService>();
  locator.unregister<InternalNewsService>();
  locator.unregister<EducationalContentService>();
  locator.unregister<AppointmentService>();
  locator.unregister<InquiryService>();
}

void _removeRegistrationIfExists<T>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
