import 'package:thirdeye/services/profile_service.dart';
import 'package:thirdeye/utils/storage_helper.dart';

class ProfileRepository {
  Future<Map<String, dynamic>?> fetchProfile() async {
    final accessToken = await StorageHelper.getToken('access_token');
    if (accessToken == null) return null;

    return await ProfileService.fetchProfile(accessToken);
  }

  Future<Map<String, dynamic>?> updateProfile(
      Map<String, dynamic> profileData) async {
    final accessToken = await StorageHelper.getToken('access_token');
    if (accessToken == null) return null;

    return await ProfileService.updateProfile(accessToken, profileData);
  }
}
