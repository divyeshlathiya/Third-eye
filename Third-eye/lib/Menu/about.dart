import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "About Us",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsetsGeometry.all(16.0),
        child: Column(
          children: [
            Text(
                "THIRD EYE: Emotion Tracker is an initiative envisioned by Dr. Himanshu Rathwa, an Orthopaedic Surgeon based in Chhota Udepur, Gujarat, who believes that true healing begins with self-awareness. Inspired by his vision, DS Developers designed and developed this mobile application to help individuals build emotional clarity through consistency and reflection."),
            SizedBox(
              height: 20,
            ),
            Text(
                "The app encourages users to engage in a short, four-question daily emotional self-assessment. Each response contributes to a personal emotional score that helps users track their emotional patterns, visualize progress through graphical insights, and enhance their emotional balance over time. Upon maintaining a 21-day consistency streak, users are rewarded with a Certificate of Self-Awareness, symbolizing their commitment to mindfulness and emotional discipline."),
            SizedBox(
              height: 20,
            ),
            Text(
                "THIRD EYE: Emotion Tracker aims to bridge the gap between technology and wellness by offering an innovative yet simple way for individuals to pause, reflect, and reconnect with their emotions. Our mission is to make emotional wellness measurable, accessible, and rewarding, while our vision is to help individuals cultivate a habit of introspection that leads to a more mindful and emotionally balanced life. For feedback or support, please contact thirdeye.support@gmail.com. © 2025 THIRD EYE. All Rights Reserved."),
          ],
        ),
      ),
    );
  }
}
