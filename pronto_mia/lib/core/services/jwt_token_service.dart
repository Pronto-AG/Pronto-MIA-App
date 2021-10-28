import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logging/logging.dart';
import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/logging_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service, responsible for accessing the JWT token.
///
/// It uses different persistence solutions for different platforms.
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

  /// Initializes a new instance of [JwtTokenService].
  ///
  /// Takes [SharedPreferences] and [FlutterSecureStorage] as persistence
  /// solutions for different platforms as an input.
  JwtTokenService({
    SharedPreferences sharedPreferences,
    FlutterSecureStorage secureStorage,
  })  : _sharedPreferences = sharedPreferences,
        _secureStorage = secureStorage;

  /// Initializes the current platforms persistence solution if that not already
  /// happened.
  Future<void> init() async {
    if (kIsWeb) {
      _sharedPreferences =
          _sharedPreferences ?? await SharedPreferences.getInstance();
    } else {
      _secureStorage = _secureStorage ?? const FlutterSecureStorage();
    }
  }

  /// Gets the current JWT token from the current platforms persistence
  /// solution.
  ///
  /// Returns the [String] JWT token.
  Future<String> getToken() async {
    if (kIsWeb) {
      return _sharedPreferences.getString(_tokenIdentifier);
    } else {
      return _secureStorage.read(key: _tokenIdentifier);
    }
  }

  /// Sets the JWT token for the current platforms persistence
  /// solution.
  ///
  /// Takes the [String] JWT token as an input.
  Future<void> setToken(String token) async {
    if (kIsWeb) {
      return _sharedPreferences.setString(_tokenIdentifier, token);
    } else {
      return _secureStorage.write(key: _tokenIdentifier, value: token);
    }
  }

  /// Removes the current JWT token from the current platforms persistence
  /// solution.
  Future<void> removeToken() async {
    if (kIsWeb) {
      return _sharedPreferences.setString(_tokenIdentifier, null);
    } else {
      return _secureStorage.delete(key: _tokenIdentifier);
    }
  }

  /// Determines if the current JWT token is valid.
  ///
  /// Returns wether the current token is valid or not as [bool].
  /// The determination is performed by checking if the token is expired or not.
  Future<bool> hasValidToken() async {
    final token = await getToken();
    var tokenValid = false;

    if (token != null && token.isNotEmpty) {
      try {
        tokenValid = !JwtDecoder.isExpired(token);
      } catch (e) {
        (await _loggingService).log(
          "JwtTokenService",
          Level.WARNING,
          "JWT token could not be decoded",
        );
      }
    }

    return tokenValid;
  }

  /// Extracts the current users username from the current JWT token.
  ///
  /// Returns the [String] username contained in the token.
  Future<String> getUserName() async {
    final token = await getToken();
    String userName;

    if (await hasValidToken()) {
      final map = JwtDecoder.decode(token);
      userName = map[_nameClaimIdentifier] as String;
    }

    return userName;
  }

  /// Extracts the current users id from the current JWT token.
  ///
  /// Returns the [int] user id contained in the token.
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
