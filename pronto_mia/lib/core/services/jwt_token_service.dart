import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class JwtTokenService {
  // TODO: Replace with something more secure and reliable
  static const String _tokenIdentifier = "authToken";
  SharedPreferences _sharedPreferences;
  FlutterSecureStorage _secureStorage;

  Future<void> init() async {
    if (kIsWeb) {
      _sharedPreferences = await SharedPreferences.getInstance();
    } else {
      _secureStorage = const FlutterSecureStorage();
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

  Future<void> removeToken(String token) async {
    if (kIsWeb) {
      return _sharedPreferences.setString(_tokenIdentifier, null);
    } else {
      return _secureStorage.delete(key: _tokenIdentifier);
    }
  }
}
