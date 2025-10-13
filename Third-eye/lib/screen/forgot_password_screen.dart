import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:thirdeye/repositories/sign_up_repository.dart';
import 'package:thirdeye/screen/reset_otp_verification.dart';
import 'package:thirdeye/sharable_widget/index.dart';
import 'package:thirdeye/config/app_theme.dart';

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
      FeedbackSystem.showErrorSnackBar(context,
          message: "Please enter your email");
      return;
    }
    setState(() => isLoading = true);
    final success = await repo.sendOtp(_emailController.text, "reset");
    setState(() => isLoading = false);

    if (success && mounted) {
      FeedbackSystem.showSuccessSnackBar(context,
          message: "OTP sent successfully!");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ResetOtpVerificationScreen(email: _emailController.text),
        ),
      );
    } else {
      FeedbackSystem.showErrorSnackBar(context, message: "Failed to send OTP");
    }
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
        title: Text(
          "Forgot Password",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: LoadingOverlay(
        isLoading: isLoading,
        loadingText: "Sending OTP...",
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppTheme.spacingXL),
              FadeInDown(
                duration: AppTheme.animationSlow,
                child: Text(
                  "Reset Password",
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),
              FadeInDown(
                duration: AppTheme.animationSlow,
                delay: const Duration(milliseconds: 200),
                child: Text(
                  "Enter your email address and we'll send you a code to reset your password.",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingXXL),
              FadeInUp(
                duration: AppTheme.animationMedium,
                delay: const Duration(milliseconds: 400),
                child: EmailInputField(
                  controller: _emailController,
                  hint: "johndoe@gmail.com",
                  onChanged: (value) => print('Email: $value'),
                ),
              ),
              const SizedBox(height: AppTheme.spacingXL),
              FadeInUp(
                duration: AppTheme.animationMedium,
                delay: const Duration(milliseconds: 600),
                child: PrimaryButton(
                  text: "Send OTP",
                  icon: const Icon(Icons.email),
                  onPressed: _sendOtp,
                  isFullWidth: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
