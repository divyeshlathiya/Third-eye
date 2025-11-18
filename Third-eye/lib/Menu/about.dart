import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    final baseFontSize = isTablet ? 18.0 : 15.5;
    final lineHeight = isTablet ? 1.7 : 1.5;
    final textColor = isDark ? Colors.white70 : Colors.black87;
    final scaffoldBg = isDark ? Colors.black : Colors.white;

    // Desired SystemUiOverlayStyle based on theme so time/battery are visible.
    final overlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // keep translucent look
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: scaffoldBg,
      systemNavigationBarIconBrightness:
          isDark ? Brightness.light : Brightness.dark,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Scaffold(
        backgroundColor: scaffoldBg,
        // keep appBar transparent but ensure icons contrast via overlayStyle
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          // this also ensures back icon color
          iconTheme: IconThemeData(color: textColor),
          title: Text(
            "About Us",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: isTablet ? 22 : 20,
              color: textColor,
            ),
          ),
          // For extra compatibility with some platforms:
          systemOverlayStyle: overlayStyle,
        ),
        body: SafeArea(
          top: true, // ensure content sits below status bar
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "THIRD EYE: Emotion Tracker is an initiative envisioned by Dr. Himanshu Rathwa, an Orthopaedic Surgeon based in Chhota Udepur, Gujarat, who believes that true healing begins with self-awareness. Inspired by his vision, DS Developers designed and developed this mobile application to help individuals build emotional clarity through consistency and reflection.",
                          style: TextStyle(
                            fontSize: baseFontSize,
                            height: lineHeight,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "The app encourages users to engage in a short, four-question daily emotional self-assessment. Each response contributes to a personal emotional score that helps users track their emotional patterns, visualize progress through graphical insights, and enhance their emotional balance over time. Upon maintaining a 21-day consistency streak, users are rewarded with a Certificate of Self-Awareness, symbolizing their commitment to mindfulness and emotional discipline.",
                          style: TextStyle(
                            fontSize: baseFontSize,
                            height: lineHeight,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SelectableText(
                          "THIRD EYE: Emotion Tracker aims to bridge the gap between technology and wellness by offering an innovative yet simple way for individuals to pause, reflect, and reconnect with their emotions. Our mission is to make emotional wellness measurable, accessible, and rewarding, while our vision is to help individuals cultivate a habit of introspection that leads to a more mindful and emotionally balanced life.\n\nFor feedback or support, please contact:\nthirdeye. developer.thirdeyeemotion@gmail.com\n\n© 2025 THIRD EYE. All Rights Reserved.",
                          style: TextStyle(
                            fontSize: baseFontSize,
                            height: lineHeight,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 36),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
