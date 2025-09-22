import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:animate_do/animate_do.dart';
import 'package:thirdeye/models/User.dart';
import 'package:thirdeye/repositories/sign_up_repository.dart';
import 'package:thirdeye/screen/otp_verfication_screen.dart';
import 'package:thirdeye/sharable_widget/back_btn.dart';
import 'package:thirdeye/sharable_widget/snack_bar.dart';
import 'package:thirdeye/sharable_widget/index.dart';
import 'package:thirdeye/config/app_theme.dart';

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
  bool isLoading = false;

  void _createAccount() async {
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    final repository = SignUpRepository();

    if (isNotEmpty(firstName, lastName, email, password)) {
      setState(() => isLoading = true); // show loader

      User newUser = User(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );

      try {
        bool otpSent = await repository.sendOtp(email, "signup");

        if (!mounted) return;
        setState(() => isLoading = false); // hide loader

        if (otpSent) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationScreen(
                email: email,
                user: newUser,
              ),
            ),
          );

          CustomSnackBar.showCustomSnackBar(context, "Otp sent successfully");

          _firstNameController.clear();
          _lastNameController.clear();
          _emailController.clear();
          _passwordController.clear();
        }
      } catch (e) {
        setState(() => isLoading = false); // hide loader
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.deepPurple,
        ),
      );
    }
  }

  Widget _createAccountBtn() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : _createAccount,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          backgroundColor: const Color(0xFF362491), // Purpl  e shade
        ),
        child: isLoading
            ? SizedBox(
                width: 20, height: 20, child: CircularProgressIndicator())
            : const Text(
                "Create Account",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
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
                recognizer: TapGestureRecognizer()..onTap = () {},
              ),
              const TextSpan(text: ' and '),
              TextSpan(
                text: 'Privacy Policy.',
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()..onTap = () {},
              ),
            ],
          ),
          textAlign: TextAlign.center),
    );
  }

  bool isNotEmpty(String firstName, String lastName, String email, String pwd) {
    return (firstName.isNotEmpty &&
            lastName.isNotEmpty &&
            email.isNotEmpty &&
            pwd.isNotEmpty)
        ? true
        : false;
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppTheme.spacingXL),
                FadeInDown(
                  duration: AppTheme.animationSlow,
                  child: Center(
                    child: Text(
                      "Create Account",
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
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
                          onChanged: (value) => print('First Name: $value'),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingM),
                      Expanded(
                        child: EnhancedInputField(
                          label: "Last Name",
                          hint: "Doe",
                          controller: _lastNameController,
                          onChanged: (value) => print('Last Name: $value'),
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
                  child: EmailInputField(
                    controller: _emailController,
                    onChanged: (value) => print('Email: $value'),
                  ),
                ),

                const SizedBox(height: AppTheme.spacingM),

                // Password Field
                FadeInUp(
                  duration: AppTheme.animationMedium,
                  delay: const Duration(milliseconds: 800),
                  child: PasswordInputField(
                    controller: _passwordController,
                    onChanged: (value) => print('Password: $value'),
                  ),
                ),

                const SizedBox(height: AppTheme.spacingS),

                // Password Requirements
                FadeInUp(
                  duration: AppTheme.animationMedium,
                  delay: const Duration(milliseconds: 1000),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Password must contain at least 8 characters",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textTertiary,
                          ),
                    ),
                  ),
                ),

                const SizedBox(height: AppTheme.spacingXL),

                // Create Account Button
                FadeInUp(
                  duration: AppTheme.animationMedium,
                  delay: const Duration(milliseconds: 1200),
                  child: PrimaryButton(
                    text: "Create Account",
                    icon: Icons.person_add,
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
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:thirdeye/models/User.dart';
// import 'package:thirdeye/screen/otp_verfication_screen.dart';
// import 'package:thirdeye/sharable_widget/back_btn.dart';
// import 'package:thirdeye/sharable_widget/pwd_txt_feild.dart';
// import 'package:thirdeye/sharable_widget/text_feild.dart';
// import 'package:thirdeye/services/auth_manager.dart';

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

//   final AuthManager _authManager = AuthManager();

//   void _createAccount() async {
//     final firstName = _firstNameController.text;
//     final lastName = _lastNameController.text;
//     final email = _emailController.text;
//     final password = _passwordController.text;

//     if (firstName.isEmpty ||
//         lastName.isEmpty ||
//         email.isEmpty ||
//         password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text("Please fill all fields"),
//             backgroundColor: Colors.red),
//       );
//       return;
//     }

//     setState(() => isLoading = true);

//     final userData = await _authManager.signUpUser({
//       "firstName": firstName,
//       "lastName": lastName,
//       "email": email,
//       "password": password,
//     });

//     setState(() => isLoading = false);

//     if (userData != null) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => OtpVerificationScreen(
//             email: email,
//             user: User(
//               firstName: firstName,
//               lastName: lastName,
//               email: email,
//               password: password,
//             ),
//           ),
//         ),
//       );
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text("Otp sent successfully"), backgroundColor: Colors.green),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Signup failed"), backgroundColor: Colors.red),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(leading: MyBackButton()),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//         child: Column(
//           children: [
//             const Center(
//                 child: Text("Signup",
//                     style:
//                         TextStyle(fontSize: 32, fontWeight: FontWeight.bold))),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 Expanded(
//                     child: MyTextFeild(
//                         controller: _firstNameController,
//                         hintText: "John",
//                         labelText: "First name")),
//                 const SizedBox(width: 10),
//                 Expanded(
//                     child: MyTextFeild(
//                         controller: _lastNameController,
//                         hintText: "Doe",
//                         labelText: "Last name")),
//               ],
//             ),
//             const SizedBox(height: 20),
//             MyTextFeild(
//               controller: _emailController,
//               hintText: "Enter your email",
//               labelText: "Email",
//             ),
//             const SizedBox(height: 20),
//             CustomPasswordTextFeild(
//               controller: _passwordController,
//               hintText: "***********",
//             ),
//             const SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: isLoading ? null : _createAccount,
//               child: isLoading
//                   ? const CircularProgressIndicator()
//                   : const Text("Create Account"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
