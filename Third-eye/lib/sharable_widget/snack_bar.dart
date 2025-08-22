import 'package:flutter/material.dart';

class CustomSnackBar {
  static void showCustomSnackBar(BuildContext context, String message,
      {Color backgroundColor = Colors.deepPurple}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
