import 'package:flutter/material.dart';
import 'package:thirdeye/screen/questions/question.dart';
import 'question3_screen.dart';

class Question2Screen extends StatefulWidget {
  const Question2Screen({super.key});

  @override
  State<Question2Screen> createState() => _Question2ScreenState();
}

class _Question2ScreenState extends State<Question2Screen> {
  int? selectedBox; // Track which box user clicked

  @override
  Widget build(BuildContext context) {
    return QuestionScreen(
      columnIndex: 1,
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
      questionText: "This is Question 2: Select from 5 boxes",
      boxTips: [
        "Today you're doing great job by identifying what my family want and fullfilled it. Keep it up.",
        "Tip for Box 1",
        "Today you have done great job on providing the family what needed. But identify what they realy want. When u full fill it it will be more joy in family.",
        "Tip for Box 3",
        " Not interaction with family to save energy for other things\n\n It is good way to avoid more fight and conflicts.and save energy.But family will save you when u have personal/professional loss. So give more and less expect. So focus on what u can give",
        "Tip for Box 5",
        " feel sad avoided by family due to not fullfilled some demand.\n\n Don't become sad they are your responsibility.Time will heal. focus mistakes from your side correct it.Focus on breathing to become neutral.",
        "Tip for Box 7",
        "feel trapped, angry, violent with family\n\n 1.emotional separation by focusing on breath and counting breath holding seconds and air passing through nose. Inhale for eg. 4 sec hold for 4 second exhale for 6 sec.\n\n 2. Avoid interactionUnderstand situation and consequencyIf it is not life or death, them calmly explain them that you are not up to the mark or adequate information and energy for this discussion right now we will discussion soon laterol.\n\n 3. Understand root of your emotionsIf that person is realy important part of your version of family than forgive them and find mistake from your side and apologize because u will always able to forgive you but not others easily. And if not them than reduce your family circle by reducing expectations from them save 20% of energy.",
      ],
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const Question3Screen()),
        );
      },
      onPrevious: () => Navigator.pop(context),
    );
  }
}
