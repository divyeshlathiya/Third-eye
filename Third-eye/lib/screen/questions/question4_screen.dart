import 'package:flutter/material.dart';
import 'package:thirdeye/screen/questions/question.dart';

class Question4Screen extends StatefulWidget {
  final bool isMale; // ✅ Add gender flag

  const Question4Screen({super.key, required this.isMale});

  @override
  State<Question4Screen> createState() => _Question4ScreenState();
}

class _Question4ScreenState extends State<Question4Screen> {
  int? selectedBox; // Track which box user clicked

  @override
  Widget build(BuildContext context) {
    final maleImages = [
      "assets/q4-40.jpg",
      "assets/q4-30.png",
      "assets/q4-20.png",
      "assets/q4-10.png",
      "assets/q4-0.png",
      "assets/q4-neg10.png",
      "assets/q4-neg20.png",
      "assets/q4-neg30.png",
      "assets/q4-neg40.png",
    ];

    final maleTips = [
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
      columnIndex: 3,
      boxImages: images,
      questionText: "This is Question 3: Select from 7 boxes",
      boxTips: tips,
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