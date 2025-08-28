import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/urls.dart';
import '../utils/storage_helper.dart';

class AuthService {
  static Future<Map<String, dynamic>?> login(
      String email, String password) async {
    final url = Uri.parse(ConfigURL.loginURL);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'username': email, 'password': password},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return null;
  }

  static Future<Map<String, dynamic>?> refreshToken(String refreshToken) async {
    final url = Uri.parse(ConfigURL.refreshTokenURL);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'refresh_token': refreshToken}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return null;
  }

  Future<void> logout() async {
    await StorageHelper.clearAll();
  }
}
