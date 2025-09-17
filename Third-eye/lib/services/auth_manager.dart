import 'dart:async';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:thirdeye/models/User.dart';
import 'package:thirdeye/repositories/auth_repositories.dart';
import 'package:thirdeye/repositories/google_auth_repository.dart';
import 'package:thirdeye/repositories/profile_repositories.dart';
import 'package:thirdeye/repositories/sign_up_repository.dart';
import 'package:thirdeye/utils/storage_helper.dart';

class AuthManager {
  static final AuthManager _instance = AuthManager._internal();
  factory AuthManager() => _instance;
  AuthManager._internal();

  final AuthRepository _authRepo = AuthRepository();
  final GoogleAuthRepository _googleRepo = GoogleAuthRepository();
  final ProfileRepository _profileRepo = ProfileRepository();
  final SignUpRepository _signUpRepo = SignUpRepository();

  Timer? _refreshTimer;

  /// Initialize session on app start
  Future<Map<String, dynamic>?> initSession() async {
    final accessToken = await StorageHelper.getToken('access_token');
    final refreshToken = await StorageHelper.getToken('refresh_token');

    if (accessToken != null && !JwtDecoder.isExpired(accessToken)) {
      _startAutoRefresh(accessToken);
      return await _profileRepo.fetchProfile();
    } else if (refreshToken != null) {
      final refreshed = await _authRepo.refreshAccessToken();
      if (refreshed) {
        final newAccessToken = await StorageHelper.getToken('access_token');
        _startAutoRefresh(newAccessToken!);
        return await _profileRepo.fetchProfile();
      }
    }

    return null; // No valid session, requires login
  }

  /// Login with email/password
  Future<bool> login(String email, String password) async {
    final success = await _authRepo.login(email, password);
    if (success) {
      final accessToken = await _authRepo.getAccessToken();
      if (accessToken != null) _startAutoRefresh(accessToken);
    }
    return success;
  }

  /// Login with Google
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    final data = await _googleRepo.signInWithGoogle();
    if (data != null && data.containsKey('access_token')) {
      _startAutoRefresh(data['access_token']);
    }
    return data;
  }

  /// Sign-up user
  Future<Map<String, dynamic>?> signUpUser(
      Map<String, dynamic> userData) async {
    // Convert map -> User model because repo expects User
    final user = User(
      firstName: userData["firstName"],
      lastName: userData["lastName"],
      email: userData["email"],
      password: userData["password"],
    );

    final result = await _signUpRepo.registerUser(user);
    if (result != null && result["tokens"] != null) {
      _startAutoRefresh(result["tokens"]["access_token"]);
    }
    return result;
  }

  /// Logout
  Future<void> logout() async {
    _refreshTimer?.cancel();
    await _authRepo.logout();
    await _googleRepo.signOut();
  }

  /// Fetch profile safely
  Future<Map<String, dynamic>?> getProfile() async {
    var accessToken = await _authRepo.getAccessToken();

    if (accessToken == null) return null;

    if (JwtDecoder.isExpired(accessToken)) {
      final refreshed = await _authRepo.refreshAccessToken();
      if (!refreshed) return null;
      accessToken = await _authRepo.getAccessToken();
    }

    return await _profileRepo.fetchProfile();
  }

  /// Auto-refresh access token 5 minutes before expiry
  void _startAutoRefresh(String accessToken) {
    _refreshTimer?.cancel();

    final expiryDate = JwtDecoder.getExpirationDate(accessToken);
    final now = DateTime.now();
    final secondsUntilRefresh = expiryDate.difference(now).inSeconds - 300;

    if (secondsUntilRefresh <= 0) return;

    _refreshTimer = Timer(Duration(seconds: secondsUntilRefresh), () async {
      final refreshToken = await StorageHelper.getToken('refresh_token');
      if (refreshToken != null) await _authRepo.refreshAccessToken();
    });
  }
}
