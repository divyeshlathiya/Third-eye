import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:thirdeye/screen/scoreboard_screen.dart';
import 'package:thirdeye/sharable_widget/index.dart';
import 'package:thirdeye/config/app_theme.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  final String userName;
  final int day;

  const ResultScreen({
    super.key,
    required this.score,
    required this.userName,
    required this.day,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Icon with Animation
              FadeInDown(
                duration: AppTheme.animationSlow,
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.primaryVariant,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppTheme.radiusXXL),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.star,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingXXL),

              // Title
              FadeInUp(
                duration: AppTheme.animationMedium,
                delay: const Duration(milliseconds: 200),
                child: Text(
                  "Today's Score",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),

              const SizedBox(height: AppTheme.spacingL),

              // Score with Animation
              FadeInUp(
                duration: AppTheme.animationMedium,
                delay: const Duration(milliseconds: 400),
                child: Text(
                  "${widget.score}",
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 64,
                      ),
                ),
              ),

              const SizedBox(height: AppTheme.spacingL),

              // Congrats text
              FadeInUp(
                duration: AppTheme.animationMedium,
                delay: const Duration(milliseconds: 600),
                child: Text(
                  "Congratulations!\nGreat Job ${widget.userName}! You have done well",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textSecondary,
                        height: 1.4,
                      ),
                ),
              ),

              const SizedBox(height: AppTheme.spacingXL),

              // Day + reward badge
              FadeInUp(
                duration: AppTheme.animationMedium,
                delay: const Duration(milliseconds: 800),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingL,
                    vertical: AppTheme.spacingM,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusXXL),
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingM,
                          vertical: AppTheme.spacingS,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusXXL),
                        ),
                        child: Text(
                          "Day ${widget.day}",
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingM),
                      Icon(
                        Icons.monetization_on,
                        size: 20,
                        color: AppTheme.secondaryColor,
                      ),
                      const SizedBox(width: AppTheme.spacingS),
                      Text(
                        "${widget.score} Points",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppTheme.spacingXXL),

              // Next Button
              FadeInUp(
                duration: AppTheme.animationMedium,
                delay: const Duration(milliseconds: 1000),
                child: PrimaryButton(
                  text: "View Scoreboard",
                  icon: Icons.leaderboard,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScoreBoardScreen(),
                      ),
                    );
                  },
                  isFullWidth: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
