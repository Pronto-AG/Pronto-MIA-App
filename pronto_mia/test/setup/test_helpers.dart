import 'package:mockito/mockito.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/authentication_service.dart';
import 'package:stacked_services/stacked_services.dart';

class AuthenticationServiceMock extends Mock implements AuthenticationService {}

class NavigationServiceMock extends Mock implements NavigationService {}

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

void registerServices() {
  getAndRegisterAuthenticationServiceMock();
  getAndRegisterNavigationServiceMock();
}

void unregisterServices() {
  locator.unregister<AuthenticationService>();
  locator.unregister<NavigationService>();
}

void _removeRegistrationIfExists<T>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
