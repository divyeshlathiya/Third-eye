import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thirdeye/config/urls.dart';
import 'package:thirdeye/models/User.dart';

class SignUpService {
  static Future<bool> sendOtp(String email, String purpose) async {
    final url = Uri.parse(ConfigURL.sendOtpURL);
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email, "purpose": purpose}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Send OTP error: $e");
      return false;
    }
  }

  static Future<bool> verifyOtp(
      String email, String otp, String purpose) async {
    final url = Uri.parse(ConfigURL.verifyOtpURL);
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email, "otp": otp, "purpose": purpose}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Verify OTP error: $e");
      return false;
    }
  }

  static Future<bool> resetPassword(String email, String newPassword) async {
    final url = Uri.parse(ConfigURL.resetPassword);
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "email": email,
          "new_password": newPassword,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Reset Password error: $e");
      return false;
    }
  }

  // static Future<bool> signUpUser(User user) async {
  //   final url = Uri.parse(ConfigURL.signUpURL);
  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {"Content-Type": "application/json"},
  //       body: json.encode({
  //         "first_name": user.firstName,
  //         "last_name": user.lastName,
  //         "email": user.email,
  //         "password": user.password,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       return true;
  //     }
  //     return false;
  //   } catch (e) {
  //     print("Sign up error: $e");
  //     return false;
  //   }
  // }.

  static Future<Map<String, dynamic>?> signUpUser(User user) async {
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
        final data = json.decode(response.body);
        return {
          "user": data["user"],
          "tokens": data["tokens"],
        };
      }
      return null;
    } catch (e) {
      print("Sign up error: $e");
      return null;
    }
  }
}
