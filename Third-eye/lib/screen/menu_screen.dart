import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:thirdeye/sharable_widget/back_btn.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: MyBackButton(),
        title: Text(
          "Menu",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
        children: [
          SvgPicture.asset("assets/icons/profile_pic.svg"),
          SvgPicture.asset("assets/verified.svg"),
          Text("This is text")
        ],
      ))),
    );
  }
}
