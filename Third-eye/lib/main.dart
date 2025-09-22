import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:thirdeye/screen/splash_screen.dart';
import 'package:thirdeye/utils/storage_helper.dart';
import 'package:thirdeye/config/app_theme.dart';
import 'firebase_options.dart'; // if using generated file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env"); // load .env file

  // Initialize Firebase only if not already initialized
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      debugPrint("Firebase initialized.");
    } else {
      Firebase.app();
      debugPrint("Firebase was already initialized.");
    }
  } catch (e) {
    debugPrint("Error initializing Firebase: $e");
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
