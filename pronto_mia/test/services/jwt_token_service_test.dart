import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pronto_mia/core/services/jwt_token_service.dart';

import 'package:pronto_mia/core/services/pdf_service.dart';

import '../setup/test_helpers.dart';
import '../setup/test_helpers.mocks.dart';

void main() {
  group('JwtTokenService', () {
    setUp(() {
      registerServices();
    });
    tearDown(() => unregisterServices());

    group('getToken', () {
      test('gets token from secure storage', () async {
        final secureStorage = MockFlutterSecureStorage();
        final jwtTokenService = JwtTokenService(secureStorage: secureStorage);
        when(
          secureStorage.read(key: 'authToken'),
        ).thenAnswer((realInvocation) => Future.value('12345'));

        expect(await jwtTokenService.getToken(), '12345');
        verify(secureStorage.read(key: 'authToken')).called(1);
      });
    });

    group('setToken', () {
      test('sets token in secure storage', () async {
        final secureStorage = MockFlutterSecureStorage();
        final jwtTokenService = JwtTokenService(secureStorage: secureStorage);

        await jwtTokenService.setToken('12345');
        verify(secureStorage.write(key: 'authToken', value: '12345')).called(1);
      });
    });

    group('removeToken', () {
      test('sets token in secure storage', () async {
        final secureStorage = MockFlutterSecureStorage();
        final jwtTokenService = JwtTokenService(secureStorage: secureStorage);

        await jwtTokenService.removeToken();
        verify(secureStorage.delete(key: 'authToken')).called(1);
      });
    });
  });
}
