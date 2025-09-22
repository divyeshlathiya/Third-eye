import 'package:flutter/material.dart';
import 'enhanced_button.dart';

class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.child, this.onPressed});
  final Widget? child;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    // Use the enhanced button for better styling
    if (child is Text) {
      final textWidget = child as Text;
      return PrimaryButton(
        text: textWidget.data ?? '',
        onPressed: onPressed,
      );
    }
    
    // Fallback to original button for complex children
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6366F1), // Updated to theme color
            foregroundColor: Colors.white,
            elevation: 2,
            shadowColor: const Color(0xFF6366F1).withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: child),
    );
  }
}
