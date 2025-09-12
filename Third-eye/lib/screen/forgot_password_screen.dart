import 'package:flutter/material.dart';
import 'package:thirdeye/repositories/sign_up_repository.dart';
import 'package:thirdeye/screen/reset_otp_verification.dart';
import 'package:thirdeye/sharable_widget/button.dart';
import 'package:thirdeye/sharable_widget/snack_bar.dart';
import 'package:thirdeye/sharable_widget/text_feild.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool isLoading = false;
  final repo = SignUpRepository();

  Future<void> _sendOtp() async {
    if (_emailController.text.isEmpty) {
      CustomSnackBar.showCustomSnackBar(context, "Please enter otp");
      return;
    }
    setState(() => isLoading = true);
    final success = await repo.sendOtp(_emailController.text, "reset");
    setState(() => isLoading = false);

    if (success && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ResetOtpVerificationScreen(email: _emailController.text),
        ),
      );
    } else {
      CustomSnackBar.showCustomSnackBar(context, "Failed to send OTP");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            MyTextFeild(
                controller: _emailController, hintText: "johndoe@gmail.com",labelText: "Email",),
            const SizedBox(height: 20),
            MyButton(
              onPressed: isLoading ? null : _sendOtp,
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      "Send OTP",
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
