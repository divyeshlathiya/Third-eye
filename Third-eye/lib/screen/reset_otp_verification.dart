import 'dart:async';

import 'package:flutter/material.dart';
import 'package:thirdeye/screen/reset_password.dart';
import 'package:thirdeye/sharable_widget/button.dart';
import 'package:thirdeye/sharable_widget/snack_bar.dart';
import 'package:thirdeye/sharable_widget/text_feild.dart';
import '../../repositories/sign_up_repository.dart';

class ResetOtpVerificationScreen extends StatefulWidget {
  final String email;
  const ResetOtpVerificationScreen({super.key, required this.email});

  @override
  State<ResetOtpVerificationScreen> createState() =>
      _ResetOtpVerificationScreenState();
}

class _ResetOtpVerificationScreenState
    extends State<ResetOtpVerificationScreen> {
  final _otpController = TextEditingController();
  bool isLoading = false;
  final repo = SignUpRepository();

  int _secondsRemaining = 30;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  Future<void> _verifyOtp() async {
    setState(() => isLoading = true);
    final success =
        await repo.verifyOtp(widget.email, _otpController.text, "reset");
    setState(() => isLoading = false);

    if (success && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(email: widget.email),
        ),
      );
    } else {
      CustomSnackBar.showCustomSnackBar(context, "Invalid OTP");
    }
  }

  void _resendOtp() async {
    setState(() => isLoading = true);
    try {
      bool otpSent =
          await repo.sendOtp(widget.email, "reset"); // purpose can be dynamic
      if (!mounted) return;

      if (otpSent) {
        CustomSnackBar.showCustomSnackBar(context, "OTP resent successfully");
      } else {
        CustomSnackBar.showCustomSnackBar(context, "Failed to resend OTP");
      }
    } catch (e) {
      if (!mounted) return;
      CustomSnackBar.showCustomSnackBar(context, "Error resending OTP: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 30;
      _canResend = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify OTP")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            MyTextFeild(
              controller: _otpController,
              labelText: "Enter OTP",
            ),
            const SizedBox(height: 20),
            MyButton(
              onPressed: isLoading ? null : _verifyOtp,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Verify"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Didn't receive Code?"),
                TextButton(
                  onPressed: _canResend ? _resendOtp : null,
                  style: TextButton.styleFrom(
                    foregroundColor: _canResend ? Colors.blue : Colors.grey,
                  ),
                  child: const Text("Resend code"),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Resend code in "),
                Text(
                  _canResend ? "0" : "00:${_secondsRemaining}s",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
