// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class GoogleAuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   // Sign in with Google and return Firebase User
//   Future<User?> signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) return null;

//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;

//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       final UserCredential userCredential =
//           await _auth.signInWithCredential(credential);

//       return userCredential.user;
//     } catch (e) {
//       print("GoogleAuthService Error: $e");
//       return null;
//     }
//   }

//   // Get Firebase ID Token
//   Future<String?> getIdToken(User user) async {
//     try {
//       return await user.getIdToken();
//     } catch (e) {
//       print("Error fetching ID token: $e");
//       return null;
//     }
//   }

//   // Sign out user
//   Future<void> signOut() async {
//     await _googleSignIn.signOut();
//     await _auth.signOut();
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Sign in with Google and return Firebase User
  Future<User?> signInWithGoogle({bool forceAccountSelection = false}) async {
    try {
      // if any error happen when sign in then first of all clear cache (last email id selected)
      if (forceAccountSelection) {
        await _googleSignIn.disconnect();
        await _googleSignIn.signOut(); // clears cache
        await _auth.signOut();
      }

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      print("GoogleAuthService Error: $e");
      return null;
    }
  }

  // Get Firebase ID Token
  Future<String?> getIdToken(User user) async {
    try {
      return await user.getIdToken();
    } catch (e) {
      print("Error fetching ID token: $e");
      return null;
    }
  }

  // Extract first/last name from displayName
  Map<String, String?> extractNameParts(User user) {
    final fullName = user.displayName ?? "";
    final parts = fullName.split(" ");
    return {
      "first_name": parts.isNotEmpty ? parts.first : null,
      "last_name": parts.length > 1 ? parts.sublist(1).join(" ") : null,
    };
  }

  // Get profile picture URL
  String? getProfilePic(User user) {
    return user.photoURL;
  }

  // Sign out user
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
