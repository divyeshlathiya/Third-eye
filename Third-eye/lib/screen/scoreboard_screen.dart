import 'package:flutter/material.dart';
import 'package:thirdeye/screen/tips_screen.dart';
import 'package:thirdeye/sharable_widget/global_data.dart';

class ScoreBoardScreen extends StatefulWidget {
  const ScoreBoardScreen({super.key});

  @override
  State<ScoreBoardScreen> createState() => _ScoreBoardScreenState();
}

class _ScoreBoardScreenState extends State<ScoreBoardScreen> {
  // Column heights (number of boxes)
  final List<int> boxCounts = [3, 5, 7, 9, 7, 5, 3];

  // Column width ratios (instead of fixed px)
  final List<int> boxWidthRatios = [3, 5, 7, 9, 7, 5, 3];

  // Fetch scores from global map
  List<int> get quizScores =>
      List.generate(4, (i) => quizscore[i] ?? 0); // Q1–Q4

  // Generate score labels for a column
  List<int> getColumnScores(int boxCount) {
    int step = 10;
    int maxScore = (boxCount ~/ 2) * step;
    List<int> values = [];
    for (int i = maxScore; i >= -maxScore; i -= step) {
      values.add(i);
    }
    return values;
  }

  // Decide color based on achieved score and box value
  Color getBoxColor(int value, int achievedScore) {
    if (value == 0) return Colors.white; // center zero

    if (achievedScore > 0 && value > 0 && value <= achievedScore) {
      return const Color.fromRGBO(107, 82, 255, 1); // positive shade
    }

    if (achievedScore < 0 && value < 0 && value >= achievedScore) {
      return const Color.fromRGBO(17, 0, 104, 1); // negative shade
    }

    return const Color.fromRGBO(190, 179, 255, 1); // neutral
  }

  @override
  Widget build(BuildContext context) {
    final int maxBoxes = boxCounts[3]; // tallest column
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // normalize column widths based on ratios
    final int ratioSum = boxWidthRatios.reduce((a, b) => a + b);
    final double availableWidth = screenWidth * 0.9; // keep some margin

    // Build all 7 columns (replica for last 3)
    final List<int> allScores = [
      ...quizScores,
      quizScores[2],
      quizScores[1],
      quizScores[0],
    ];

    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Score Board',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.02),

            // Grid
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(boxCounts.length, (colIndex) {
                    final boxCount = boxCounts[colIndex];
                    final scores = getColumnScores(boxCount);
                    final achievedScore = allScores[colIndex];

                    // responsive width/height
                    final double boxWidth =
                        availableWidth * boxWidthRatios[colIndex] / ratioSum;
                    final double boxHeight = screenHeight * 0.05;

                    final int topOffset = (maxBoxes - boxCount) ~/ 2;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(maxBoxes, (row) {
                        if (row < topOffset || row >= topOffset + boxCount) {
                          return SizedBox(width: boxWidth, height: boxHeight);
                        }

                        int value = scores[row - topOffset];
                        Color boxColor = getBoxColor(value, achievedScore);

                        return Container(
                          width: boxWidth,
                          height: boxHeight,
                          margin: EdgeInsets.all(screenWidth * 0.005),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: boxColor,
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(color: Colors.deepPurple.shade200),
                          ),
                          child: value == 0
                              ? Text(
                                  "0",
                                  style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontSize: boxHeight * 0.4,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : (value == achievedScore
                                  ? Text(
                                      value.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: boxHeight * 0.4,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : const SizedBox()),
                        );
                      }),
                    );
                  }),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                "assets/Card2.jpg",
                fit: BoxFit.fitWidth,
                width: double.infinity,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(17, 0, 104, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                  minimumSize: Size.fromHeight(screenHeight * 0.07),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TipsScreen(),
                    ),
                  );
                },
                child: Text(
                  'View Tips',
                  style: TextStyle(
                      fontSize: screenWidth * 0.045, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
