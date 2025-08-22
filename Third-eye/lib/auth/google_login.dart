import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:thirdeye/config/urls.dart';

class SignInWithGoogle {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final signInWithGoogleURL = ConfigURL.signWithGoogleURL;

  static Future<User?> signInWithGoogle() async {
    try {
      // Start Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // user canceled

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Get credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Get Firebase ID token
        final idToken = await user.getIdToken();

        // Send to FastAPI backend
        final response = await http.post(
          Uri.parse(signInWithGoogleURL), // your FastAPI URL
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'id_token': idToken}),
        );

        if (response.statusCode == 200) {
          print("Backend verified user: ${response.body}");
        } else {
          print("Backend verification failed: ${response.body}");
        }
      }
      return user;
    } catch (e) {
      print("Error during sign-in: $e");
      return null;
    }
  }

  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    print("User signed out");
  }
}
