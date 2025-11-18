import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thirdeye/config/urls.dart';
import 'package:thirdeye/services/google_auth_service.dart';
import 'package:thirdeye/utils/storage_helper.dart';

class GoogleAuthRepository {
  final GoogleAuthService _googleAuthService = GoogleAuthService();
  final String signInWithGoogleURL = ConfigURL.signWithGoogleURL;

  // GoogleAuthRepository(GoogleAuthService googleAuthService);
  // GoogleAuthRepository(GoogleAuthService googleAuthService);

  // Main method: handles Google SignIn + backend verification
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      final User? user = await _googleAuthService.signInWithGoogle();
      if (user == null) return null;

      // Get Firebase ID Token
      final idToken = await _googleAuthService.getIdToken(user);
      if (idToken == null) return null;

      // Extract profile data
      final nameParts = _googleAuthService.extractNameParts(user);
      final profilePic = _googleAuthService.getProfilePic(user);

      // Build request payload
      final payload = {
        "id_token": idToken,
        "first_name": nameParts["first_name"],
        "last_name": nameParts["last_name"],
        "profile_pic": profilePic,
      };

      // Send to FastAPI backend
      final response = await http.post(
        Uri.parse(signInWithGoogleURL),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Save tokens locally
        await StorageHelper.saveToken("access_token", data['access_token']);
        await StorageHelper.saveToken("refresh_token", data['refresh_token']);
        await StorageHelper.saveToken("email", data['email'] ?? "");
        await StorageHelper.saveToken("profile_pic", data['profile_pic'] ?? "");

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

  // Simple method with loader - call this from your UI
  Future<Map<String, dynamic>?> signInWithGoogleWithLoader(BuildContext context) async {
    // Show loader
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );

    try {
      // Call your existing method
      final result = await signInWithGoogle();

      // Hide loader
      Navigator.of(context).pop();

      return result;
    } catch (e) {
      // Hide loader in case of error too
      Navigator.of(context).pop();
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
      return true; // logged in
    } else if (refreshToken != null) {
      // Optionally refresh access token
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

    return false; // login required
  }
}