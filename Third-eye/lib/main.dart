import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:thirdeye/screen/splash_screen.dart';
import 'package:thirdeye/utils/storage_helper.dart';
import 'package:thirdeye/config/app_theme.dart';
import 'firebase_options.dart'; 
import 'notification/firebase_background_handler.dart';
import 'notification/notification_service.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  // Initialize Firebase only if not already initialized
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      Firebase.app();
      debugPrint("Firebase was already initialized.");
    }
  } catch (e) {
    debugPrint("Error initializing Firebase: $e");
  }

  // Register background message handler BEFORE runApp  
  // firebase_background_handler.dart must contain a top-level function:
  // Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async { ... }
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Initialize your local notification helper (this also sets up onMessage listeners)
  // Ensure NotificationService.init() does not depend on BuildContext.
  try {
    await NotificationService.instance.init();
    // Optional: get token and print so you can test from console
    final token = await NotificationService.instance.getToken();
    debugPrint(
        '---------------------- FCM token: $token --------------------------');
  } catch (e) {
    debugPrint('NotificationService init error: $e');
  }

  final hasSeenOnboarding = await PrefsHelper.hasSeenOnboarding();

  runApp(MyApp(
    hasSeenOnboarding: hasSeenOnboarding,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.hasSeenOnboarding});
  final bool hasSeenOnboarding;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ThirdEye',
      theme: AppTheme.lightTheme,
      home: SplashScreen(
        hasSeenOnboarding: hasSeenOnboarding,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}