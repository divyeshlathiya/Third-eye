// import 'package:flutter/material.dart';
// import 'package:animate_do/animate_do.dart';
// // import 'package:thirdeye/screen/about_yourself.dart';
// import 'package:thirdeye/screen/dashboard/dashboard.dart';
// import 'package:thirdeye/screen/forgot_password_screen.dart';
// import 'package:thirdeye/sharable_widget/snack_bar.dart';
// import 'package:thirdeye/sharable_widget/index.dart';
// import 'package:thirdeye/services/auth_manager.dart';
// import 'package:thirdeye/config/app_theme.dart';

// class Loginform extends StatefulWidget {
//   const Loginform({super.key});

//   @override
//   State<Loginform> createState() => _LoginformState();
// }

// class _LoginformState extends State<Loginform> {
//   final TextEditingController _email = TextEditingController();
//   final TextEditingController _password = TextEditingController();
//   bool isLoading = false;

//   final AuthManager _authManager = AuthManager();

//   void login() async {
//     final email = _email.text;
//     final pwd = _password.text;

//     if (email.isEmpty || pwd.isEmpty) {
//       CustomSnackBar.showCustomSnackBar(
//         context,
//         "Please fill in both fields",
//         backgroundColor: Colors.red,
//       );
//       return;
//     }

//     setState(() => isLoading = true);

//     try {
//       // _authManager.login throws error message if login fails
//       final success = await _authManager.login(email, pwd);
//       setState(() => isLoading = false);

//       if (!mounted) return;

//       if (success) {
//         final profile = await _authManager.getProfile();
//         final firstName = profile?['first_name'] ?? "User";
//         final dob = profile?['dob'];
//         final gender = profile?['gender'];

//         // Keep your existing navigation logic
//         if (dob == null || gender == null) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => DashboardScreen()),
//           );
//         } else {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => const DashboardScreen()),
//           );
//         }

//         CustomSnackBar.showCustomSnackBar(
//           context,
//           "Welcome $firstName",
//           backgroundColor: Colors.purple,
//         );
//       }
//     } catch (errorMessage) {
//       setState(() => isLoading = false);

//       // Show API/network error in SnackBar
//       CustomSnackBar.showCustomSnackBar(
//         context,
//         errorMessage.toString(),
//         backgroundColor: Colors.red,
//       );
//     }
//   }

//   Widget customLoader() => LoadingOverlay(
//         isLoading: isLoading,
//         loadingText: "Signing you in...",
//         child: const SizedBox.shrink(),
//       );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.backgroundColor,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           padding: EdgeInsets.zero,
//           constraints: const BoxConstraints(),
//           onPressed: () => Navigator.pop(context),
//           icon: Icon(Icons.arrow_back, color: AppTheme.textPrimary),
//         ),
//       ),
//       body: LoadingOverlay(
//         isLoading: isLoading,
//         loadingText: "Signing you in...",
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(AppTheme.spacingL),
//           child: Column(
//             children: [
//               const SizedBox(height: AppTheme.spacingXL),
//               FadeInDown(
//                 duration: AppTheme.animationSlow,
//                 child: Center(
//                   child: Text(
//                     "Welcome Back",
//                     style: Theme.of(context).textTheme.displayMedium?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           color: AppTheme.textPrimary,
//                         ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: AppTheme.spacingS),
//               FadeInDown(
//                 duration: AppTheme.animationSlow,
//                 delay: const Duration(milliseconds: 200),
//                 child: Center(
//                   child: Text(
//                     "Sign in to continue your wellness journey",
//                     style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                           color: AppTheme.textSecondary,
//                         ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: AppTheme.spacingXXL),

//               // Email Input
//               FadeInUp(
//                 duration: AppTheme.animationMedium,
//                 delay: const Duration(milliseconds: 400),
//                 child: EmailInputField(
//                   controller: _email,
//                   onChanged: (value) => print('Email: $value'),
//                 ),
//               ),

//               const SizedBox(height: AppTheme.spacingM),

//               // Password Input
//               FadeInUp(
//                 duration: AppTheme.animationMedium,
//                 delay: const Duration(milliseconds: 600),
//                 child: PasswordInputField(
//                   controller: _password,
//                   onChanged: (value) => print('Password: $value'),
//                 ),
//               ),

//               const SizedBox(height: AppTheme.spacingL),

//               // Login Button
//               FadeInUp(
//                 duration: AppTheme.animationMedium,
//                 delay: const Duration(milliseconds: 800),
//                 child: PrimaryButton(
//                   text: "Sign In",
//                   icon: Icon(
//                     Icons.login,
//                     color: Colors.white,
//                   ),
//                   onPressed: login,
//                   isFullWidth: true,
//                 ),
//               ),

