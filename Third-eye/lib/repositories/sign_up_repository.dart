import 'package:thirdeye/models/User.dart';

import '../services/sign_up_service.dart';
import '../../utils/storage_helper.dart';

class SignUpRepository {
  Future<bool> sendOtp(String email, String purpose) async {
    return await SignUpService.sendOtp(email, purpose);
  }

  Future<bool> verifyOtp(String email, String otp, String purpose) async {
    return await SignUpService.verifyOtp(email, otp, purpose);
  }

  Future<bool> resetPassword(String email, String newPassword) async {
    return await SignUpService.resetPassword(email, newPassword);
  }

  Future<Map<String, dynamic>?> registerUser(User user) async {
    final result = await SignUpService.signUpUser(user);
    if (result != null) {
      final tokens = result["tokens"];
      final userData = result["user"];

      // Save to storage
      await StorageHelper.saveToken('first_name', userData["first_name"]);
      await StorageHelper.saveToken('access_token', tokens["access_token"]);
      await StorageHelper.saveToken('refresh_token', tokens["refresh_token"]);

      return {
        "user": userData,
        "tokens": tokens,
      };
    }
    return null;
  }
}
