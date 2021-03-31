import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  Future<SharedPreferences> get _preferences async =>
      SharedPreferences.getInstance();

  Future<String> getToken() async {
    return (_preferences as SharedPreferences).getString('token');
  }

  Future<void> setToken(String token) async {
    await (_preferences as SharedPreferences).setString('token', token);
  }

  Future<void> clearToken() async {
    await (_preferences as SharedPreferences).clear();
  }
}
