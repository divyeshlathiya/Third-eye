import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:thirdeye/screen/choose_img.dart';
import 'package:thirdeye/screen/onboarding_screen.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
    ),
  );
}
