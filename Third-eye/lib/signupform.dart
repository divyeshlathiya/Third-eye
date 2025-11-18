// import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';
// import 'package:animate_do/animate_do.dart';
// import 'package:thirdeye/Menu/PrivacyPolicyScreen.dart';
// import 'package:thirdeye/Menu/terms_condition.dart';
// import 'package:thirdeye/models/User.dart';
// import 'package:thirdeye/repositories/sign_up_repository.dart';
// import 'package:thirdeye/screen/otp_verfication_screen.dart';
// import 'package:thirdeye/sharable_widget/back_btn.dart';
// import 'package:thirdeye/sharable_widget/snack_bar.dart';
// import 'package:thirdeye/sharable_widget/index.dart';
// import 'package:thirdeye/config/app_theme.dart';

// class Signupform extends StatefulWidget {
//   const Signupform({super.key});

//   @override
//   State<Signupform> createState() => _SignupformState();
// }

// class _SignupformState extends State<Signupform> {
//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool isLoading = false;

//   void _createAccount() async {
//     String firstName = _firstNameController.text.trim();
//     String lastName = _lastNameController.text.trim();
//     String email = _emailController.text.trim();
//     String password = _passwordController.text.trim();
//     final repository = SignUpRepository();

//     if (isNotEmpty(firstName, lastName, email, password)) {
//       setState(() => isLoading = true);

//       User newUser = User(
//         firstName: firstName,
//         lastName: lastName,
//         email: email,
//         password: password,
//       );

//       try {
//         final otpResult = await repository.sendOtp(email, "signup");

//         if (!mounted) return;
//         setState(() => isLoading = false);

//         if (otpResult["success"] == true) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => OtpVerificationScreen(
//                 email: email,
//                 user: newUser,
//               ),
//             ),
//           );

//           CustomSnackBar.showCustomSnackBar(context, "OTP sent successfully");

//           _firstNameController.clear();
//           _lastNameController.clear();
//           _emailController.clear();
//           _passwordController.clear();
//         } else {
//           // Handle error cases including 404 (user already registered)
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(otpResult["message"] ??
//                   "Account already registered with this email"),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       } catch (e) {
//         setState(() => isLoading = false);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please fill all fields'),
//           backgroundColor: Colors.deepPurple,
//         ),
//       );
//     }
//   }

//   Widget _termsAndConditionsWidget() {
//     return Center(
//       child: Text.rich(
//           TextSpan(
//             text: 'By continuing, you agree to our ',
//             children: [
//               TextSpan(
//                 text: 'Terms of Service',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blueAccent,
//                 ),
//                 recognizer: TapGestureRecognizer()
//                   ..onTap = () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const TermsScreen()),
//                     );
//                   },
//               ),
//               const TextSpan(text: ' and '),
//               TextSpan(
//                 text: 'Privacy Policy.',
//                 style: const TextStyle(
//                   color: Colors.blue,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 recognizer: TapGestureRecognizer()
//                   ..onTap = () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const PrivacyPolicyScreen()),
//                     );
//                   },
//               ),
//             ],
//           ),
//           textAlign: TextAlign.center),
//     );
//   }

//   bool isNotEmpty(String firstName, String lastName, String email, String pwd) {
//     return (firstName.isNotEmpty &&
//             lastName.isNotEmpty &&
//             email.isNotEmpty &&
//             pwd.isNotEmpty)
//         ? true
//         : false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.backgroundColor,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: MyBackButton(),
//       ),
//       resizeToAvoidBottomInset: true,
//       body: LoadingOverlay(
//         isLoading: isLoading,
//         loadingText: "Creating your account...",
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: AppTheme.spacingXL),
//                 FadeInDown(
//                   duration: AppTheme.animationSlow,
//                   child: Center(
//                     child: Text(
//                       "Create Account",
//                       style:
//                           Theme.of(context).textTheme.displayMedium?.copyWith(
//                                 fontWeight: FontWeight.bold,
//                                 color: AppTheme.textPrimary,
//                               ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: AppTheme.spacingS),
//                 FadeInDown(
//                   duration: AppTheme.animationSlow,
//                   delay: const Duration(milliseconds: 200),
//                   child: Center(
//                     child: Text(
//                       "Join us and start your wellness journey",
//                       style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                             color: AppTheme.textSecondary,
//                           ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: AppTheme.spacingXXL),

