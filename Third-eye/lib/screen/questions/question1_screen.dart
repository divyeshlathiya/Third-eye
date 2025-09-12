import 'package:flutter/material.dart';
import 'package:thirdeye/screen/questions/question.dart';
import 'question2_screen.dart';

class Question1Screen extends StatefulWidget {
  final bool isMale; // ✅ Add gender flag

  const Question1Screen({super.key, required this.isMale});

  @override
  State<Question1Screen> createState() => _Question1ScreenState();
}

class _Question1ScreenState extends State<Question1Screen> {
  int? selectedBox;

  @override
  Widget build(BuildContext context) {
    // ✅ Male data
    final maleImages = [
      "assets/agna.png",
      "assets/q1-10.jpg",
      "assets/agna.png",
      "assets/agna.png",
      "assets/agna.png",
      "assets/agna.png",
      "assets/agna.png",
      "assets/q1-neg10.jpg",
      "assets/agna.png",
    ];

    final maleTips = [
      "Tip for Box 0",
      "Short term happiness is easy to gain reapetable,affordable and survival in deep pai but not to get addict.It can waste time energy.",
      "Tip for Box 2",
      "Tip for Box 3",
      "good choice dont burn your oppotunity for temporary things.",
      "Tip for Box 5",
      "Tip for Box 6",
      "Its okay,Focus your energy in other stuff that has true meaning in your life,To become neutral focus on deep breathing The feeling is just temporary and only 10% your of your total energy",
      "Tip for Box 8",
    ];

    // ✅ Female data (replace with your own)
    final femaleImages = [
      "assets/agna.png",
      "assets/agna.png",
      "assets/agna.png",
      "assets/agna.png",
      "assets/agna.png",
      "assets/agna.png",
      "assets/agna.png",
      "assets/agna.png",
      "assets/agna.png",
    ];

    final femaleTips = [
      "Tip for Female Box 0",
      "Self-care is important—make time for activities that bring you peace.",
      "Tip for Female Box 2",
      "Tip for Female Box 3",
      "Stay focused on long-term goals, not temporary relief.",
      "Tip for Female Box 5",
      "Tip for Female Box 6",
      "Remember: feelings are temporary, your inner strength is lasting.",
      "Tip for Female Box 8",
    ];

    // ✅ Choose based on gender
    final images = widget.isMale ? maleImages : femaleImages;
    final tips = widget.isMale ? maleTips : femaleTips;

    return QuestionScreen(
      columnIndex: 0,
      boxImages: images,
      questionText: "This is Question 1: Select from 3 boxes",
      boxTips: tips,
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                Question2Screen(isMale: widget.isMale), // ✅ pass forward
          ),
        );
      },
      onPrevious: () => Navigator.pop(context), isMale: widget.isMale,
    );
  }
}