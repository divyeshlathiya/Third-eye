import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:thirdeye/screen/questions/question1_screen.dart';
import 'package:thirdeye/screen/questions/question2_screen.dart';
import 'package:thirdeye/screen/questions/question3_screen.dart';
import 'package:thirdeye/screen/questions/question4_screen.dart';
import 'package:thirdeye/config/app_theme.dart';

class WellnessScreen extends StatefulWidget {
  final bool isMale;
  const WellnessScreen({super.key, required this.isMale});

  @override
  State<WellnessScreen> createState() => _WellnessScreenState();
}

class _WellnessScreenState extends State<WellnessScreen> {
  // Box count for each column (left to right)
  late List<int> boxCounts;

  // Colors for each column
  final List<Color> colors = [
    Colors.black87,
    Colors.deepPurple.shade800,
    Colors.deepPurpleAccent,
    Colors.purple.shade100,
  ];

  // Builds a column of boxes with vertical centering
  List<Widget> buildColumn({
    required int boxCount,
    required int maxCount,
    required Color color,
    required double boxSize,
    required double boxMargin,
  }) {
    final int topOffset = (maxCount - boxCount) ~/ 2;

    return List.generate(maxCount, (i) {
      if (i < topOffset || i >= topOffset + boxCount) {
        return SizedBox(height: boxSize + 2 * boxMargin);
      }
      return BlinkingBox(
        color: color,
        boxSize: boxSize,
        margin: boxMargin,
      );
    });
  }

  // Handle tap
  void onColumnTap(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Question1Screen(isMale: widget.isMale)),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Question2Screen(isMale: widget.isMale)),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Question3Screen(isMale: widget.isMale)),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Question4Screen(isMale: widget.isMale)),
        );
        break;
      default:
        break;
    }
  }

  void initState() {
    super.initState();

    // ✅ Choose boxCounts based on condition
    if (widget.isMale) {
      boxCounts = [3, 5, 7, 9]; // Male
    } else {
      boxCounts = [9, 7, 5, 3]; // Female (or default)
    }
  }

  @override
  Widget build(BuildContext context) {
    final int maxBoxes = boxCounts.reduce((a, b) => a > b ? a : b); // 9
    final screenWidth = MediaQuery.of(context).size.width;

    // Dynamic sizing
    final double boxSize = screenWidth * 0.10; // 10% of width
    final double boxMargin = boxSize * 0.1;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Start Your Wellness Journey',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FadeInDown(
                  duration: AppTheme.animationMedium,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingL,
                      vertical: AppTheme.spacingM,
                    ),
                    child: Text(
                      'Choose a quiz column below to explore your path to better mental health.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(boxCounts.length, (index) {
                      return GestureDetector(
                        onTap: () => onColumnTap(index),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: buildColumn(
                            boxCount: boxCounts[index],
                            maxCount: maxBoxes,
                            color: colors[index],
                            boxSize: boxSize,
                            boxMargin: boxMargin,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => Question1Screen(isMale: widget.isMale),));
                    },
                    child: const Text(
                      'Continue',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BlinkingBox extends StatefulWidget {
  final Color color;
  final double boxSize;
  final double margin;

  const BlinkingBox({
    super.key,
    required this.color,
    required this.boxSize,
    required this.margin,
  });

  @override
  State<BlinkingBox> createState() => _BlinkingBoxState();
}

class _BlinkingBoxState extends State<BlinkingBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 1, end: 0.2).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.boxSize,
      height: widget.boxSize,
      margin: EdgeInsets.all(widget.margin),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(widget.boxSize * 0.15),
      ),
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Text(
          "?",
          style: TextStyle(
            color: Colors.deepPurple,
            fontSize: widget.boxSize * 0.6,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
