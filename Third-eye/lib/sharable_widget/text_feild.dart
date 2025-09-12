import 'package:flutter/material.dart';

class MyTextFeild extends StatelessWidget {
  const MyTextFeild(
      {super.key, this.controller, this.hintText, this.labelText});
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
