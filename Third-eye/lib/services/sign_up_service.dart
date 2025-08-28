import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thirdeye/config/urls.dart';
import 'package:thirdeye/models/User.dart';

class SignUpService {
  static Future<bool> sendOtp(String email) async {
    final url = Uri.parse(ConfigURL.sendOtpURL);
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Send OTP error: $e");
      return false;
    }
  }

  static Future<bool> verifyOtp(String email, String otp) async {
    final url = Uri.parse(ConfigURL.verifyOtpURL);
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email, "otp": otp}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Verify OTP error: $e");
      return false;
    }
  }

  static Future<bool> signUpUser(User user) async {
    final url = Uri.parse(ConfigURL.signUpURL);
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "first_name": user.firstName,
          "last_name": user.lastName,
          "email": user.email,
          "password": user.password,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print("Sign up error: $e");
      return false;
    }
  }
}
