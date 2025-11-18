import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:thirdeye/screen/questions/question.dart';
import 'question3_screen.dart';

class Question2Screen extends StatefulWidget {
  final bool isMale;

  const Question2Screen({super.key, required this.isMale});

  @override
  State<Question2Screen> createState() => _Question2ScreenState();
}

class _Question2ScreenState extends State<Question2Screen> {
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
        'male/q2-20.png',
        'male/agna.png',
        'male/q2-10.png',
        'male/agna.png',
        'male/q2-0.png',
        'male/agna.png',
        'male/q2-neg10.png',
        'male/agna.png',
        'male/q2-neg20.png',
      ]
          : [
        'female/fq2-30.png',
        'female/fq2-20.png',
        'female/fq2-10.png',
        'female/agna.png',
        'female/fq2-0.png',
        'female/agna.png',
        'female/fq2-neg10.png',
        'female/fq2-neg20.png',
        'female/fq2-neg30.png',
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
          "Tip for Box 0",
          "Today you're doing great job by identifying what my family want and fullfilled it. Keep it up.",
          "Tip for Box 2",
          "Today you have done great job on providing the family what needed. But identify what they realy want. When u full fill it it will be more joy in family.",
          "Tip for Box 4",
          "Not interaction with family to save energy for other things\n\n It is good way to avoid more fight and conflicts.and save energy.But family will save you when u have personal/professional loss. So give more and less expect. So focus on what u can give",
          "Tip for Box 6",
          "feel sad avoided by family due to not fullfilled some demand.\n\n Don't become sad they are your responsibility.Time will heal. focus mistakes from your side correct it.Focus on breathing to become neutral.",
          "Tip for Box 8",
          "feel trapped, angry, violent with family\n\n 1.emotional separation by focusing on breath and counting breath holding seconds and air passing through nose. Inhale for eg. 4 sec hold for 4 second exhale for 6 sec.\n\n 2. Avoid interactionUnderstand situation and consequencyIf it is not life or death, them calmly explain them that you are not up to the mark or adequate information and energy for this discussion right now we will discussion soon laterol.\n\n 3. Understand root of your emotionsIf that person is realy important part of your version of family than forgive them and find mistake from your side and apologize because u will always able to forgive you but not others easily. And if not them than reduce your family circle by reducing expectations from them save 20% of energy.",
        ];

        texts = [
          "Family is happy because of you",
          "Male Box 0 text here...",
          "Doing what's needed",
          "Male Box 2 text here...",
          "No interaction",
          "Male Box 4 text here...",
          "Feeling sad due to lack of appreciation",
          "Male Box 6 text here...",
          "Feeling trapped, angry, or violent",
          "Male Box 8 text here...",
        ];
      } else {
        tips = [
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

        texts = [
          "Doing exact things for family",
          "Doing many things",
          "Thinking positively",
          "Female Box 3 text here...",
          "Avoiding interaction with family",
          "Female Box 5 text here...",
          "Feeling unappreciated",
          "Sad and ignored",
          "Feeling trapped with family",
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
        ? "Select from 5 boxes"
        : "Select from 7 boxes";

    return QuestionScreen(
      columnIndex: 1,
      boxImages: images,
      boxTips: tips,
      boxText: texts,
      questionText: questionText,
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Question3Screen(isMale: widget.isMale),
          ),
        );
      },
      onPrevious: () => Navigator.pop(context),
      isMale: widget.isMale,
    );
  }
}