//               const SizedBox(height: AppTheme.spacingM),

//               // Forgot Password
//               FadeInUp(
//                 duration: AppTheme.animationMedium,
//                 delay: const Duration(milliseconds: 1000),
//                 child: TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const ForgotPasswordScreen(),
//                       ),
//                     );
//                   },
//                   child: Text(
//                     "Forgot Password?",
//                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                           color: AppTheme.primaryColor,
//                           fontWeight: FontWeight.w600,
//                         ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
// import 'package:thirdeye/screen/about_yourself.dart';
import 'package:thirdeye/screen/dashboard/dashboard.dart';
import 'package:thirdeye/screen/forgot_password_screen.dart';
import 'package:thirdeye/sharable_widget/snack_bar.dart';
import 'package:thirdeye/sharable_widget/index.dart';
import 'package:thirdeye/services/auth_manager.dart';
import 'package:thirdeye/config/app_theme.dart';
import 'package:thirdeye/utils/validate_helper.dart';

class Loginform extends StatefulWidget {
  const Loginform({super.key});

  @override
  State<Loginform> createState() => _LoginformState();
}

class _LoginformState extends State<Loginform> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Add form key
  bool isLoading = false;

  final AuthManager _authManager = AuthManager();

  void login() async {
    // Validate form first
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _email.text.trim();
    final pwd = _password.text.trim();

    if (email.isEmpty || pwd.isEmpty) {
      CustomSnackBar.showCustomSnackBar(context, "Plz fill both feilds");
      return;
    }

    setState(() => isLoading = true);

    try {
      // _authManager.login throws error message if login fails
      final success = await _authManager.login(email, pwd);
      setState(() => isLoading = false);

      if (!mounted) return;

      if (success) {
        final profile = await _authManager.getProfile();
        final firstName = profile?['first_name'] ?? "User";
        final dob = profile?['dob'];
        final gender = profile?['gender'];

        // Keep your existing navigation logic
        if (dob == null || gender == null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => DashboardScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
          );
        }

        CustomSnackBar.showCustomSnackBar(
          context,
          "Welcome $firstName",
          backgroundColor: Colors.purple,
        );
      }
    } catch (errorMessage) {
      setState(() => isLoading = false);

      // Show API/network error in SnackBar
      CustomSnackBar.showCustomSnackBar(
        context,
        errorMessage.toString(),
        backgroundColor: Colors.red,
      );
    }
  }

  // Real-time validation feedback
  void _updateValidationState() {
    if (_formKey.currentState != null) {
      _formKey.currentState!.validate();
    }
  }

  Widget customLoader() => LoadingOverlay(
        isLoading: isLoading,
        loadingText: "Signing you in...",
        child: const SizedBox.shrink(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: AppTheme.textPrimary),
        ),
      ),
      body: LoadingOverlay(
        isLoading: isLoading,
        loadingText: "Signing you in...",
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Form(
            key: _formKey, // Add Form widget
            child: Column(
              children: [
                const SizedBox(height: AppTheme.spacingXL),
                FadeInDown(
                  duration: AppTheme.animationSlow,
                  child: Center(
                    child: Text(
                      "Welcome Back",
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
                      "Sign in to continue your wellness journey",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXXL),

                // Email Input
                FadeInUp(
                  duration: AppTheme.animationMedium,
                  delay: const Duration(milliseconds: 400),
                  child: EmailInputField(
                    controller: _email,
                    onChanged: (value) {
                      print('Email: $value');
                      _updateValidationState(); // Add real-time validation
                    },
                    validator: Validator.validateEmail, // Add email validator
                  ),
                ),

                const SizedBox(height: AppTheme.spacingM),

                // Password Input
                FadeInUp(
                  duration: AppTheme.animationMedium,
                  delay: const Duration(milliseconds: 600),
                  child: PasswordInputField(
                    controller: _password,
                    onChanged: (value) => print('Password: $value'),
                    // Optional: Add password validator if needed
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Password is required';
                    //   }
                    //   return null;
                    // },
                  ),
                ),

                const SizedBox(height: AppTheme.spacingL),

                // Login Button
                FadeInUp(
                  duration: AppTheme.animationMedium,
                  delay: const Duration(milliseconds: 800),
                  child: PrimaryButton(
                    text: "Sign In",
                    icon: Icon(
                      Icons.login,
                      color: Colors.white,
                    ),
                    onPressed: login,
                    isFullWidth: true,
                  ),
                ),

                const SizedBox(height: AppTheme.spacingM),

                // Forgot Password
                FadeInUp(
                  duration: AppTheme.animationMedium,
                  delay: const Duration(milliseconds: 1000),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Forgot Password?",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
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
