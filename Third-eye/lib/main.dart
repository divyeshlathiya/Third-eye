import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thirdeye/login_screen.dart';
import 'package:thirdeye/screen/about_yourself.dart';

void main() {
  runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: OnboardingScreen()),
  );
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  final onboardingPages = [
    OnboardingPage(
      illustrationPath: 'assets/illustration1.svg',
      title: 'This is the title of the onboarding',
      subtitle:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit ut aliquam, purus sit amet luctus venenatis',
    ),
    OnboardingPage(
      illustrationPath: 'assets/illustration2.svg',
      title: 'Stay Organized and Focused',
      subtitle: 'Keep track of your tasks and projects with ease.',
    ),
    OnboardingPage(
      illustrationPath: 'assets/illustration3.svg',
      title: 'Achieve Your Goals Faster',
      subtitle: 'Let us help you stay on top of your game.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ✅ Fixed background SVG at top
          Positioned(
            top: 70,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/background.svg',
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
          ),

          // ✅ Onboarding Page Content
          PageView.builder(
            controller: controller,
            itemCount: onboardingPages.length,
            itemBuilder: (context, index) {
              final page = onboardingPages[index];
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 90),
                      SvgPicture.asset(
                        page.illustrationPath,
                        height: 300,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 40),
                      Text(
                        page.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        page.subtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomSheet: Container(
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      // builder: (context) => const LoginScreen(),
                      builder: (context) => const AboutYourSelfScreen(),
                    ));
              },
              child: const Text("Skip"),
            ),
            SmoothPageIndicator(
              controller: controller,
              count: onboardingPages.length,
              effect: const WormEffect(
                dotHeight: 10,
                dotWidth: 10,
                activeDotColor: Color(0xFF362491),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.page!.toInt() < onboardingPages.length - 1) {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                backgroundColor: const Color(0xFF362491),
              ),
              child: const Text(
                "Next",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage {
  final String illustrationPath;
  final String title;
  final String subtitle;

  OnboardingPage({
    required this.illustrationPath,
    required this.title,
    required this.subtitle,
  });
}
