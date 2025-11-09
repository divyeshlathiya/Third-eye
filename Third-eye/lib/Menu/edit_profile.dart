import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:thirdeye/repositories/profile_repositories.dart';
import 'package:thirdeye/sharable_widget/snack_bar.dart';
import 'package:thirdeye/utils/storage_helper.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _profileRepository = ProfileRepository();
  DateTime? _picked;
  String? _profilePicUrl;
  bool isLoading = false;

  late final TextEditingController _firstName = TextEditingController();
  late final TextEditingController _lastName = TextEditingController();
  late final TextEditingController _dob = TextEditingController();
  late final TextEditingController _email = TextEditingController();
  String? selectedGender;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

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
    setState(() => isLoading = true);
    final profile = await _profileRepository.fetchProfile();

    if (profile != null) {
      setState(() {
        _firstName.text = profile['first_name'] ?? '';
        _lastName.text = profile['last_name'] ?? '';
        _email.text = profile['email'] ?? '';

        if (profile['dob'] != null && profile['dob'].toString().isNotEmpty) {
          try {
            DateTime parsedDob = DateTime.parse(profile['dob']);
            _dob.text = formatDobForDisplay(parsedDob);
          } catch (e) {
            debugPrint("DOB parsing error: $e");
            _dob.text = profile['dob'];
          }
        }

        if (profile['gender'] != null &&
            profile['gender'].toString().isNotEmpty) {
          selectedGender = profile['gender'].toString().trim().toUpperCase();
        } else {
          selectedGender = null;
        }

        if (profile['profile_pic'] != null &&
            profile['profile_pic'].toString().isNotEmpty) {
          _profilePicUrl = profile['profile_pic'];
        }
      });
    }

    setState(() => isLoading = false);
  }

  Future<void> _saveProfile() async {
    setState(() => isLoading = true);

    if (_firstName.text.trim().isEmpty ||
        _lastName.text.trim().isEmpty ||
        _dob.text.trim().isEmpty ||
        selectedGender == null ||
        selectedGender!.isEmpty) {
      setState(() => isLoading = false);
      CustomSnackBar.showCustomSnackBar(context, "Please fill all fields");
      return;
    }

    final updatedData = {
      "first_name": _firstName.text.trim(),
      "last_name": _lastName.text.trim(),
      "dob": formatDobForBackend(picked: _picked, textFieldValue: _dob.text),
      "gender": selectedGender,
      "profile_pic": _profilePicUrl, // ✅ include uploaded image URL
    };

    final result = await _profileRepository.updateProfile(updatedData);
    await StorageHelper.saveToken("first_name", _firstName.text);

    if (!mounted) return;

    setState(() => isLoading = false);

    if (result != null) {
      CustomSnackBar.showCustomSnackBar(
          context, "Profile updated successfully.");
      Navigator.pop(context,true);
    } else {
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
              SvgPicture.asset(asset, width: 20, height: 20),
              const SizedBox(width: 8),
              Text(
                gender,
                style: const TextStyle(
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
        isLoading = true;
      });

      // TODO: Optionally compress image before upload

      String userId = "123"; // Replace with logged-in user id
      String? url = await uploadProfilePic(_profileImage!, userId);

      if (url != null) {
        debugPrint("Uploaded! Download URL: $url");
        setState(() {
          _profilePicUrl = url;
        });

        // ✅ Immediately sync new pic with backend
        await _profileRepository.updateProfile({"profile_pic": url});
      } else {
        CustomSnackBar.showCustomSnackBar(context, "Image upload failed!");
      }

      setState(() => isLoading = false);
    }
  }

  Future<String?> uploadProfilePic(File imageFile, String userId) async {
    try {
      final fileName =
          "${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}";
      final storageRef = FirebaseStorage.instance
          .ref()
          .child("profile_pics/$userId/$fileName");

      await storageRef.putFile(imageFile);

      return await storageRef.getDownloadURL();
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
        title:
            const Text('Edit Profile', style: TextStyle(color: Colors.black)),
        elevation: 0,
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _loadProfile,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                              : (_profilePicUrl != null
                                  ? NetworkImage(_profilePicUrl!)
                                  : null) as ImageProvider<Object>?,
                          child:
                              (_profileImage == null && _profilePicUrl == null)
                                  ? const Icon(Icons.person,
                                      size: 50, color: Colors.grey)
                                  : null,
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

                  // First + Last Name
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('First Name',
                                style: TextStyle(fontWeight: FontWeight.bold)),
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
                            const Text('Last Name',
                                style: TextStyle(fontWeight: FontWeight.bold)),
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
                  const Text('Email',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    readOnly: true,
                    controller: _email,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // DOB
                  const Text('Date of Birth',
                      style: TextStyle(fontWeight: FontWeight.bold)),
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
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Gender
                  const Text('Gender',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _genderButton("FEMALE", "assets/female.svg"),
                      const SizedBox(width: 12),
                      _genderButton("MALE", "assets/male.svg"),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _saveProfile,
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
          ),
          if (isLoading)
            Container(
              color: Colors.white.withOpacity(0.7),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.deepPurple),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate;

    if (_dob.text.isNotEmpty) {
      try {
        List<String> parts = _dob.text.split('/');
        if (parts.length == 3) {
          initialDate = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        } else {
          initialDate = DateTime(2000, 1, 1);
        }
      } catch (e) {
        debugPrint("Error parsing DOB for date picker: $e");
        initialDate = DateTime(2000, 1, 1);
      }
    } else {
      initialDate = DateTime(2000, 1, 1);
    }

    _picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (_picked != null) {
      setState(() {
        _dob.text = formatDobForDisplay(_picked!);
      });
    }
  }
}
