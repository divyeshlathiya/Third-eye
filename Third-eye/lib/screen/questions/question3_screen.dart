import 'package:flutter/material.dart';
import 'package:thirdeye/screen/questions/question.dart';
import 'question4_screen.dart';

class Question3Screen extends StatefulWidget {
  const Question3Screen({super.key});

  @override
  State<Question3Screen> createState() => _Question3ScreenState();
}

class _Question3ScreenState extends State<Question3Screen> {
  int? selectedBox; // Track which box user clicked

  @override
  Widget build(BuildContext context) {
    return QuestionScreen(
      columnIndex: 2,
      boxImages: [
        "assets/q4-neg40.jpg",
        "assets/q4-neg40.jpg",
        "assets/q4-neg40.jpg",
        "assets/q4-neg40.jpg",
        "assets/agna.png",
        "assets/q4-neg40.jpg",
        "assets/q4-neg40.jpg",
        "assets/q4-neg40.jpg",
        "assets/q4-neg40.jpg",
      ],
      questionText: "This is Question 3: Select from 7 boxes",
      boxTips: [
        "Achievement in Carrier\n\n Tip- as male career is 2nd most important powerfull emotional layer of achievments in career Keep identifying the exact things that needed to be done for career.",
        "Trying many things to achieve goal.\n\n Tip - doing many things for career keep you good position emotional state. Try to identify the things which is needed to be done and plan for it.When your why you do this will clear,how will u do will become easy.",
        "Thinking for success in career.\n\nTip- only thinking positive for your career can make you happy. Happiness will increase once work for it. U will be happiest when u achieve your goal by doing right things at right time.",
        "Tip for Box 3",
        "Not focusing on career to save energy for other things.\n\nTip- it is good that u identify negative and positive in your career and save your energy by avoiding negative things that u might be doing can make u misrable in career.it has 30% of emotional layer which is big so use it well to gain true happiness.",
        "Tip for Box 5",
        "Thinking negative in career.\n\n Tip- All career has negative site, its ok to think negative yome time. Focus on your breath and find positive aspects of your job.",
        "Sad confuse in career.\n\n Tip- find exact reason for your confusion / sadness, it can be job itself?, lack of direction?,feeling exhausted and overwhelming, or external pressure by society family friends? Addres it responsible.",
        "Angry violent argument disrespected.\n\nTip- It's ok to be angry when you don't get what you expected. When things get wrong. And worsen over period.Than you need to ask yourself.\n\nWhat is truly important in your career?\nEg- financial stability/creativity/work life balance/helping others etc.\nWhat are your strengths and weakness?\nHow your ideal day would be?\nIs this work part of the ideal day?\nConnect with people who is doing well in your field or in field you are cosidering.\n\nIf u feel still confused take break give rest to professional layer of emotion and focus on other layer. You can get true happiness without it as well.",
      ],
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const Question4Screen()),
        );
      },
      onPrevious: () => Navigator.pop(context),
    );
  }
}
