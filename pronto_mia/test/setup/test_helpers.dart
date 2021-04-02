import 'package:mockito/mockito.dart';

import 'package:pronto_mia/app/app.locator.dart';
// import 'package:pronto_mia/core/services/storage_service.dart';
import 'package:pronto_mia/core/services/authentication_service.dart';
import 'package:stacked_services/stacked_services.dart';

// class StorageServiceMock extends Mock implements StorageService {}
class AuthenticationServiceMock extends Mock implements AuthenticationService {}
class NavigationServiceMock extends Mock implements NavigationService {}

/*
StorageService getAndRegisterStorageServiceMock({int counter = 0}) {
  _removeRegistrationIfExists<StorageService>();
  final service = StorageServiceMock();

  when(service.getCounterValue()).thenAnswer((_) => Future.value(counter));

  locator.registerSingleton<StorageService>(service);
  return service;
}
*/

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
  _removeRegistrationIfExists<AuthenticationService>();
  final service = NavigationServiceMock();

  locator.registerSingleton<NavigationService>(service);
  return service;
}

void registerServices() {
  // getAndRegisterStorageServiceMock();
  getAndRegisterAuthenticationServiceMock();
  getAndRegisterNavigationServiceMock();
}

void unregisterServices() {
  // locator.unregister<StorageService>();
  locator.unregister<AuthenticationService>();
  locator.unregister<NavigationService>();
}

void _removeRegistrationIfExists<T>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
