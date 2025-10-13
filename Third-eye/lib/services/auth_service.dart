import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/urls.dart';

class AuthService {
  // static Future<Map<String, dynamic>?> login(
  //     String email, String password) async {
  //   final url = Uri.parse(ConfigURL.loginURL);

  //   final response = await http.post(
  //     url,
  //     headers: {'Content-Type': 'application/x-www-form-urlencoded'},
  //     body: {'username': email, 'password': password},
  //   );

  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   }
  //   return null;
  // }
  static Future<Map<String, dynamic>?> login(
      String email, String password) async {
    final url = Uri.parse(ConfigURL.loginURL);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'username': email, 'password': password},
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      if (response.statusCode == 400) {
        return {"error": "Already a Google sign-in user"};
      }
      if (response.statusCode == 401) {
        return {"error": "Invalid email or password"};
      }
      return {"error": "Something went wrong"};
    } catch (e) {
      return {"error": "Network error"};
    }
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

  static Future<Map<String, dynamic>?> getProfile(String accessToken) async {
    final url = Uri.parse(ConfigURL.fetchProfile);

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return null;
  }
}