//                 // Name Fields
//                 FadeInUp(
//                   duration: AppTheme.animationMedium,
//                   delay: const Duration(milliseconds: 400),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: EnhancedInputField(
//                           label: "First Name",
//                           hint: "John",
//                           controller: _firstNameController,
//                           onChanged: (value) => print('First Name: $value'),
//                         ),
//                       ),
//                       const SizedBox(width: AppTheme.spacingM),
//                       Expanded(
//                         child: EnhancedInputField(
//                           label: "Last Name",
//                           hint: "Doe",
//                           controller: _lastNameController,
//                           onChanged: (value) => print('Last Name: $value'),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: AppTheme.spacingM),

//                 // Email Field
//                 FadeInUp(
//                   duration: AppTheme.animationMedium,
//                   delay: const Duration(milliseconds: 600),
//                   child: EmailInputField(
//                     controller: _emailController,
//                     onChanged: (value) => print('Email: $value'),
//                   ),
//                 ),

//                 const SizedBox(height: AppTheme.spacingM),

//                 // Password Field
//                 FadeInUp(
//                   duration: AppTheme.animationMedium,
//                   delay: const Duration(milliseconds: 800),
//                   child: PasswordInputField(
//                     controller: _passwordController,
//                     onChanged: (value) => print('Password: $value'),
//                   ),
//                 ),

//                 const SizedBox(height: AppTheme.spacingS),

//                 // Password Requirements
//                 FadeInUp(
//                   duration: AppTheme.animationMedium,
//                   delay: const Duration(milliseconds: 1000),
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       "Password must contain at least 8 characters",
//                       style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                             color: AppTheme.textTertiary,
//                           ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: AppTheme.spacingXL),

//                 // Create Account Button
//                 FadeInUp(
//                   duration: AppTheme.animationMedium,
//                   delay: const Duration(milliseconds: 1200),
//                   child: PrimaryButton(
//                     text: "Create Account",
//                     icon: const Icon(
//                       Icons.person_add,
//                       color: Colors.white,
//                     ),
//                     onPressed: _createAccount,
//                     isFullWidth: true,
//                   ),
//                 ),

//                 const SizedBox(height: AppTheme.spacingL),

//                 // Terms and Conditions
//                 FadeInUp(
//                   duration: AppTheme.animationMedium,
//                   delay: const Duration(milliseconds: 1400),
//                   child: _termsAndConditionsWidget(),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:animate_do/animate_do.dart';
import 'package:thirdeye/Menu/PrivacyPolicyScreen.dart';
import 'package:thirdeye/Menu/terms_condition.dart';
import 'package:thirdeye/models/User.dart';
import 'package:thirdeye/repositories/sign_up_repository.dart';
import 'package:thirdeye/screen/otp_verfication_screen.dart';
import 'package:thirdeye/sharable_widget/back_btn.dart';
import 'package:thirdeye/sharable_widget/snack_bar.dart';
import 'package:thirdeye/sharable_widget/index.dart';
import 'package:thirdeye/config/app_theme.dart';
import 'package:thirdeye/utils/validate_helper.dart'; // Import the validator

class Signupform extends StatefulWidget {
  const Signupform({super.key});

  @override
  State<Signupform> createState() => _SignupformState();
}

