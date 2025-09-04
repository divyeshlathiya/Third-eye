import 'package:thirdeye/services/auth_service.dart';
import 'package:thirdeye/utils/storage_helper.dart';

class AuthRepository {
  Future<bool> login(String email, String password) async {
    final data = await AuthService.login(email, password);

    if (data != null &&
        data.containsKey('access_token') &&
        data.containsKey('refresh_token')) {
      await StorageHelper.saveToken('access_token', data['access_token']);
      await StorageHelper.saveToken('refresh_token', data['refresh_token']);

      if (data.containsKey('first_name')) {
        await StorageHelper.saveToken('first_name', data['first_name']);
      }
      return true;
    }
    return false;
  }

  Future<bool> refreshAccessToken() async {
    final refreshToken = await StorageHelper.getToken('refresh_token');
    if (refreshToken == null) return false;

    final data = await AuthService.refreshToken(refreshToken);
    if (data != null && data.containsKey('access_token')) {
      await StorageHelper.saveToken('access_token', data['access_token']);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await StorageHelper.clearAll();
  }

  Future<String?> getAccessToken() async {
    return await StorageHelper.getToken('access_token');
  }

  Future<Map<String, dynamic>?> fetchProfile() async {
    final accessToken = await getAccessToken();
    if (accessToken == null) return null;

    return await AuthService.getProfile(accessToken);
  }
}
