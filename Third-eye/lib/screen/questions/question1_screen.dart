import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'question2_screen.dart';
import 'package:thirdeye/screen/questions/question.dart';

class Question1Screen extends StatefulWidget {
  final bool isMale; // ✅ Add gender flag

  const Question1Screen({super.key, required this.isMale});

  @override
  State<Question1Screen> createState() => _Question1ScreenState();
}

class _Question1ScreenState extends State<Question1Screen> {
  int? selectedBox;
  late List<String> images;
  late List<String> tips;
  late List<String> texts;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    try {
      if (widget.isMale) {
        images = await Future.wait([
          FirebaseStorage.instance.ref('male/agna.png').getDownloadURL(),
          FirebaseStorage.instance.ref('male/q1-10.jpg').getDownloadURL(),
          FirebaseStorage.instance.ref('male/agna.png').getDownloadURL(),
          FirebaseStorage.instance.ref('male/agna.png').getDownloadURL(),
          FirebaseStorage.instance.ref('male/q1-0.png').getDownloadURL(),
          FirebaseStorage.instance.ref('male/agna.png').getDownloadURL(),
          FirebaseStorage.instance.ref('male/agna.png').getDownloadURL(),
          FirebaseStorage.instance.ref('male/q1-neg10.png').getDownloadURL(),
          FirebaseStorage.instance.ref('male/agna.png').getDownloadURL(),
        ]);

        tips = [
          "Tip for Box 0",
          "Short term happiness is easy to gain, repeatable, affordable and survival in deep pain but not to get addict. It can waste time energy.",
          "Tip for Box 2",
          "Tip for Box 3",
          "Good choice, don't burn your opportunity for temporary things.",
          "Tip for Box 5",
          "Tip for Box 6",
          "It's okay, focus your energy on other stuff that has true meaning in your life. To become neutral, focus on deep breathing. The feeling is just temporary and only 10% of your total energy.",
          "Tip for Box 8",
        ];
        texts = [
          "Male Box 0 text here...",
          "Feeling happy in the moment",
          "Male Box 2 text here...",
          "Male Box 3 text here...",
          "Neutral, not engaging",
          "Male Box 5 text here...",
          "Male Box 6 text here...",
          "Feeling sad",
          "Male Box 8 text here...",
        ];
      } else {
        images = await Future.wait([
          FirebaseStorage.instance.ref('male/q4-40.jpg').getDownloadURL(),
          FirebaseStorage.instance.ref('male/q4-30.png').getDownloadURL(),
          FirebaseStorage.instance.ref('female/fq1-20.png').getDownloadURL(),
          FirebaseStorage.instance.ref('male/q4-10.png').getDownloadURL(),
          FirebaseStorage.instance.ref('female/fq1-0.png').getDownloadURL(),
          FirebaseStorage.instance.ref('female/fq1-neg10.png').getDownloadURL(),
          FirebaseStorage.instance.ref('female/fq1-neg20.png').getDownloadURL(),
          FirebaseStorage.instance.ref('male/q4-neg30.png').getDownloadURL(),
          FirebaseStorage.instance.ref('male/q4-neg40.png').getDownloadURL(),
        ]);

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
          "Emotional giving from both partners",
          "Doing exactly what’s needed",
          "Doing many things out of love",
          "Thinking good",
          "Not engaging",
          "Negative thoughts",
          "Sad from unfulfilled needs",
          "Anger and violence",
          "Emotional separation",
        ];
      }

      setState(() {
        loading = false;
      });
    } catch (e) {
      debugPrint("Error loading images: $e");
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
        ? "This is Question 1: Select from 3 boxes"
        : "This is Question 1: Select from 9 boxes";

    return QuestionScreen(
      columnIndex: 0,
      boxImages: images,
      boxTips: tips,
      boxText: texts,
      questionText: questionText,
      onNext: () {  
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Question2Screen(isMale: widget.isMale),
          ),
        );
      },
      onPrevious: () => Navigator.pop(context),
      isMale: widget.isMale,
    );
  }
}
