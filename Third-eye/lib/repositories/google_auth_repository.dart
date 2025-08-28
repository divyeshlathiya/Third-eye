import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thirdeye/config/urls.dart';
import 'package:thirdeye/services/google_auth_service.dart';
import 'package:thirdeye/utils/storage_helper.dart';

class GoogleAuthRepository {
  final GoogleAuthService _googleAuthService = GoogleAuthService();
  final String signInWithGoogleURL = ConfigURL.signWithGoogleURL;

  GoogleAuthRepository(GoogleAuthService googleAuthService);

  // Main method: handles Google SignIn + backend verification
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      final User? user = await _googleAuthService.signInWithGoogle();
      if (user == null) return null;

      // Get Firebase ID Token
      final idToken = await _googleAuthService.getIdToken(user);
      if (idToken == null) return null;

      // Send to FastAPI backend
      final response = await http.post(
        Uri.parse(signInWithGoogleURL),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id_token': idToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Save access and refresh token
        await StorageHelper.saveToken("access_token", data['access_token']);
        await StorageHelper.saveToken("refresh_token", data['refresh_token']);
        await StorageHelper.saveToken("email", data['email'] ?? "");

        return data;
      } else {
        print("Backend verification failed: ${response.body}");
        return null;
      }
    } catch (e) {
      print("GoogleAuthRepository Error: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleAuthService.signOut();
    await StorageHelper.clearAll();
  }

  Future<bool> tryAutoLogin() async {
    final accessToken = await StorageHelper.getToken("access_token");
    final refreshToken = await StorageHelper.getToken("refresh_token");

    if (accessToken != null) {
      // Access token exists → consider user logged in
      return true;
    } else if (refreshToken != null) {
      // Optionally: call backend to refresh access token
      final response = await http.post(
        Uri.parse(ConfigURL.refreshTokenURL),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await StorageHelper.saveToken("access_token", data['access_token']);
        await StorageHelper.saveToken("refresh_token", data['refresh_token']);
        return true;
      }
    }

    return false; // No valid token → show login
  }
}
