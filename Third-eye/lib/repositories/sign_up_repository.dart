import 'package:thirdeye/models/User.dart';

import '../services/sign_up_service.dart';
import '../../utils/storage_helper.dart';

class SignUpRepository {
  Future<bool> sendOtp(String email) async {
    return await SignUpService.sendOtp(email);
  }

  Future<bool> verifyOtp(String email, String otp) async {
    return await SignUpService.verifyOtp(email, otp);
  }

  Future<bool> registerUser(User user) async {
    final success = await SignUpService.signUpUser(user);
    if (success) {
      await StorageHelper.saveData('email', user.email);
    }
    return success;
  }
}