class _SignupformState extends State<Signupform> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Add form key
  bool isLoading = false;
  bool _obscurePassword = true;

  void _createAccount() async {
    // Validate form first
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    final repository = SignUpRepository();

    setState(() => isLoading = true);

    User newUser = User(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );

    try {
      final otpResult = await repository.sendOtp(email, "signup");

      if (!mounted) return;
      setState(() => isLoading = false);

      if (otpResult["success"] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
              email: email,
              user: newUser,
            ),
          ),
        );

        CustomSnackBar.showCustomSnackBar(context, "OTP sent successfully");

        _firstNameController.clear();
        _lastNameController.clear();
        _emailController.clear();
        _passwordController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(otpResult["message"] ?? "Account already registered with this email"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Real-time validation feedback
  void _updateValidationState() { 
    if (_formKey.currentState != null) {
      _formKey.currentState!.validate();
    }
  }

  Widget _termsAndConditionsWidget() {
    return Center(
      child: Text.rich(
        TextSpan(
          text: 'By continuing, you agree to our ',
          children: [
            TextSpan(
              text: 'Terms of Service',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TermsScreen()),
                  );
                },
            ),
            const TextSpan(text: ' and '),
            TextSpan(
              text: 'Privacy Policy.',
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                  );
                },
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: MyBackButton(),
      ),
      resizeToAvoidBottomInset: true,
      body: LoadingOverlay(
        isLoading: isLoading,
        loadingText: "Creating your account...",
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
            child: Form(
              key: _formKey, // Add Form widget
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppTheme.spacingXL),
                  FadeInDown(
                    duration: AppTheme.animationSlow,
                    child: Center(
                      child: Text(
                        "Create Account",
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  FadeInDown(
                    duration: AppTheme.animationSlow,
                    delay: const Duration(milliseconds: 200),
                    child: Center(
                      child: Text(
                        "Join us and start your wellness journey",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXXL),

                  // Name Fields
                  FadeInUp(
                    duration: AppTheme.animationMedium,
                    delay: const Duration(milliseconds: 400),
                    child: Row(
                      children: [
                        Expanded(
                          child: EnhancedInputField(
                            label: "First Name",
                            hint: "John",
                            controller: _firstNameController,
                            onChanged: (value) => _updateValidationState(),
                            validator: (value) => Validator.validateName(value, "First Name"),
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacingM),
                        Expanded(
                          child: EnhancedInputField(
                            label: "Last Name",
                            hint: "Doe",
                            controller: _lastNameController,
                            onChanged: (value) => _updateValidationState(),
                            validator: (value) => Validator.validateName(value, "Last Name"),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingM),

                  // Email Field
                  FadeInUp(
                    duration: AppTheme.animationMedium,
                    delay: const Duration(milliseconds: 600),
                    child: EnhancedInputField(
                      label: "Email",
                      hint: "your@email.com",
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) => _updateValidationState(),
                      validator: Validator.validateEmail,
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingM),

                  // Password Field
                  FadeInUp(
                    duration: AppTheme.animationMedium,
                    delay: const Duration(milliseconds: 800),
                    child: EnhancedInputField(
                      label: "Password",
                      hint: "Enter your password",
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      onChanged: (value) => _updateValidationState(),
                      validator: Validator.validatePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          color: AppTheme.textTertiary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingS),

                  // Password Requirements
                  FadeInUp(
                    duration: AppTheme.animationMedium,
                    delay: const Duration(milliseconds: 1000),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPasswordRequirement("At least 8 characters", _passwordController.text.length >= 8),
                        _buildPasswordRequirement("One uppercase letter", _passwordController.text.contains(RegExp(r'[A-Z]'))),
                        _buildPasswordRequirement("One lowercase letter", _passwordController.text.contains(RegExp(r'[a-z]'))),
                        _buildPasswordRequirement("One number", _passwordController.text.contains(RegExp(r'[0-9]'))),
                        _buildPasswordRequirement("One special character", _passwordController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingXL),

                  // Create Account Button
                  FadeInUp(
                    duration: AppTheme.animationMedium,
                    delay: const Duration(milliseconds: 1200),
                    child: PrimaryButton(
                      text: "Create Account",
                      icon: const Icon(
                        Icons.person_add,
                        color: Colors.white,
                      ),
                      onPressed: _createAccount,
                      isFullWidth: true,
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingL),

                  // Terms and Conditions
                  FadeInUp(
                    duration: AppTheme.animationMedium,
                    delay: const Duration(milliseconds: 1400),
                    child: _termsAndConditionsWidget(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordRequirement(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: isMet ? Colors.green : AppTheme.textTertiary,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isMet ? Colors.green : AppTheme.textTertiary,
                ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}