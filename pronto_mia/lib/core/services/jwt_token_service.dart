import 'package:shared_preferences/shared_preferences.dart';

class JwtTokenService {
  // TODO: Replace with something more secure and reliable
  SharedPreferences _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<String> getToken() async {
    return _sharedPreferences.getString('token');
  }

  Future<bool> setToken(String token) async {
    return _sharedPreferences.setString('token', token);
  }
}
