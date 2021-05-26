import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/authentication_service.dart';
import 'package:pronto_mia/core/services/graphql_service.dart';
import 'package:pronto_mia/core/services/jwt_token_service.dart';
import 'package:pronto_mia/core/services/push_notification_service.dart';
import 'package:stacked_services/stacked_services.dart';

import 'test_helpers.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<GraphQLService>(returnNullOnMissingStub: true),
  MockSpec<JwtTokenService>(returnNullOnMissingStub: true),
  MockSpec<PushNotificationService>(returnNullOnMissingStub: true),
])

// class AuthenticationServiceMock extends Mock implements AuthenticationService {}

// class NavigationServiceMock extends Mock implements NavigationService {}

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
      () => Future.value(service));
  return service;
}

/*
AuthenticationService getAndRegisterAuthenticationServiceMock({
  String username = 'Username',
  String password = 'Password',
}) {
  _removeRegistrationIfExists<AuthenticationService>();
  final service = AuthenticationServiceMock();

  when(service.login(username, password))
      .thenAnswer((realInvocation) => Future.value());

  locator.registerSingleton<AuthenticationService>(service);
  return service;
}

NavigationService getAndRegisterNavigationServiceMock() {
  _removeRegistrationIfExists<NavigationService>();
  final service = NavigationServiceMock();

  locator.registerSingleton<NavigationService>(service);
  return service;
}
 */

void registerServices() {
  getAndRegisterMockGraphQLService();
  getAndRegisterMockJwtTokenService();
  getAndRegisterMockPushNotificationService();
  // getAndRegisterMockAuthenticationService();
  // getAndRegisterMockNavigationService();
}

void unregisterServices() {
  locator.unregister<GraphQLService>();
  locator.unregister<JwtTokenService>();
  locator.unregister<PushNotificationService>();
  // locator.unregister<AuthenticationService>();
  // locator.unregister<NavigationService>();
}

void _removeRegistrationIfExists<T>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
