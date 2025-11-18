import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:thirdeye/screen/questions/question.dart';

class Question4Screen extends StatefulWidget {
  final bool isMale;

  const Question4Screen({super.key, required this.isMale});

  @override
  State<Question4Screen> createState() => _Question4ScreenState();
}

class _Question4ScreenState extends State<Question4Screen> {
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
        'male/q4-40.jpg',
        'male/q4-30.png',
        'male/q4-20.png',
        'male/q4-10.png',
        'male/q4-0.png',
        'male/q4-neg10.png',
        'male/q4-neg20.png',
        'male/q4-neg30.png',
        'male/q4-neg40.png',
      ]
          : [
        'female/agna.png',
        'female/fq4-10.png',
        'female/agna.png',
        'female/agna.png',
        'female/fq4-0.png',
        'female/agna.png',
        'female/agna.png',
        'female/fq4-neg10.png',
        'female/agna.png',
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
          "Emotional entanglement of giving each other.\n\nTip-This is highest form of emotional entanglement with your partner in which both are trying to give what other partner needs rather than asking or seeking from each other.This is deep strong powerfull feeling that creates very deep memory.Every one who is in love desire for it.\n\nKeep it up and give without expectations (Unconditional love)",
          "Doing exact things that needed to be done.\n\nTip- you are doing exactly things that needed to be done for your partner. That's great keep doing it without expectations get rhym with your partner. Your partner will feel bleesed secure and satisfy around you and over period of time Your partner will get emotionally attached with you.",
          "Doing many thing for loved one\n\nTip- you are trying many things for for your partner out of love what u can do for them. That is great initiation of your expression here you are giving all that you can out of love. Now focus on things that truely matter for your partner help and support in them.",
          "Thinking good for your partner\n\nTip- Just by thinking good you gain Happiness and energy. That will increase once you start working for your partner.",
          "Not focusing on lovelife to save energy for other things\n\nTip- it's great you are aware that love life is not working as you expected and you have seen the negative part of it and it can drain your energy dangerously.your innerchild has 40% of emotional energy but still you can gain 'true happiness' without of it\n\nRemember that it is rare to find right person who can activate your innerchild. Which has highest peak of Happiness. So thinking good for them and giving them more can make your life happier.",
          "Negative thinking for your partner\n\nTip- It is normal to feel negative about your partner. You love your partner so much and you give them best of you. Their slight unpredictable action can make you feel like that. They are the core part of your innerchild child so don't be sily and divert your energy to positive side. Think and do good for them.",
          "Sad because not got what wanted\n\nTip- you feel sad because your partner has not done something for you that you wanted, its normal to feel sad because when you feel for someone so much, your expectation will increase which might be justifiable for relationship. But some how your partner has not fullfill it, may be because of they are focusing on other important responsibilities or your partner's feeling is lesser than yours.\n\nSolution is you have to express your emotion by identifying what realy matters for them. Focus on giving more without expectations will make your love more powerfull.",
          "Anger violent all things getting wrong\n\nTip- you are angry / violent with your partner may be because many unfulfilled Expectations which might be true and justifiable.Anger is natural defensive power full action to protect your self. Anger is dangerously distructive.Innerchild has highest power, memory, feeling.\nIf you are using against the one you love routinely you might loose them eventually Initially loss of emotional attachment and than physical attachment.So you need to find the reason of unfulfilment may be your partners feeling is lesser than you or they are doing more responsible things that needed to be done.In any case you must understand that they are core for your innerchild which has 40% of your emotions. U have to forgive them and give them what they desire.",
          "Separation\n\nTip- repeated anger and disrespect suggest incompatibility.\nInnerchild has 40% of emotional energy\nAnd get activated by special people, its privilege, everyone is not that lucky.\nIt's like routinely riding bike of 150-200 cc Suddenly you drive 1200 cc bike.\nand save your innerchild.\nYou have to learn and handle it well.\nIf it is not under control it can destroy you.\n\nTake care of your core.\nwhen it get destroyed living without innerchild is so painfull. The deep memories can destroy you in guilt.\nYour emotions are strongest in the core That's why you can justify all thought and action.",
        ];

        texts = [
          "Emotional giving nature from both partners",
          "Doing exactly what's needed",
          "Doing many things out of love",
          "Thinking good",
          "Not engaging",
          "Negative thoughts for partner",
          "Sad from unfulfilled needs",
          "Anger and violence",
          "Emotional separation",
        ];
      } else {
        tips = [
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

        texts = [
          "Female Box 0 text here...",
          "Feeling happy in the moment",
          "Female Box 2 text here...",
          "Female Box 3 text here...",
          "Neutral, not engaging",
          "Female Box 5 text here...",
          "Female Box 6 text here...",
          "Feeling sad",
          "Female Box 8 text here...",
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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final String questionText = widget.isMale
        ? "This is Question 4: Select from 9 boxes"
        : "This is Question 4: Select from 3 boxes";

    return QuestionScreen(
      columnIndex: 3,
      boxImages: images,
      boxTips: tips,
      boxText: texts,
      questionText: questionText,
      onNext: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Quiz Completed!")),
        );
      },
      onPrevious: () => Navigator.pop(context),
      isMale: widget.isMale,
    );
  }
}