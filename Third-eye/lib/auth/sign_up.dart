import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thirdeye/models/User.dart';

Future<bool> signUpUser(User newUser) async {
  final String apiUrl = "http://10.47.125.29:8000/auth/register";
  // final String apiUrl = "http://localhost:8000/auth/register";
  try {
    final url = Uri.parse(apiUrl);
    final response = await http.post(url,
        headers: {"Content-type": "application/json"},
        body: json.encode({
          "first_name": newUser.firstName,
          "last_name": newUser.lastName,
          "email": newUser.email,
          "password": newUser.password
        }));

    print("Status code: ${response.statusCode}");
    print("Response: ${response.body}");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey("email")) {
        final email = data["email"];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("email", email);

        print("Email: $email");

        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
