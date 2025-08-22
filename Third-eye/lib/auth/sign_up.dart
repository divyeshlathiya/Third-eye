import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thirdeye/config/urls.dart';
import 'package:thirdeye/models/User.dart';

class SignUpUser {
  static Future<bool> sendOtpUser(String email) async {
    final String sendOtpURL = ConfigURL.sendOtpURL;
    try {
      final url = Uri.parse(sendOtpURL);
      final response = await http.post(
        url,
        headers: {"Content-type": "application/json"},
        body: json.encode({"email": email}),
      );
      print("OTP status : ${response.statusCode}");
      print("Send OTP responce : ${response.body}");
      return response.statusCode == 200;
    } catch (e) {
      print("Send otp error: $e");
      return false;
    }
  }

  static Future<bool> verifyOtp(String email, String otp) async {
    final String verifyOtpURL = ConfigURL.verifyOtpURL;

    try {
      final response = await http.post(Uri.parse(verifyOtpURL),
          headers: {"Content-type": "application/json"},
          body: json.encode({"email": email, "otp": otp}));

      print("Verify OTP: ${response.statusCode}");
      return response.statusCode == 200;
    } catch (e) {
      print("OTP verify error: $e");
      return false;
    }
  }

  static Future<bool> signUpUser(User newUser) async {
    final String apiUrl = ConfigURL.signUpURL;
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
}
