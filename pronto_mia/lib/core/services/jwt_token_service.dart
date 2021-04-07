// TODO: Replace with secure storage
import 'package:shared_preferences/shared_preferences.dart';

class JwtTokenService {
  Future<SharedPreferences> get _preferences async =>
      SharedPreferences.getInstance();

  Future<String> getToken() async {
    final preferences = await _preferences;
    return preferences.getString('token');
  }

  Future<bool> setToken(String token) async {
    final preferences = await _preferences;
    return preferences.setString('token', token);
  }
}
