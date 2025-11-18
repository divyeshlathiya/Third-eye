import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:thirdeye/login_screen.dart';
import 'package:thirdeye/repositories/profile_repositories.dart';
import 'package:thirdeye/screen/verified_screen.dart';
import 'package:thirdeye/sharable_widget/back_btn.dart';
import 'package:thirdeye/sharable_widget/index.dart';

class AboutYourSelfScreen extends StatefulWidget {
  final String? accessToken;
  const AboutYourSelfScreen({super.key, required this.accessToken});

  @override
  State<AboutYourSelfScreen> createState() => _AboutYourSelfScreenState();
}

class _AboutYourSelfScreenState extends State<AboutYourSelfScreen> {
  DateTime? selectedDate;
  String? selectedGender;
  bool isLoading = false;

  Future<void> _submitProfile() async {
    if (selectedDate == null || selectedGender == null) {
      FeedbackSystem.showErrorSnackBar(
        context,
        message: "Please select your date of birth and gender",
      );
      return;
    }

    setState(() => isLoading = true);

    final profileRepo = ProfileRepository();
    final dob = DateFormat("yyyy-MM-dd").format(selectedDate!);
    final gender = selectedGender!;

    final response =
        await profileRepo.updateDobGender(widget.accessToken, dob, gender);

    setState(() => isLoading = false);

    if (response != null) {
      FeedbackSystem.showSuccessSnackBar(
        context,
        message: "Profile updated successfully!",
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const VerifiedScreen()),
      );
    } else {
      FeedbackSystem.showErrorSnackBar(context,
          message: "Failed to update profile");
    }
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Widget _birthDateContainer() {
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedDate != null
                    ? DateFormat.yMMMd().format(selectedDate!)
                    : "Enter your birth date",
                style: TextStyle(
                  fontSize: 16,
                  color: selectedDate != null
                      ? Colors.black
                      : Colors.grey.shade500,
                ),
              ),
            ),
            SvgPicture.asset(
              'icons/calendar.svg',
              width: 24,
              height: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _genderButton(String gender, String asset) {
    bool isSelected = selectedGender == gender;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedGender = gender;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Colors.deepPurple : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(12),
            // color: isSelected ? Colors.deepPurple : Colors.white
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SvgPicture.asset(
              //   asset,
              //   width: 20,
              //   height: 20,
              // ),
              // const SizedBox(width: 8),
              Text(
                gender,
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
        }, icon: Icon(Icons.arrow_back)),
        title: const Text(
          "Tell us about yourself",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Text(
                "Date of Birth",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              const SizedBox(height: 8),
              _birthDateContainer(),
              const SizedBox(height: 24),
              Row(
                children: const [
                  Text(
                    "Gender",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  Text(
                    " *",
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _genderButton("FEMALE", "assets/female.svg"),
                  const SizedBox(width: 12),
                  _genderButton("MALE", "assets/male.svg"),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.40),
              MyButton(
                onPressed: isLoading ? null : _submitProfile,
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        "Next",
                        style: TextStyle(color: Colors.white),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
