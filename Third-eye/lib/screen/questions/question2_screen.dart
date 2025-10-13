// import 'package:flutter/material.dart';
// import 'package:thirdeye/screen/questions/question.dart';
// import 'question3_screen.dart';

// class Question2Screen extends StatefulWidget {
//   final bool isMale; // ✅ Add gender flag

//   const Question2Screen({super.key, required this.isMale});

//   @override
//   State<Question2Screen> createState() => _Question2ScreenState();
// }

// class _Question2ScreenState extends State<Question2Screen> {
//   int? selectedBox; // Track which box user clicked

//   @override
//   Widget build(BuildContext context) {
//     final maleImages = [
//       "assets/q2-10.png",
//       "assets/agna.jpg",
//       "assets/q2-20.png",
//       "assets/agna.png",
//       "assets/q2-0.png",
//       "assets/agna.png",
//       "assets/q2-neg10.png",
//       "assets/agna.jpg",
//       "assets/q2-neg20.png",
//     ];

//     final maleTips = [
//       "Today you're doing great job by identifying what my family want and fullfilled it. Keep it up.",
//       "Tip for Box 1",
//       "Today you have done great job on providing the family what needed. But identify what they realy want. When u full fill it it will be more joy in family.",
//       "Tip for Box 3",
//       " Not interaction with family to save energy for other things\n\n It is good way to avoid more fight and conflicts.and save energy.But family will save you when u have personal/professional loss. So give more and less expect. So focus on what u can give",
//       "Tip for Box 5",
//       " feel sad avoided by family due to not fullfilled some demand.\n\n Don't become sad they are your responsibility.Time will heal. focus mistakes from your side correct it.Focus on breathing to become neutral.",
//       "Tip for Box 7",
//       "feel trapped, angry, violent with family\n\n 1.emotional separation by focusing on breath and counting breath holding seconds and air passing through nose. Inhale for eg. 4 sec hold for 4 second exhale for 6 sec.\n\n 2. Avoid interactionUnderstand situation and consequencyIf it is not life or death, them calmly explain them that you are not up to the mark or adequate information and energy for this discussion right now we will discussion soon laterol.\n\n 3. Understand root of your emotionsIf that person is realy important part of your version of family than forgive them and find mistake from your side and apologize because u will always able to forgive you but not others easily. And if not them than reduce your family circle by reducing expectations from them save 20% of energy.",
//     ];

//     // ✅ Female data (replace with your own)
//     final femaleImages = [
//       "assets/agna.png",
//       "assets/agna.png",
//       "assets/agna.png",
//       "assets/agna.png",
//       "assets/agna.png",
//       "assets/agna.png",
//       "assets/agna.png",
//       "assets/agna.png",
//       "assets/agna.png",
//     ];

//     final femaleTips = [
//       "Tip for Female Box 0",
//       "Self-care is important—make time for activities that bring you peace.",
//       "Tip for Female Box 2",
//       "Tip for Female Box 3",
//       "Stay focused on long-term goals, not temporary relief.",
//       "Tip for Female Box 5",
//       "Tip for Female Box 6",
//       "Remember: feelings are temporary, your inner strength is lasting.",
//       "Tip for Female Box 8",
//     ];

//     // ✅ Choose based on gender
//     final images = widget.isMale ? maleImages : femaleImages;
//     final tips = widget.isMale ? maleTips : femaleTips;
//     return QuestionScreen(
//       columnIndex: 1,
//       boxImages: images,
//       questionText: "This is Question 2: Select from 5 boxes",
//       boxTips: tips,
//       onNext: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (_) => Question3Screen(isMale: widget.isMale)),
//         );
//       },
//       onPrevious: () => Navigator.pop(context),
//       isMale: widget.isMale,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:thirdeye/screen/questions/question.dart';
import 'question3_screen.dart';

class Question2Screen extends StatefulWidget {
  final bool isMale; // ✅ Add gender flag

  const Question2Screen({super.key, required this.isMale});

  @override
  State<Question2Screen> createState() => _Question2ScreenState();
}

