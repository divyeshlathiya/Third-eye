import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:thirdeye/repositories/user_repositories.dart';
import 'package:thirdeye/sharable_widget/snack_bar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _profileRepository = ProfileRepository();
  DateTime? _picked;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  late final TextEditingController _firstName = TextEditingController();
  late final TextEditingController _lastName = TextEditingController();
  late final TextEditingController _dob = TextEditingController();
  late final TextEditingController _email = TextEditingController();
  String? selectedGender;
  File? _profileImage;

  String formatDobForDisplay(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  String formatDobForBackend({DateTime? picked, String? textFieldValue}) {
    if (picked != null) {
      return "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    } else if (textFieldValue != null && textFieldValue.isNotEmpty) {
      try {
        List<String> parts = textFieldValue.split('/');
        if (parts.length == 3) {
          return "${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}";
        }
      } catch (e) {
        debugPrint("DOB backend formatting error: $e");
      }
    }
    return "";
  }

  Future<void> _loadProfile() async {
    final profile = await _profileRepository.fetchProfile();

    if (profile != null) {
      setState(() {
        _firstName.text = profile['first_name'] ?? '';
        _lastName.text = profile['last_name'] ?? '';
        _email.text = profile['email'] ?? '';

        if (profile['dob'] != null && profile['dob'].toString().isNotEmpty) {
          try {
            DateTime parsedDob = DateTime.parse(profile['dob']);
            _dob.text = formatDobForDisplay(parsedDob); // user-friendly
          } catch (e) {
            debugPrint("DOB parsing error: $e");
            _dob.text = profile['dob']; // fallback
          }
        }

        if (profile['gender'] != null &&
            profile['gender'].toString().isNotEmpty) {
          selectedGender = profile['gender'].toString().trim().toUpperCase();
        } else {
          selectedGender = null;
        }

        // if (profile['profile_pic'] != null) {
        //   _profileImage = File(profile['profile_pic']);
        //   // ⚠️ If it's a URL from Firebase, use NetworkImage in CircleAvatar
        // }
      });
    }
  }

  Future<void> _saveProfile() async {
    final updatedData = {
      "first_name": _firstName.text.trim(),
      "last_name": _lastName.text.trim(),
      "dob": formatDobForBackend(picked: _picked, textFieldValue: _dob.text),
      "gender": selectedGender,
    };

    final result = await _profileRepository.updateProfile(updatedData);

    if (result != null) {
      if (!mounted) return;
      CustomSnackBar.showCustomSnackBar(
          context, "Profile updated successfully.");
      Navigator.pop(context);
    } else {
      if (!mounted) return;
      CustomSnackBar.showCustomSnackBar(context, "Failed to update profile");
    }
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
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                asset,
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 8),
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

  Future<void> _pickImageAndUpload() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });

      // Upload to Firebase
      String userId = "123"; // replace with logged-in user id
      String? url = await uploadProfilePic(_profileImage!, userId);
      if (url != null) {
        debugPrint("Uploaded! Download URL: $url");
      }
    }
  }

  Future<String?> uploadProfilePic(File imageFile, String userId) async {
    try {
      // Create a reference with userId (unique folder per user)
      final storageRef =
          FirebaseStorage.instance.ref().child("profile_pics/$userId.jpg");

      // Upload the file
      await storageRef.putFile(imageFile);

      // Get the download URL
      String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      debugPrint("Error uploading image: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : const AssetImage('agna.png') as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: _pickImageAndUpload,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // First Name and Last Name in Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'First Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _firstName,
                        decoration: InputDecoration(
                          hintText: 'Enter first name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Last Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _lastName,
                        decoration: InputDecoration(
                          hintText: 'Enter last name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Email
            const Text(
              'Email',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              readOnly: true,
              controller: _email,
              decoration: InputDecoration(
                hintText: 'Enter your email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 20),

            // Date of Birth
            const Text(
              'Date of Birth',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _dob,
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: InputDecoration(
                hintText: 'Select date',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                suffixIcon: const Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 20),

            // Gender
            const Text(
              'Gender',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _genderButton("FEMALE", "icons/female.svg"),
                const SizedBox(width: 12),
                _genderButton("MALE", "icons/male.svg"),
              ],
            ),
            const SizedBox(height: 20),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3E2C96),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    _picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2005, 6, 19),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (_picked != null) {
      setState(() {
        _dob.text =
            "${_picked?.year}-${_picked?.month.toString().padLeft(2, '0')}-${_picked?.day.toString().padLeft(2, '0')}";
      });
    }
  }
}
