import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:thirdeye/screen/onboarding_screen.dart';
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
      debugPrint("Firebase initialized successfully");
    } else {
      debugPrint("Firebase was already initialized");
    }
  } catch (e) {
    debugPrint("Error initializing Firebase: $e");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ThirdEye',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