class _Question2ScreenState extends State<Question2Screen> {
  int? selectedBox; // Track which box user clicked

  @override
  Widget build(BuildContext context) {
    final maleImages = [
      "assets/q2-20.png",
      "assets/agna.jpg",
      "assets/q2-10.png",
      "assets/agna.png",
      "assets/q2-0.png",
      "assets/agna.png",
      "assets/q2-neg10.png",
      "assets/agna.jpg",
      "assets/q2-neg20.png",
    ];

    final maleTips = [
      "Today you're doing great job by identifying what my family want and fullfilled it. Keep it up.",
      "Tip for Box 1",
      "Today you have done great job on providing the family what needed. But identify what they realy want. When u full fill it it will be more joy in family.",
      "Tip for Box 3",
      " Not interaction with family to save energy for other things\n\n It is good way to avoid more fight and conflicts.and save energy.But family will save you when u have personal/professional loss. So give more and less expect. So focus on what u can give",
      "Tip for Box 5",
      " feel sad avoided by family due to not fullfilled some demand.\n\n Don't become sad they are your responsibility.Time will heal. focus mistakes from your side correct it.Focus on breathing to become neutral.",
      "Tip for Box 7",
      "feel trapped, angry, violent with family\n\n 1.emotional separation by focusing on breath and counting breath holding seconds and air passing through nose. Inhale for eg. 4 sec hold for 4 second exhale for 6 sec.\n\n 2. Avoid interactionUnderstand situation and consequencyIf it is not life or death, them calmly explain them that you are not up to the mark or adequate information and energy for this discussion right now we will discussion soon laterol.\n\n 3. Understand root of your emotionsIf that person is realy important part of your version of family than forgive them and find mistake from your side and apologize because u will always able to forgive you but not others easily. And if not them than reduce your family circle by reducing expectations from them save 20% of energy.",
    ];
    final maleText = [
      "Male Box 0 text here...",
      "Male Box 1 text here...",
      "Male Box 2 text here...",
      "Male Box 3 text here...",
      "Male Box 4 text here...",
      "Male Box 5 text here...",
      "Male Box 6 text here...",
      "Male Box 7 text here...",
      "Male Box 8 text here...",
    ];

    // ✅ Female data (replace with your own)
    final femaleImages = [
      "assets/fq2-30.png",
      "assets/fq2-20.png",
      "assets/fq2-10.png",
      "assets/agna.png",
      "assets/fq2-0.png",
      "assets/agna.png",
      "assets/fq2-neg10.png",
      "assets/fq2-neg20.png",
      "assets/fq2-neg30.png",
    ];

    final femaleTips = [
      "You're at your emotional peak. Your family is emotionally fulfilled.",
      "Wonderful. Now simplify by focusing on what truly matters to them.",
      "Keep nurturing the bond. It strengthens your core.",
      "Tip for Female Box 3",
      "It's protective, but reflect and resolve eventually.",
      "Tip for Female Box 5",
      "You care deeply. Forgive them to heal yourself.",
      "Step back, reduce expectations, and express your emotions calmly.",
      "Practice emotional detachment,forgiveness, and boundaries.",
    ];

    final femaleText = [
      "Female Box 0 text here...",
      "Female Box 1 text here...",
      "Female Box 2 text here...",
      "Female Box 3 text here...",
      "Female Box 4 text here...",
      "Female Box 5 text here...",
      "Female Box 6 text here...",
      "Female Box 7 text here...",
      "Female Box 8 text here...",
    ];
    // ✅ Choose based on gender
    final images = widget.isMale ? maleImages : femaleImages;
    final tips = widget.isMale ? maleTips : femaleTips;
    final texts = widget.isMale ? maleText : femaleText;

    return QuestionScreen(
      columnIndex: 1,
      boxImages: images,
      questionText: "Select from 5 boxes",
      boxTips: tips,
      boxText: texts,
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => Question3Screen(isMale: widget.isMale)),
        );
      },
      onPrevious: () => Navigator.pop(context),
      isMale: widget.isMale,
    );
  }
}
