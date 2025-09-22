// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:thirdeye/repositories/google_auth_repository.dart';
// import 'package:thirdeye/screen/about_yourself.dart';
// import 'package:thirdeye/screen/dashboard/dashboard.dart';
// import 'package:thirdeye/loginform.dart';
// import 'package:thirdeye/sharable_widget/snack_bar.dart';
// import 'package:thirdeye/signupform.dart';
// import 'package:thirdeye/utils/storage_helper.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {

//   @override
//   void initState() {
//     super.initState();
//   }

//   void _googleLogin() async {
//     final repo = GoogleAuthRepository();

//     final userData = await repo.signInWithGoogle();
//     print(userData.toString());

//     if (userData != null) {
//       await StorageHelper.saveToken("first_name", userData['first_name'] ?? "");
//       await StorageHelper.saveToken("access_token", userData["access_token"]);

//       String accessToken = userData["access_token"];
//       final firstName = userData['first_name'] ?? "User";

//       if (!mounted) return;

//       // Check if dob or gender is null
//       final dob = userData['dob'];
//       final gender = userData['gender'];

//       if (dob == null || gender == null) {
//         // Redirect to AboutYourSelfScreen to fill missing info
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => AboutYourSelfScreen(
//               accessToken: accessToken,
//             ),
//           ),
//         );
//       } else {
//         // Redirect to DashboardScreen
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const DashboardScreen(),
//           ),
//         );
//         CustomSnackBar.showCustomSnackBar(
//           context,
//           "Welcome $firstName",
//           backgroundColor: Colors.purple,
//         );
//       }
//     } else {
//       CustomSnackBar.showCustomSnackBar(
//         context,
//         "Google Sign-In failed",
//         backgroundColor: Colors.red,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           Positioned(
//             top: 70,
//             left: 0,
//             right: 0,
//             child: SvgPicture.asset(
//               "assets/background_wave.svg",
//               fit: BoxFit.cover,
//               width: MediaQuery.of(context).size.width,
//             ),
//           ),

//           // ✅ Centered illustration and buttonscls

//           Column(
//             children: [
//               const SizedBox(height: 150),
//               Center(
//                 child: SvgPicture.asset(
//                   "assets/illustration.svg",
//                   height: 250,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               const Spacer(),

//               // ✅ Signup & Login Buttons
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 30),
//                 child: Row(
//                   children: [
//                     // Signup Button
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const Signupform(),
//                             ),
//                           );
//                         },
//                         style: OutlinedButton.styleFrom(
//                           side: const BorderSide(color: Colors.black),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30)),
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                         ),
//                         child: const Text(
//                           "Signup",
//                           style: TextStyle(color: Colors.black),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     // Login Button
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const Loginform(),
//                             ),
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color(0xFF362491), // Purple shade
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30)),
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                         ),
//                         child: const Text(
//                           "Login",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 20),

//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 30),
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: OutlinedButton.icon(
//                     onPressed: _googleLogin,
//                     icon: Image.asset(
//                       "assets/google_icon.png",
//                       height: 20,
//                       width: 20,
//                     ),
//                     label: const Text(
//                       "Login with Google",
//                       style: TextStyle(color: Colors.black),
//                     ),
//                     style: OutlinedButton.styleFrom(
//                       side: const BorderSide(color: Colors.black12),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30)),
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 40),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animate_do/animate_do.dart';
import 'package:thirdeye/screen/about_yourself.dart';
import 'package:thirdeye/screen/dashboard/dashboard.dart';
import 'package:thirdeye/loginform.dart';
import 'package:thirdeye/sharable_widget/snack_bar.dart';
import 'package:thirdeye/sharable_widget/index.dart';
import 'package:thirdeye/signupform.dart';
import 'package:thirdeye/services/auth_manager.dart';
import 'package:thirdeye/utils/storage_helper.dart';
import 'package:thirdeye/config/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthManager _authManager = AuthManager();

  void _googleLogin() async {
    final userData = await _authManager.signInWithGoogle();

    if (userData != null) {
      final accessToken = userData["access_token"];
      final firstName = userData['first_name'] ?? "User";

      await StorageHelper.saveToken("access_token", accessToken);

      if (!mounted) return;

      final dob = userData['dob'];
      final gender = userData['gender'];

      if (dob == null || gender == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => AboutYourSelfScreen(accessToken: accessToken),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
        CustomSnackBar.showCustomSnackBar(
          context,
          "Welcome $firstName",
          backgroundColor: Colors.purple,
        );
      }
    } else {
      CustomSnackBar.showCustomSnackBar(
        context,
        "Google Sign-In failed",
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 70,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              "assets/background_wave.svg",
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 150),
              Center(
                child: SvgPicture.asset(
                  "assets/illustration.svg",
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ),
              const Spacer(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppTheme.spacingXL),
                child: Row(
                  children: [
                    Expanded(
                      child: FadeInLeft(
                        duration: AppTheme.animationMedium,
                        delay: const Duration(milliseconds: 200),
                        child: OutlineButton(
                          text: "Signup",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const Signupform()),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    Expanded(
                      child: FadeInRight(
                        duration: AppTheme.animationMedium,
                        delay: const Duration(milliseconds: 400),
                        child: OutlineButton(
                          text: "Login",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const Loginform()),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingL),
              FadeInUp(
                duration: AppTheme.animationMedium,
                delay: const Duration(milliseconds: 600),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingXL),
                  child: OutlineButton(
                    text: "Login with Google",
                    icon: Icons.login,
                    onPressed: _googleLogin,
                    isFullWidth: true,
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingXL),
            ],
          ),
        ],
      ),
    );
  }
}
