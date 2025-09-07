import 'package:flutter/material.dart';
import 'package:thirdeye/screen/questions/question.dart';
import 'question2_screen.dart';

class Question1Screen extends StatefulWidget {
  const Question1Screen({super.key});

  @override
  State<Question1Screen> createState() => _Question1ScreenState();
}

class _Question1ScreenState extends State<Question1Screen> {
  int? selectedBox; // Track which box user clicked

  @override
  Widget build(BuildContext context) {
    return QuestionScreen(
      columnIndex: 0,
      boxImages: [
        "assets/agna.png",
        "assets/q1-10.jpg",
        "assets/agna.png",
        "assets/agna.png",
        "assets/agna.png",
        "assets/agna.png",
        "assets/agna.png",
        "assets/q1-neg10.jpg",
        "assets/agna.png",
      ],
      questionText: "This is Question 1: Select from 3 boxes",
      boxTips: [
        "Tip for Box 0",
        "Short term happiness is easy to gain reapetable,affordable and survival in deep pai but not to get addict.It can waste time energy.",
        "Tip for Box 2",
        "Tip for Box 3",
        "good choice dont burn your oppotunity for temporary things.",
        "Tip for Box 5",
        "Tip for Box 6",
        "Its okay,Focus your energy in other stuff that has true meaning in your life,To become neutral focus on deep breathing The feeling is just temporary and only 10% your of your total energy",
        "Tip for Box 8",
      ],
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const Question2Screen()),
        );
      },
      onPrevious: () => Navigator.pop(context),
    );
  }
}
