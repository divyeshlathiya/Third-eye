import 'dart:async';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:thirdeye/models/User.dart';
import 'package:thirdeye/repositories/sign_up_repository.dart';
import 'package:thirdeye/screen/about_yourself.dart';
import 'package:thirdeye/services/auth_manager.dart';
import 'package:thirdeye/sharable_widget/index.dart';
import 'package:thirdeye/config/app_theme.dart';
import 'package:thirdeye/sharable_widget/snack_bar.dart';

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
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: LoadingOverlay(
        isLoading: isLoading,
        loadingText: "Verifying your code...",
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingXL,
              vertical: AppTheme.spacingXXL,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInDown(
                  duration: AppTheme.animationSlow,
                  child: Center(
                    child: Text(
                      "Verify Account",
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXL),
                FadeInUp(
                  duration: AppTheme.animationMedium,
                  delay: const Duration(milliseconds: 200),
                  child: Center(
                    child: Text(
                      "Code has been sent to $_email",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingL),
                FadeInUp(
                  duration: AppTheme.animationMedium,
                  delay: const Duration(milliseconds: 400),
                  child: Center(
                    child: Text(
                      "Enter the code to verify your account",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXL),
                FadeInUp(
                  duration: AppTheme.animationMedium,
                  delay: const Duration(milliseconds: 600),
                  child: Text(
                    "Enter Verification Code",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingM),
                FadeInUp(
                  duration: AppTheme.animationMedium,
                  delay: const Duration(milliseconds: 800),
                  child: EnhancedInputField(
                    controller: _otpController,
                    hint: "Enter 6-digit code",
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    onChanged: (value) => print('OTP: $value'),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingL),

                // Resend Code Section
                FadeInUp(
                  duration: AppTheme.animationMedium,
                  delay: const Duration(milliseconds: 1000),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "Didn't receive Code?",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                        ),
                        const SizedBox(height: AppTheme.spacingS),
                        TextButton(
                          onPressed: _canResend ? _resendOtp : null,
                          style: TextButton.styleFrom(
                            foregroundColor: _canResend
                                ? AppTheme.primaryColor
                                : AppTheme.textTertiary,
                          ),
                          child: Text(
                            _canResend
                                ? "Resend Code"
                                : "Resend in ${_secondsRemaining}s",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppTheme.spacingXXL),

                // Verify Button
                FadeInUp(
                  duration: AppTheme.animationMedium,
                  delay: const Duration(milliseconds: 1200),
                  child: PrimaryButton(
                    text: "Verify Code",
                    icon: const Icon(Icons.verified_user),
                    onPressed: _verifyOtp,
                    isFullWidth: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
