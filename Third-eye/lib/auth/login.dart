import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thirdeye/config/urls.dart';

Future<bool> loginUser(String email, String password) async {
  final String apiUrl = ConfigURL.loginURL;

  try {
    final url = Uri.parse(apiUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'username': email,
        'password': password,
      },
    );

    print("Status: ${response.statusCode}");
    print("Response: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey('access_token')) {
        final token = data['access_token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', token);
        // print("Token saved: $token");
        return true;
      } else {
        // print("No access_token in response.");
        return false;
      }
    } else {
      // print("Login failed: ${response.body}");
      return false;
    }
  } catch (e) {
    // print("HTTP request error: $e");
    return false;
  }
}
