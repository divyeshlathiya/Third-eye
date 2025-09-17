import 'dart:async';
import 'package:flutter/material.dart';
import 'package:thirdeye/models/User.dart';
import 'package:thirdeye/repositories/sign_up_repository.dart';
import 'package:thirdeye/screen/about_yourself.dart';
import 'package:thirdeye/services/auth_manager.dart';

import 'package:thirdeye/sharable_widget/button.dart';
import 'package:thirdeye/sharable_widget/snack_bar.dart';
import 'package:thirdeye/sharable_widget/text_feild.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key, required this.email, this.user});
  final String email;
  final User? user;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late final String _email = widget.email;
  final TextEditingController _otpController = TextEditingController();
  final _repository = SignUpRepository();
  bool isLoading = false;

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

  if (otp.isEmpty) {
    if (!mounted) return;
    CustomSnackBar.showCustomSnackBar(context, "Please enter OTP");
    return;
  }

  setState(() => isLoading = true);

  try {
    bool validOtp = await _repository.verifyOtp(widget.email, otp, "signup");
    if (!mounted) return;

    if (validOtp) {
      // 🔄 Use AuthManager instead of SignUpRepository directly
      final authManager = AuthManager();

      final registered = await authManager.signUpUser({
        "firstName": widget.user!.firstName,
        "lastName": widget.user!.lastName,
        "email": widget.user!.email,
        "password": widget.user!.password,
      });

      if (!mounted) return;

      if (registered != null && registered["tokens"] != null) {
        final accessToken = registered["tokens"]["access_token"];

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => AboutYourSelfScreen(accessToken: accessToken),
          ),
        );
      } else {
        CustomSnackBar.showCustomSnackBar(context, "Error registering user");
      }
    } else {
      CustomSnackBar.showCustomSnackBar(context, "Invalid OTP");
    }
  } catch (e) {
    CustomSnackBar.showCustomSnackBar(context, "Something went wrong: $e");
  } finally {
    if (mounted) setState(() => isLoading = false);
  }
}


  // void _verifyOtp() async {
  //   final otp = _otpController.text.trim();

  //   if (otp.isEmpty) {
  //     if (!mounted) return;
  //     CustomSnackBar.showCustomSnackBar(context, "Please enter OTP");
  //     return;
  //   }
  //   setState(() => isLoading = true);

  //   try {
  //     bool validOtp = await _repository.verifyOtp(widget.email, otp, "signup");
  //     if (!mounted) return;
  //     if (validOtp) {
  //       final registered = await _repository.registerUser(widget.user!);
  //       if (!mounted) return;

  //       if (registered != null) {
  //         final accessToken = registered["tokens"]["access_token"];

  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (_) => AboutYourSelfScreen(
  //                       accessToken: accessToken,
  //                     )));
  //         // CustomSnackBar.showCustomSnackBar(
  //         //     context, "User registered successfully");
  //       } else {
  //         if (!mounted) return;
  //         CustomSnackBar.showCustomSnackBar(context, "Error registering user");
  //       }
  //     } else {
  //       if (!mounted) return;
  //       CustomSnackBar.showCustomSnackBar(context, "Invalid OTP");
  //     }
  //   } catch (e) {
  //     if (!mounted) return;
  //     CustomSnackBar.showCustomSnackBar(
  //       context,
  //       "Something went wrong: $e",
  //     );
  //   } finally {
  //     if (mounted) setState(() => isLoading = false);
  //   }
  // }

  void _resendOtp() async {
    setState(() => isLoading = true);
    try {
      bool otpSent =
          await _repository.sendOtp(_email, "signup"); // purpose can be dynamic
      if (!mounted) return;

      if (otpSent) {
        CustomSnackBar.showCustomSnackBar(context, "OTP resent successfully");
        _startTimer();
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
                labelText: "4 Digit code",
              ),
              const SizedBox(height: 20),
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
              SizedBox(height: screenHeight * 0.35),
              MyButton(
                onPressed: isLoading ? null : _verifyOtp,
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
                        "Verify OTP",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
