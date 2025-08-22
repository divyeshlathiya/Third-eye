// import 'package:flutter/material.dart';

// for Male

// class WellnessScreen extends StatelessWidget {
//   WellnessScreen({super.key});
//   // Define the number of boxes in each column
//   final List<int> boxCounts = [9, 7, 5, 3];

//   // Generate offset to vertically align each column based on total boxes
//   List<Widget> buildColumn({
//     required BuildContext context,
//     required int columnIndex,
//     required int boxCount,
//     required int maxCount,
//     required Color color,
//   }) {
//     final int topOffset = (maxCount - boxCount) ~/ 2;

//     return List.generate(maxCount, (i) {
//       if (i < topOffset || i >= topOffset + boxCount) {
//         return const SizedBox(height: 34); // Empty space (same size as box + margin)
//       }
//       return Container(
//         width: 30,
//         height: 30,
//         margin: const EdgeInsets.all(2),
//         decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.circular(4),
//         ),
//       );
//     });
//   }

//   void onColumnTap(BuildContext context, int index) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => QuizScreen(columnIndex: index)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     int maxBoxes = boxCounts[0]; // 9

//     final List<Color> colors = [
//       Colors.purple.shade100,
//       Colors.deepPurpleAccent,
//       Colors.deepPurple.shade800,
//       Colors.black87,
//     ];

//     return Scaffold(
//       backgroundColor: Colors.purple.shade50,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: const BackButton(color: Colors.black),
//         title: const Text(
//           'Start Your Wellness Journey',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Column(
//         children: [
//           const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
//             child: Text(
//               'Choose a quiz column below to explore your path to better mental health.',
//               style: TextStyle(fontSize: 14),
//             ),
//           ),
//           Expanded(
//             child: Center(
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(boxCounts.length, (index) {
//                   return GestureDetector(
//                     onTap: () => onColumnTap(context, index),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: buildColumn(
//                         context: context,
//                         columnIndex: index,
//                         boxCount: boxCounts[index],
//                         maxCount: maxBoxes,
//                         color: colors[index],
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.deepPurple,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(24),
//                 ),
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 minimumSize: const Size.fromHeight(50),
//               ),
//               onPressed: () {},
//               child: const Text('Continue', style: TextStyle(fontSize: 16)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class QuizScreen extends StatelessWidget {
//   final int columnIndex;

//   const QuizScreen({super.key, required this.columnIndex});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Quiz for Column ${columnIndex + 1}')),
//       body: Center(
//         child: Text('This is screen for column ${columnIndex + 1}.'),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:thirdeye/screen/choose_img.dart';

class WellnessScreen extends StatelessWidget {
  WellnessScreen({super.key});

  // Box count for each column (left to right)
  final List<int> boxCounts = [3, 5, 7, 9];

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
  void onColumnTap(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(columnIndex: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int maxBoxes = boxCounts.last; // 9
    final screenWidth = MediaQuery.of(context).size.width;

    // Dynamic sizing
    final double boxSize = screenWidth * 0.10; // 10% of width
    final double boxMargin = boxSize * 0.1;

    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Start Your Wellness Journey',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  child: Text(
                    'Choose a quiz column below to explore your path to better mental health.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(boxCounts.length, (index) {
                      return GestureDetector(
                        onTap: () => onColumnTap(context, index),
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
                const SizedBox(
                  height: 30,
                ),
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
                    onPressed: () {},
                    child:
                        const Text('Continue', style: TextStyle(fontSize: 16)),
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

class QuizScreen extends StatelessWidget {
  final int columnIndex;

  const QuizScreen({super.key, required this.columnIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz for Column ${columnIndex + 1}')),
      // body: Center(
      //   child: Text(
      //     'This is screen for column ${columnIndex + 1}.',
      //     style: const TextStyle(fontSize: 20),
      //   ),
      // ),
      body: QuestionScreen(),
    );
  }
}
