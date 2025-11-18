import 'package:thirdeye/models/User.dart';
import '../services/sign_up_service.dart';
import '../../utils/storage_helper.dart';

class SignUpRepository {
  Future<Map<String, dynamic>> sendOtp(String email, String purpose) async {
    return await SignUpService.sendOtp(email, purpose);
  }

  Future<Map<String, dynamic>> verifyOtp(String email, String otp, String purpose) async {
    return await SignUpService.verifyOtp(email, otp, purpose);
  }

  Future<Map<String, dynamic>> resetPassword(String email, String newPassword) async {
    return await SignUpService.resetPassword(email, newPassword);
  }

  Future<Map<String, dynamic>> registerUser(User user) async {
    final result = await SignUpService.signUpUser(user);
    
    if (result["success"] == true && result["user"] != null) {
      final tokens = result["tokens"];
      final userData = result["user"];

      // Save to storage
      await StorageHelper.saveToken('first_name', userData["first_name"]);
      await StorageHelper.saveToken('access_token', tokens["access_token"]);
      await StorageHelper.saveToken('refresh_token', tokens["refresh_token"]);

      return {
        "success": true,
        "user": userData,
        "tokens": tokens,
        "message": result["message"]
      };
    }
    
    return {
      "success": false,
      "message": result["message"] ?? "Registration failed"
    };
  }
}