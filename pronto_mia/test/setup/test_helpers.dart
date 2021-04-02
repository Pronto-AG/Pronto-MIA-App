import 'package:mockito/mockito.dart';

import 'package:pronto_mia/app/app.locator.dart';
// import 'package:pronto_mia/core/services/storage_service.dart';

// class StorageServiceMock extends Mock implements StorageService {}

/*
StorageService getAndRegisterStorageServiceMock({int counter = 0}) {
  _removeRegistrationIfExists<StorageService>();
  final service = StorageServiceMock();

  when(service.getCounterValue()).thenAnswer((_) => Future.value(counter));

  locator.registerSingleton<StorageService>(service);
  return service;
}
*/

void registerServices() {
  // getAndRegisterStorageServiceMock();
}

void unregisterServices() {
  // locator.unregister<StorageService>();
}

void _removeRegistrationIfExists<T>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
