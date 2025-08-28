import 'dart:async';
import 'package:flutter/material.dart';
import 'package:thirdeye/models/User.dart';
import 'package:thirdeye/repositories/sign_up_repository.dart';
import 'package:thirdeye/screen/verified_screen.dart';

import 'package:thirdeye/sharable_widget/button.dart';
import 'package:thirdeye/sharable_widget/snack_bar.dart';
import 'package:thirdeye/sharable_widget/text_feild.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen(
      {super.key, required this.email, required this.user});
  final String email;
  final User user;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late final String _email = widget.email;
  final TextEditingController _otpController = TextEditingController();
  final _repository = SignUpRepository();

  int _secondsRemaining = 30;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _verifyOtp() async {
    final otp = _otpController.text.trim();
    bool validOtp = await _repository.verifyOtp(widget.email, otp);
    if (validOtp) {
      bool registered = await _repository.registerUser(widget.user);
      if (registered) {
        if (!mounted) return;
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => VerifiedScreen()));
        CustomSnackBar.showCustomSnackBar(
            context, "User registered successfully");
      } else {
        if (!mounted) return;
        CustomSnackBar.showCustomSnackBar(context, "Error registering user");
      }
    } else {
      if (!mounted) return;
      CustomSnackBar.showCustomSnackBar(context, "Invalid OTP");
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
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFF1F5F9),
          radius: 0,
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Verify Account",
                  style: TextStyle(
                    fontSize: screenWidth * 0.075,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  "Code has been sent to $_email",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Enter the code to verify your account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Enter code",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              MyTextFeild(
                controller: _otpController,
                hintText: "4 Digit code",
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Didn't receive Code?"),
                  TextButton(
                    onPressed: _canResend
                        ? () {
                            // Resend OTP logic here
                            _startTimer();
                          }
                        : null,
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
              SizedBox(height: screenHeight * 0.35),
              MyButton(
                  buttonLabel: "Verify account", onPressed: () => _verifyOtp())
            ],
          ),
        ),
      ),
    );
  }
}
