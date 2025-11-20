// verified_screen.dart (only the relevant part changed)
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animate_do/animate_do.dart';
import 'package:thirdeye/screen/dashboard/dashboard.dart';
import 'package:thirdeye/sharable_widget/index.dart';
import 'package:thirdeye/config/app_theme.dart';
import 'package:thirdeye/notification/notification_service.dart'; // import

class VerifiedScreen extends StatelessWidget {
  const VerifiedScreen({super.key});

  Future<void> _askAndProceed(BuildContext context) async {
    // Show a short rationale dialog to explain why notifications are useful
    final allow = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        title: const Text('Enable Notifications?'),
        content: const Text(
          'Enable notifications to receive important updates and reminders.\n\n'
          'You can change this later in app settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Skip'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Allow'),
          ),
        ],
      ),
    );

    // If user chose to allow (true) -> request permission. If user skipped -> proceed.
    if (allow == true) {
      try {
        await NotificationService.instance.requestPermission();
        // try to fetch token if authorized (best-effort)
        final token = await NotificationService.instance.getToken();
        if (token != null && token.isNotEmpty) {
          debugPrint('FCM token after permission: $token');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notifications enabled')),
        );
      } catch (e) {
        debugPrint('Error requesting notification permission: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not enable notifications.')),
        );
      }
    } else {
      // user skipped explicitly
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notifications skipped.')),
      );
    }

    // Navigate to Dashboard anyway
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DashboardScreen()),
    );
  }

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
                    icon: const Icon(Icons.rocket_launch, color: Colors.white),
                    onPressed: () => _askAndProceed(context),
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
