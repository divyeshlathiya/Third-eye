import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:thirdeye/repositories/sign_up_repository.dart';
import 'package:thirdeye/screen/reset_otp_verification.dart';
import 'package:thirdeye/sharable_widget/index.dart';
import 'package:thirdeye/config/app_theme.dart';
import 'package:thirdeye/utils/validate_helper.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Add form key
  bool isLoading = false;
  final repo = SignUpRepository();

  Future<void> _sendOtp() async {
    // Validate form first
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim();

    setState(() => isLoading = true);
    final success = await repo.sendOtp(email, "reset");
    setState(() => isLoading = false);

    FocusManager.instance.primaryFocus?.unfocus();

    if (success["success"] == true && mounted) {
      FeedbackSystem.showSuccessSnackBar(
        context,
        message: "OTP sent successfully!",
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResetOtpVerificationScreen(email: email),
        ),
      );
    } else {
      FeedbackSystem.showErrorSnackBar(
        context,
        message: success["message"] ?? "Oops! Account not found",
      );
    }
  }

  // Real-time validation feedback
  void _updateValidationState() {
    if (_formKey.currentState != null) {
      _formKey.currentState!.validate();
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
      // Use a Stack so we can overlay a centered loader
      body: Stack(
        children: [
          // ---- Main UI ----
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppTheme.spacingXL),
                    FadeInDown(
                      duration: AppTheme.animationSlow,
                      child: Text(
                        "Reset Password",
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    FadeInDown(
                      duration: AppTheme.animationSlow,
                      delay: Duration(milliseconds: 200),
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
                      delay: Duration(milliseconds: 400),
                      child: EmailInputField(
                        controller: _emailController,
                        hint: "johndoe@gmail.com",
                        onChanged: (value) {
                          _updateValidationState();
                        },
                        validator: Validator.validateEmail,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                    FadeInUp(
                      duration: AppTheme.animationMedium,
                      delay: Duration(milliseconds: 500),
                      child: Padding(
                        padding: const EdgeInsets.only(left: AppTheme.spacingS),
                        child: Text(
                          "We'll send a verification code to this email",
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textTertiary,
                                    fontStyle: FontStyle.italic,
                                  ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXL),
                    FadeInUp(
                      duration: AppTheme.animationMedium,
                      delay: Duration(milliseconds: 600),
                      child: PrimaryButton(
                        text: isLoading ? "Sending..." : "Send OTP",
                        icon: isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Icon(Icons.email, color: Colors.white),
                        onPressed: isLoading
                            ? null
                            : _sendOtp, // disable button while loading
                        isFullWidth: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
