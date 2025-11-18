import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:thirdeye/screen/questions/question.dart';
import 'question4_screen.dart';

class Question3Screen extends StatefulWidget {
  final bool isMale;

  const Question3Screen({super.key, required this.isMale});

  @override
  State<Question3Screen> createState() => _Question3ScreenState();
}

class _Question3ScreenState extends State<Question3Screen> {
  int? selectedBox;
  late List<String> images;
  late List<String> tips;
  late List<String> texts;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadImages(); // Load from local storage or Firebase
  }

  /// ✅ Load and cache images locally (downloads only once)
  Future<void> _loadImages() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final dio = Dio();
      final List<String> localPaths = [];

      // 🔹 Define Firebase Storage references
      List<String> refs = widget.isMale
          ? [
        'male/q3-30.png',
        'male/q3-20.png',
        'male/q3-10.png',
        'male/agna.png',
        'male/q3-0.png',
        'male/agna.png',
        'male/q3-neg10.png',
        'male/q3-neg20.png',
        'male/q3-neg30.png',
      ]
          : [
        'female/fq3-20.png',
        'female/agna.png',
        'female/fq3-10.png',
        'female/agna.png',
        'female/fq3-0.png',
        'female/agna.png',
        'female/fq3-neg10.png',
        'female/agna.png',
        'female/fq3-neg20.png',
      ];

      // 🔹 Download or use cached image files
      for (String refPath in refs) {
        final fileName = refPath.split('/').last;
        final localFile = File('${appDir.path}/$fileName');

        if (await localFile.exists()) {
          // ✅ Use cached version
          localPaths.add(localFile.path);
        } else {
          // ⬇️ Download and save to local storage
          try {
            final url = await FirebaseStorage.instance.ref(refPath).getDownloadURL();
            await dio.download(url, localFile.path);
            localPaths.add(localFile.path);
          } catch (e) {
            debugPrint("❌ Error downloading $refPath: $e");
            // Add a placeholder or handle missing images
            localPaths.add(localFile.path); // Will use the path even if download failed
          }
        }
      }

      // 🔹 Assign to image list
      images = localPaths;

      // 🔹 Define text + tips
      if (widget.isMale) {
        tips = [
          "Achievement in Carrier\n\n Tip- as male career is 2nd most important powerfull emotional layer of achievments in career Keep identifying the exact things that needed to be done for career.",
          "Trying many things to achieve goal.\n\n Tip - doing many things for career keep you good position emotional state. Try to identify the things which is needed to be done and plan for it.When your why you do this will clear,how will u do will become easy.",
          "Thinking for success in career.\n\nTip- only thinking positive for your career can make you happy. Happiness will increase once work for it. U will be happiest when u achieve your goal by doing right things at right time.",
          "Tip for Box 3",
          "Not focusing on career to save energy for other things.\n\nTip- it is good that u identify negative and positive in your career and save your energy by avoiding negative things that u might be doing can make u misrable in career.it has 30% of emotional layer which is big so use it well to gain true happiness.",
          "Tip for Box 5",
          "Thinking negative in career.\n\n Tip- All career has negative site, its ok to think negative yome time. Focus on your breath and find positive aspects of your job.",
          "Sad confuse in career.\n\n Tip- find exact reason for your confusion / sadness, it can be job itself?, lack of direction?,feeling exhausted and overwhelming, or external pressure by society family friends? Addres it responsible.",
          "Angry violent argument disrespected.\n\nTip- It's ok to be angry when you don't get what you expected. When things get wrong. And worsen over period.Than you need to ask yourself.\n\nWhat is truly important in your career?\nEg- financial stability/creativity/work life balance/helping others etc.\nWhat are your strengths and weakness?\nHow your ideal day would be?\nIs this work part of the ideal day?\nConnect with people who is doing well in your field or in field you are cosidering.\n\nIf u feel still confused take break give rest to professional layer of emotion and focus on other layer. You can get true happiness without it as well.",
        ];

        texts = [
          "Achievement",
          "Trying multiple things",
          "Thinking positively about career",
          "Male Box 3 text here...",
          "Avoiding to save energy",
          "Male Box 5 text here...",
          "Negative thoughts",
          "Confused and sad",
          "Angry, disrespected, argumentative",
        ];
      } else {
        tips = [
          "You are aligned with your purpose.Keep it up.",
          "Tip for Female Box 1",
          "Doing meaningful work increases self-worth.",
          "Tip for Female Box 3",
          "Good. You're focusing on what's more important right now.",
          "Tip for Female Box 5",
          "Identify the root. It could be job fit pressure, or exhaustion.",
          "Tip for Female Box 7",
          "Ask yourself what's truly important Take a pause. Explore other layers of energy.",
        ];

        texts = [
          "Achieving your goals",
          "Female Box 1 text here...",
          "Working positively",
          "Female Box 3 text here...",
          "Taking a break",
          "Female Box 5 text here...",
          "Negative thoughts",
          "Female Box 7 text here...",
          "Angry and disrespected",
        ];
      }

      setState(() => loading = false);
    } catch (e) {
      debugPrint("❌ Error loading images: $e");
      // Handle error state appropriately
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/rocket.gif',
                width: 180,
                height: 180,
              ),
              const SizedBox(height: 16), // Add some spacing
              const Text("Question is loading...",style: TextStyle(fontWeight: FontWeight.bold),)
            ],
          ),
        )
      );
    }

    final String questionText = widget.isMale
        ? "Select from 7 boxes"
        : "Select from 5 boxes";

    return QuestionScreen(
      columnIndex: 2,
      boxImages: images,
      boxTips: tips,
      boxText: texts,
      questionText: questionText,
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Question4Screen(isMale: widget.isMale),
          ),
        );
      },
      onPrevious: () => Navigator.pop(context),
      isMale: widget.isMale,
    );
  }
}