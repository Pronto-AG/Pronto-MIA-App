import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/logging_service.dart';

class JwtTokenService {
  Future<LoggingService> get _loggingService =>
      locator.getAsync<LoggingService>();

  static const String _tokenIdentifier = "authToken";
  static const String _idClaimIdentifier =
      "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier";
  static const String _nameClaimIdentifier =
      "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name";

  SharedPreferences _sharedPreferences;
  FlutterSecureStorage _secureStorage;

  JwtTokenService({
    SharedPreferences sharedPreferences,
    FlutterSecureStorage secureStorage,
  })  : _sharedPreferences = sharedPreferences,
        _secureStorage = secureStorage;

  Future<void> init() async {
    if (kIsWeb) {
      _sharedPreferences =
          _sharedPreferences ?? await SharedPreferences.getInstance();
    } else {
      _secureStorage = _secureStorage ?? const FlutterSecureStorage();
    }
  }

  Future<String> getToken() async {
    if (kIsWeb) {
      return _sharedPreferences.getString(_tokenIdentifier);
    } else {
      return _secureStorage.read(key: _tokenIdentifier);
    }
  }

  Future<void> setToken(String token) async {
    if (kIsWeb) {
      return _sharedPreferences.setString(_tokenIdentifier, token);
    } else {
      return _secureStorage.write(key: _tokenIdentifier, value: token);
    }
  }

  Future<void> removeToken() async {
    if (kIsWeb) {
      return _sharedPreferences.setString(_tokenIdentifier, null);
    } else {
      return _secureStorage.delete(key: _tokenIdentifier);
    }
  }

  Future<bool> hasValidToken() async {
    final token = await getToken();
    var tokenValid = false;

    if (token != null && token.isNotEmpty) {
      try {
        tokenValid = !JwtDecoder.isExpired(token);
      } catch (e) {
        (await _loggingService).log(
            "JwtTokenService", Level.WARNING, "JWT token could not be decoded");
      }
    }

    return tokenValid;
  }

  Future<String> getUserName() async {
    final token = await getToken();
    String userName;

    if (await hasValidToken()) {
      final map = JwtDecoder.decode(token);
      userName = map[_nameClaimIdentifier] as String;
    }

    return userName;
  }

  Future<int> getUserId() async {
    final token = await getToken();
    int userId;

    if (await hasValidToken()) {
      final map = JwtDecoder.decode(token);
      userId = int.parse(map[_idClaimIdentifier] as String);
    }

    return userId;
  }
}
