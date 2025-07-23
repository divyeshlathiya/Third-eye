import 'package:flutter/material.dart';

class MyBackButton extends StatelessWidget {
  const MyBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        FocusScope.of(context).unfocus(); // Close keyboard
        await Future.delayed(const Duration(milliseconds: 200));
        if (context.mounted) Navigator.pop(context); // Then pop
      },
      icon: const Icon(Icons.arrow_back, color: Colors.black),
    );
  }
}
