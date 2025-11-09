import 'package:flutter/material.dart';
import 'package:thirdeye/config/app_theme.dart';
import 'package:thirdeye/sharable_widget/back_btn.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const MyBackButton(),
        title: const Text(
          "Privacy Policy",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final baseFontSize = isTablet ? 18.0 : 15.5;
          final lineSpacing = isTablet ? 1.7 : 1.5;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingL,
              vertical: AppTheme.spacingM,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700), // limits width for large screens
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      '''
At THIRD EYE, we respect your privacy and are fully committed to protecting your personal information. This Privacy Policy describes how we collect, use, and safeguard data in compliance with Google Play, Apple App Store, and global data protection laws such as GDPR and CCPA.

When you use THIRD EYE, we collect limited personal information such as your name, email address, and authentication ID if you sign in using Google or Email. The app also records your daily emotional responses and certain non-identifiable device data for analytics and performance optimization.

We collect this information solely to calculate your emotional score, generate personalized insights, and deliver the 21-day self-awareness certificate. Your data helps us improve user experience and ensure accurate reflection tracking.

All user information is stored securely in Google Firebase, which uses encryption and access controls compliant with international security standards. DS Developers does not sell, rent, or share personal information with any third party. However, anonymized analytics data may be used internally to improve performance and app reliability.

The app integrates trusted third-party services like Firebase Analytics and Google Authentication, each governed by their respective privacy policies. Users can request account deletion or data removal at any time by contacting:
thirdeye.support@gmail.com

THIRD EYE is designed for individuals aged 13 and above. We do not knowingly collect or store data from minors under the age of 13.

This Privacy Policy may be updated periodically, and users will be notified of any significant revisions via in-app alerts or email. By continuing to use THIRD EYE, you consent to the collection and use of your information as outlined in this document.

For privacy-related inquiries or concerns, please contact:
thirdeye.support@gmail.com

© 2025 THIRD EYE. All Rights Reserved.
''',
                      style: TextStyle(
                        fontSize: baseFontSize,
                        height: lineSpacing,
                        color: Colors.black87,
                        wordSpacing: 0.5,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
