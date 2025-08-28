import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thirdeye/repositories/google_auth_repository.dart';
import 'package:thirdeye/screen/dashboard/dashboard.dart';
import 'package:thirdeye/loginform.dart';
import 'package:thirdeye/services/google_auth_service.dart';
import 'package:thirdeye/sharable_widget/snack_bar.dart';
import 'package:thirdeye/signupform.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // void _googleLogin() async {
  //   final user = await SignInWithGoogle.signInWithGoogle();
  //   if (!mounted) return;
  //   if (user != null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Welcome ${user.displayName}")),
  //     );

  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => DashboardScreen()),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Google Sign-In failed")),
  //     );
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  void _checkAutoLogin() async {
    final repo = GoogleAuthRepository(GoogleAuthService());

    bool isLoggedIn = await repo.tryAutoLogin();
    if (isLoggedIn) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    }
  }

  void _googleLogin() async {
    final repo = GoogleAuthRepository(GoogleAuthService());

    final userData = await repo.signInWithGoogle();
    if (!mounted) return;

    if (userData != null) {
      CustomSnackBar.showCustomSnackBar(context, "Welcome ${userData['name']}",
          backgroundColor: Colors.purple);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    } else {
      CustomSnackBar.showCustomSnackBar(context, "Google Sign-In failed",
          backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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

          // ✅ Centered illustration and buttons
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

              // ✅ Signup & Login Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    // Signup Button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Signupform(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.black),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "Signup",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Login Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Loginform(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF362491), // Purple shade
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _googleLogin,
                    icon: Image.asset(
                      "assets/google_icon.png",
                      height: 20,
                      width: 20,
                    ),
                    label: const Text(
                      "Login with Google",
                      style: TextStyle(color: Colors.black),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }
}
