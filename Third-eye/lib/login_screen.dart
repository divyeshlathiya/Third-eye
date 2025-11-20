import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animate_do/animate_do.dart';
import 'package:thirdeye/screen/about_yourself.dart';
import 'package:thirdeye/screen/dashboard/dashboard.dart';
import 'package:thirdeye/screen/loginform.dart';
import 'package:thirdeye/sharable_widget/snack_bar.dart';
import 'package:thirdeye/sharable_widget/index.dart';
import 'package:thirdeye/signupform.dart';
import 'package:thirdeye/services/auth_manager.dart';
import 'package:thirdeye/utils/storage_helper.dart';
import 'package:thirdeye/config/app_theme.dart';
import 'package:thirdeye/notification/permission_requester.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthManager _authManager = AuthManager();

  void _googleLogin() async {
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

    final userData = await _authManager.signInWithGoogle();

    // Hide loader before processing the result
    if (mounted) {
      Navigator.of(context).pop();
    }

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
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (_) => const DashboardScreen()),
        // );
        await PermissionRequester.askThenNavigateReplacement(
            context, const DashboardScreen());
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
                    icon: Image.asset(
                      "assets/google_icon.png", // Path to your Google icon
                      height: 24,
                      width: 24,
                    ), // Use a valid icon or replace with an Image.asset for Google logo
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
