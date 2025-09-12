import 'package:flutter_dotenv/flutter_dotenv.dart';

class ConfigURL {
  // static String get base => "http://192.168.1.34:8000/api";
  static String get base => dotenv.env["BASE_URL"] ?? "";
  static String get loginURL => "$base/auth/login";
  static String get signUpURL => "$base/auth/register";
  static String get sendOtpURL => "$base/auth/send-otp";
  static String get verifyOtpURL => "$base/auth/verify-otp";
  static String get signWithGoogleURL => "$base/auth/google-sign-in";
  static String get refreshTokenURL => "$base/auth/refreshToken";
  static String get fetchProfile => "$base/users/me";
  static String get updateProfile => "$base/users/me/profile";
  static String get updateDOBGender => "$base/users/me/profile/dob-gender";
  static String get resetPassword => "$base/auth/forgot-password/reset";
  static String get updatescore => "$base/quiz/add-score";
  static String get getscore => "$base/quiz/my-scores";
}
