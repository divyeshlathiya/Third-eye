import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animate_do/animate_do.dart';
import 'package:thirdeye/screen/dashboard/dashboard.dart';
import 'package:thirdeye/sharable_widget/index.dart';
import 'package:thirdeye/config/app_theme.dart';

class VerifiedScreen extends StatelessWidget {
  const VerifiedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FadeInDown(
                  duration: AppTheme.animationSlow,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: AppTheme.successColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusXXL),
                    ),
                    child: SvgPicture.asset(
                      "assets/verified.svg",
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXL),
                FadeInUp(
                  duration: AppTheme.animationMedium,
                  delay: const Duration(milliseconds: 300),
                  child: Text(
                    "Account Verified!",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingM),
                FadeInUp(
                  duration: AppTheme.animationMedium,
                  delay: const Duration(milliseconds: 500),
                  child: Text(
                    "Let's start creating your account so that you can start using this app.",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXXL),
                FadeInUp(
                  duration: AppTheme.animationMedium,
                  delay: const Duration(milliseconds: 700),
                  child: PrimaryButton(
                    text: "Start Your Journey",
                    icon: const Icon(Icons.rocket_launch,color: Colors.white,),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DashboardScreen(),
                        ),
                      );
                    },
                    isFullWidth: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
