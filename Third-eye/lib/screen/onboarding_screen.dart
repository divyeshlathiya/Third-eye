import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:animate_do/animate_do.dart';
import 'package:thirdeye/login_screen.dart';
import 'package:thirdeye/utils/storage_helper.dart';
import 'package:thirdeye/config/app_theme.dart';
import 'package:thirdeye/sharable_widget/enhanced_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.page != null) {
        setState(() {
          currentPage = controller.page!.round();
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  final onboardingPages = [
    OnboardingPage(
      illustrationPath: 'assets/illustration1.svg',
      title: 'Discover Your Wellness Journey',
      subtitle:
          'Take our comprehensive assessment to understand your mental health and wellbeing patterns.',
    ),
    OnboardingPage(
      illustrationPath: 'assets/illustration2.svg',
      title: 'Get Personalized Insights',
      subtitle:
          'Receive detailed analysis and recommendations tailored to your unique profile.',
    ),
    OnboardingPage(
      illustrationPath: 'assets/illustration3.svg',
      title: 'Track Your Progress',
      subtitle:
          'Monitor your mental health journey with our intuitive tracking and reporting features.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
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
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        page.subtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black54,
                          height: 1.5,
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

      // ✅ Modern Bottom Navigation
      bottomSheet: Container(
        height: 120,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: const Text(
                "Skip",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
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
            FadeInUp(
              duration: AppTheme.animationMedium,
              delay: const Duration(milliseconds: 400),
              child: SizedBox(
                width: 130, // ✅ Fixes invisible button issue
                child: PrimaryButton(
                  text:
                    currentPage < onboardingPages.length - 1
                        ? "Next"
                        : "Get Started",
              
                  onPressed: () async {
                    if (currentPage < onboardingPages.length - 1) {
                      controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      await PrefsHelper.setOnboardingSeen();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    }
                  },
                ),
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
