import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:thirdeye/models/User.dart';
import 'package:thirdeye/repositories/sign_up_repository.dart';
import 'package:thirdeye/screen/otp_verfication_screen.dart';
import 'package:thirdeye/sharable_widget/back_btn.dart';
import 'package:thirdeye/sharable_widget/pwd_txt_feild.dart';
import 'package:thirdeye/sharable_widget/text_feild.dart';

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

  // void _createAccount() async {
  //   String firstName = _firstNameController.text;
  //   String lastName = _lastNameController.text;
  //   String email = _emailController.text;
  //   String password = _passwordController.text;
  //   final repository = SignUpRepository();

  //   if (isNotEmpty(firstName, lastName, email, password)) {
  //     setState(() => isLoading = true);
  //     User newUser = User(
  //         firstName: firstName,
  //         lastName: lastName,
  //         email: email,
  //         password: password);
  //     bool otpSent = await repository.sendOtp(email);
  //     setState(() => isLoading = false);
  //     if (!mounted) return;
  //     if (otpSent) {
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => OtpVerificationScreen(
  //               email: email,
  //               user: newUser,
  //             ),
  //           ));
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           clipBehavior: Clip.antiAlias,
  //           behavior: SnackBarBehavior.floating,
  //           content: Text('Otp sent successfully'),
  //           backgroundColor: Colors.deepPurple,
  //         ),
  //       );
  //       _firstNameController.clear();
  //       _lastNameController.clear();
  //       _emailController.clear();
  //       _passwordController.clear();
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Please fill all fields'),
  //         backgroundColor: Colors.deepPurple,
  //       ),
  //     );
  //   }
  // }

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

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              clipBehavior: Clip.antiAlias,
              behavior: SnackBarBehavior.floating,
              content: Text('Otp sent successfully'),
              backgroundColor: Colors.deepPurple,
            ),
          );

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
      appBar: AppBar(leading: MyBackButton()),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: const Text(
                  "Signup",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                      child: MyTextFeild(
                    controller: _firstNameController,
                    hintText: "John",
                    labelText: "First name",
                  )),
                  const SizedBox(width: 10),
                  Expanded(
                      child: MyTextFeild(
                    controller: _lastNameController,
                    hintText: "Doe",
                    labelText: "Last name",
                  )),
                ],
              ),
              const SizedBox(height: 20),
              MyTextFeild(
                controller: _emailController,
                hintText: "Enter your email",
                labelText: "Email",
              ),
              const SizedBox(height: 20),
              CustomPasswordTextFeild(
                controller: _passwordController,
                hintText: "***********",
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                    onPressed: () {},
                    child: const Text("must contain 8 characters")),
              ),
              const SizedBox(height: 30),
              _createAccountBtn(),
              const SizedBox(height: 16),
              _termsAndConditionsWidget()
            ],
          ),
        ),
      ),
    );
  }
}
