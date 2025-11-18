// import 'package:flutter/material.dart';
// import 'package:thirdeye/sharable_widget/back_btn.dart';
// import 'package:thirdeye/sharable_widget/pwd_txt_feild.dart';
// import 'package:thirdeye/sharable_widget/snack_bar.dart';
// import '../../repositories/sign_up_repository.dart';

// class ResetPasswordScreen extends StatefulWidget {
//   final String email; // we need email from previous screen
//   const ResetPasswordScreen({super.key, required this.email});

//   @override
//   State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
// }

// class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
//   final TextEditingController _resetpassController = TextEditingController();
//   final TextEditingController _confirmpassController = TextEditingController();
//   bool isLoading = false;
//   final repo = SignUpRepository();

//   Future<void> _resetPassword() async {
//     final newPass = _resetpassController.text.trim();
//     final confirmPass = _confirmpassController.text.trim();

//     if (newPass.isEmpty || confirmPass.isEmpty) {
//       CustomSnackBar.showCustomSnackBar(context, "Please fill all fields");
//       return;
//     }

//     if (newPass != confirmPass) {
//       CustomSnackBar.showCustomSnackBar(context, "Passwords do not match");
//       return;
//     }

//     if (newPass.length < 8) {
//       CustomSnackBar.showCustomSnackBar(
//           context, "Password must be at least 8 characters");
//       return;
//     }

//     FocusManager.instance.primaryFocus?.unfocus();

//     setState(() => isLoading = true);
//     final success = await repo.resetPassword(widget.email, newPass);
//     setState(() => isLoading = false);

//     if (success["success"] && mounted) {
//       Navigator.popUntil(context, (route) => route.isFirst);
//       CustomSnackBar.showCustomSnackBar(context, "Password reset successful");
//     } else {
//       if (!mounted) return;
//       CustomSnackBar.showCustomSnackBar(context, "Failed to reset password");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: MyBackButton(),
//         title: const Text("Reset Password"),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text('New Password',
//                   style: TextStyle(fontWeight: FontWeight.bold)),
//               const SizedBox(height: 8),
//               CustomPasswordTextFeild(
//                   controller: _resetpassController, hintText: "**********"),
//               const SizedBox(height: 6),
//               const Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text("Must contain at least 8 characters",
//                     style: TextStyle(color: Colors.grey)),
//               ),
//               const SizedBox(height: 20),
//               const Text('Confirm Password',
//                   style: TextStyle(fontWeight: FontWeight.bold)),
//               const SizedBox(height: 8),
//               CustomPasswordTextFeild(
//                   controller: _confirmpassController, hintText: "**********",),
//               const SizedBox(height: 6),
//               const Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text("Must match the new password",
//                     style: TextStyle(color: Colors.grey)),
//               ),
//               const SizedBox(height: 30),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: isLoading ? null : _resetPassword,
//                   child: isLoading
//                       ? const CircularProgressIndicator()
//                       : const Text("Submit"),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:thirdeye/sharable_widget/back_btn.dart';
import 'package:thirdeye/sharable_widget/snack_bar.dart';
import 'package:thirdeye/utils/validate_helper.dart';
import '../../repositories/sign_up_repository.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _resetpassController = TextEditingController();
  final TextEditingController _confirmpassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  final repo = SignUpRepository();

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final newPass = _resetpassController.text.trim();
    final confirmPass = _confirmpassController.text.trim();

    if (newPass != confirmPass) {
      CustomSnackBar.showCustomSnackBar(context, "Passwords do not match");
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    setState(() => isLoading = true);
    final success = await repo.resetPassword(widget.email, newPass);
    setState(() => isLoading = false);

    if (success["success"] && mounted) {
      Navigator.popUntil(context, (route) => route.isFirst);
      CustomSnackBar.showCustomSnackBar(context, "Password reset successful");
    } else {
      if (!mounted) return;
      CustomSnackBar.showCustomSnackBar(
          context, success["message"] ?? "Failed to reset password");
    }
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != _resetpassController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: MyBackButton(),
        title: const Text("Reset Password"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // New Password Field
                const Text(
                  'New Password',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _resetpassController,
                  obscureText: _obscureNewPassword,
                  validator: Validator.validatePassword,
                  decoration: InputDecoration(
                    hintText: "**********",
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNewPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Must contain at least 8 characters with uppercase, lowercase, number & special character",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 20),

                // Confirm Password Field
                const Text(
                  'Confirm Password',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmpassController,
                  obscureText: _obscureConfirmPassword,
                  validator: _validateConfirmPassword,
                  decoration: InputDecoration(
                    hintText: "**********",
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Must match the new password",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 30),

                // Submit Button
                Center(
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _resetPassword,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            "Reset Password",
                            style: TextStyle(fontSize: 16),
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

  @override
  void dispose() {
    _resetpassController.dispose();
    _confirmpassController.dispose();
    super.dispose();
  }
}
