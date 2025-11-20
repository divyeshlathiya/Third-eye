import 'package:flutter/material.dart';
import 'package:thirdeye/notification/notification_service.dart';
import 'package:thirdeye/sharable_widget/snack_bar.dart';

class PermissionRequester {
  static Future<bool> requestNotificationPermission(
      BuildContext context) async {
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

    if (allow == true) {
      try {
        await NotificationService.instance.requestPermission();
        final token = await NotificationService.instance.getToken();
        if (token != null && token.isNotEmpty) {
          debugPrint('FCM token after permission: $token');
        }
        CustomSnackBar.showCustomSnackBar(context, "Notifications enabled",
            backgroundColor: Colors.purple);
      } catch (e) {
        debugPrint('Error requesting notification permission: $e');
        CustomSnackBar.showCustomSnackBar(
            context, "Could not enable notifications.",
            backgroundColor: Colors.purple);
      }
    } else {
      CustomSnackBar.showCustomSnackBar(context, "Notifications skipped.",
          backgroundColor: Colors.purple);
    }

    return allow == true;
  }

  static Future<void> askThenNavigateReplacement(
      BuildContext context, Widget destination) async {
    // request permission (best-effort)
    await requestNotificationPermission(context);

    // navigate regardless of permission choice
    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => destination),
    );
  }
}
