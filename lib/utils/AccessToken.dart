import 'package:shared_preferences/shared_preferences.dart';

class AccessTokenUtil {
  static const String _accessTokenKey = 'access_token';

  // Save the access token to local storage
  static Future<void> saveAccessToken(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
  }

  // Read the access token from local storage
  static Future<String?> readAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  // Delete the access token from local storage
  static Future<void> deleteAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
  }
}
