import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thirdeye/screen/questions/question.dart';
import 'question3_screen.dart';

class Question2Screen extends StatefulWidget {
  final bool isMale;

  const Question2Screen({super.key, required this.isMale});

  @override
  State<Question2Screen> createState() => _Question2ScreenState();
}

class _Question2ScreenState extends State<Question2Screen> {
  late List<String> images;
  late List<String> tips;
  late List<String> texts;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  /// ✅ Downloads Firebase images once, caches them locally in app directory
  Future<void> _loadImages() async {
    try {
      final dir = await getApplicationDocumentsDirectory();

      if (widget.isMale) {
        final urls = [
          'male/q2-20.png',
          'male/agna.png',
          'male/q2-10.png',
          'male/agna.png',
          'male/q2-0.png',
          'male/agna.png',
          'male/q2-neg10.png',
          'male/agna.png',
          'male/q2-neg20.png',
        ];

        images = await Future.wait(urls.map((path) async {
          final localFile = File('${dir.path}/${path.split('/').last}');
          if (await localFile.exists()) {
            return localFile.path;
          } else {
            final ref = FirebaseStorage.instance.ref(path);
            final bytes = await ref.getData();
            if (bytes != null) await localFile.writeAsBytes(bytes);
            return localFile.path;
          }
        }));

        tips = [
          "Today you're doing great job by identifying what my family want and fullfilled it. Keep it up.",
          "Tip for Box 1",
          "Today you have done great job on providing the family what needed. But identify what they realy want. When u full fill it it will be more joy in family.",
          "Tip for Box 3",
          "Not interaction with family to save energy for other things\n\n It is good way to avoid more fight and conflicts.and save energy.But family will save you when u have personal/professional loss. So give more and less expect. So focus on what u can give",
          "Tip for Box 5",
          "feel sad avoided by family due to not fullfilled some demand.\n\n Don't become sad they are your responsibility.Time will heal. focus mistakes from your side correct it.Focus on breathing to become neutral.",
          "Tip for Box 7",
          "feel trapped, angry, violent with family\n\n 1.emotional separation by focusing on breath and counting breath holding seconds and air passing through nose. Inhale for eg. 4 sec hold for 4 second exhale for 6 sec.\n\n 2. Avoid interactionUnderstand situation and consequencyIf it is not life or death, them calmly explain them that you are not up to the mark or adequate information and energy for this discussion right now we will discussion soon laterol.\n\n 3. Understand root of your emotionsIf that person is realy important part of your version of family than forgive them and find mistake from your side and apologize because u will always able to forgive you but not others easily. And if not them than reduce your family circle by reducing expectations from them save 20% of energy.",
        ];

        texts = [
          "Family is happy because of you",
          "Male Box 1 text here...",
          "Doing what's needed",
          "Male Box 3 text here...",
          "No interaction",
          "Male Box 5 text here...",
          "Feeling sad due to lack of appreciation",
          "Male Box 7 text here...",
          "Feeling trapped, angry, or violent",
        ];
      } else {
        final urls = [
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

        images = await Future.wait(urls.map((path) async {
          final localFile = File('${dir.path}/${path.split('/').last}');
          if (await localFile.exists()) {
            return localFile.path;
          } else {
            final ref = FirebaseStorage.instance.ref(path);
            final bytes = await ref.getData();
            if (bytes != null) await localFile.writeAsBytes(bytes);
            return localFile.path;
          }
        }));

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

      setState(() {
        loading = false;
      });
    } catch (e) {
      debugPrint("❌ Error loading images: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final questionText = widget.isMale
        ? "This is Question 2: Select from 5 boxes"
        : "This is Question 2: Select from 7 boxes";

    return QuestionScreen(
      columnIndex: 1,
      boxImages: images, // ✅ Local cached paths used here
      boxTips: tips,
      boxText: texts,
      questionText: questionText,
      isMale: widget.isMale,
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Question3Screen(isMale: widget.isMale),
          ),
        );
      },
      onPrevious: () => Navigator.pop(context),
    );
  }
}