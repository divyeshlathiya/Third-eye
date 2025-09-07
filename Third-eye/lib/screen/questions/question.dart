import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:thirdeye/screen/result_screen.dart';
import 'package:thirdeye/sharable_widget/global_data.dart';

class QuestionScreen extends StatefulWidget {
  final int columnIndex;
  final String questionText;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final List<String> boxImages;
  final List<String>? boxTips;

  const QuestionScreen({
    super.key,
    required this.columnIndex,
    required this.questionText,
    this.onNext,
    this.onPrevious,
    required this.boxImages,
    required this.boxTips,
  });

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final List<int> boxCounts = [3, 5, 7, 9];
  final List<List<int>> boxPoints = [
    [0, 10, 0, 0, 0, 0, 0, -10, 0], // Question 1
    [20, 0, 10, 0, 0, 0, -10, 0, -20], // Question 2
    [30, 20, 10, 0, 0, 0, -10, -20, -30], // Question 3
    [40, 30, 20, 10, 0, -10, -20, -30, -40], // Question 4
  ];

  void _showPreview(BuildContext context, int index) {
    int points = boxPoints[widget.columnIndex][index];
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Scaffold(
            backgroundColor: Colors.black.withOpacity(0.3),
            body: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SvgPicture.asset("assets/agna.svg"),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Score: $points",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _selectBox(int index) {
    setState(() {
      selectedBoxesPerColumn[widget.columnIndex] = index;

      // Reset score and recalc
      totalscore = 0;
      selectedBoxesPerColumn.forEach((qIndex, bIndex) {
        totalscore += boxPoints[qIndex][bIndex];
      });

      // Store tip for this question
      if (widget.boxTips != null && index < widget.boxTips!.length) {
        // Replace tip for current question if already exists
        if (selectedTips.length > widget.columnIndex) {
          selectedTips[widget.columnIndex] = widget.boxTips![index];
        } else {
          // Fill missing indexes with empty strings before adding
          while (selectedTips.length < widget.columnIndex) {
            selectedTips.add("");
          }
          selectedTips.add(widget.boxTips![index]);
        }
      }
    });

    // debugPrint("Selections so far: $selectedBoxesPerColumn");
    // debugPrint("Combined Score so far: $totalscore");
    // debugPrint("Selected Tips so far: $selectedTips");
  }

  bool _isDisabled(int index, int boxCount) {
    if (boxCount == 7) {
      return index == 3 || index == 5;
    } else if (boxCount == 3) {
      return [0, 2, 3, 5, 6, 8].contains(index);
    } else if (boxCount == 5) {
      return [1, 3, 5, 7].contains(index);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final int boxCount = boxCounts[widget.columnIndex];
    final int? selectedBox = selectedBoxesPerColumn[widget.columnIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("Question ${widget.columnIndex + 1}/${boxCounts.length}"),
        leading: widget.onPrevious != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: widget.onPrevious,
              )
            : null,
      ),
      backgroundColor: const Color(0xFFF5F2FD),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Text(
                    widget.questionText,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.08),

                  /// Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      bool isDisabled = _isDisabled(index, boxCount);
                      bool isSelected = selectedBox == index;

                      if (isDisabled) return const SizedBox.shrink();

                      return GestureDetector(
                        onTap: () => _selectBox(index),
                        onLongPress: () => _showPreview(context, index),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? const Color.fromARGB(255, 163, 107, 255)
                                  : Colors.transparent,
                              width: isSelected
                                  ? 3
                                  : 2, // thicker border when selected
                            ),
                            image: DecorationImage(
                              image: AssetImage(widget.boxImages[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 4),
                              margin: const EdgeInsets.all(6),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),

                  /// Info box
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE8FB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "This test is just between you and yourself.\nAnswer honestly. Be mindful.\nYour truth shapes your journey.",
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: selectedBox == null
                          ? null
                          : () {
                              if (widget.columnIndex == boxCounts.length - 1) {
                                // Last question → Navigate to result screen
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ResultScreen(
                                      score: totalscore,
                                      userName:
                                          "Jenny Wilson", // pass dynamic name if available
                                      day:
                                          1, // pass dynamic day if you track it
                                    ),
                                  ),
                                );
                              } else {
                                widget.onNext?.call();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5A2DCE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        widget.columnIndex == boxCounts.length - 1
                            ? "Finish Quiz"
                            : "Next Question",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
