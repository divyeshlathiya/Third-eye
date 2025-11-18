import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thirdeye/config/urls.dart';
import 'package:thirdeye/models/User.dart';

class SignUpService {
  static Future<Map<String, dynamic>> sendOtp(
      String email, String purpose) async {
    final url = Uri.parse(ConfigURL.sendOtpURL);
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email, "purpose": purpose}),
      );

      if (response.statusCode == 200) {
        return {"success": true, "message": "OTP sent successfully"};
      } else if (response.statusCode == 400) {
        final data = json.decode(response.body);
        return {
          "success": false,
          "message": data["message"] ?? "User already registered"
        };
      } else {
        return {"success": false, "message": "Failed to send OTP"};
      }
    } catch (e) {
      print("Send OTP error: $e");
      return {"success": false, "message": "Network error occurred"};
    }
  }

  static Future<Map<String, dynamic>> verifyOtp(
      String email, String otp, String purpose) async {
    final url = Uri.parse(ConfigURL.verifyOtpURL);
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email, "otp": otp, "purpose": purpose}),
      );

      if (response.statusCode == 200) {
        return {"success": true, "message": "OTP verified successfully"};
      } else {
        final data = json.decode(response.body);
        return {"success": false, "message": data["message"] ?? "Invalid OTP"};
      }
    } catch (e) {
      print("Verify OTP error: $e");
      return {"success": false, "message": "Network error occurred"};
    }
  }

  static Future<Map<String, dynamic>> resetPassword(
      String email, String newPassword) async {
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

      if (response.statusCode == 200) {
        return {"success": true, "message": "Password reset successfully"};
      } else {
        final data = json.decode(response.body);
        return {
          "success": false,
          "message": data["message"] ?? "Failed to reset password"
        };
      }
    } catch (e) {
      print("Reset Password error: $e");
      return {"success": false, "message": "Network error occurred"};
    }
  }

  static Future<Map<String, dynamic>> signUpUser(User user) async {
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
          "success": true,
          "user": data["user"],
          "tokens": data["tokens"],
          "message": "Registration successful"
        };
      } else if (response.statusCode == 404 || response.statusCode == 400) {
        final data = json.decode(response.body);
        return {
          "success": false,
          "message": data["message"] ?? "User already exists with this email"
        };
      } else {
        return {
          "success": false,
          "message": "Registration failed. Please try again."
        };
      }
    } catch (e) {
      print("Sign up error: $e");
      return {
        "success": false,
        "message": "Network error occurred. Please check your connection."
      };
    }
  }
}
