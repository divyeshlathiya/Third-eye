import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key});

  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File? _imageFile;
  final picker = ImagePicker();
  String? _downloadUrl;

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> uploadImage() async {
    if (_imageFile == null) return;

    try {
      // Unique file name
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = FirebaseStorage.instance.ref().child("uploads/$fileName.jpg");

      // Upload file
      await ref.putFile(_imageFile!);

      // Get download URL
      final url = await ref.getDownloadURL();
      setState(() {
        _downloadUrl = url;
      });

      // TODO: send this `url` to your backend (FastAPI/Django/Node)
      print("Download URL: $url");

    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Image to Firebase")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageFile != null
                ? Image.file(_imageFile!, height: 200)
                : const Text("No image selected"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickImage,
              child: const Text("Pick Image"),
            ),
            ElevatedButton(
              onPressed: uploadImage,
              child: const Text("Upload to Firebase"),
            ),
            if (_downloadUrl != null) ...[
              const SizedBox(height: 20),
              Text("Download URL:"),
              SelectableText(_downloadUrl!),
            ]
          ],
        ),
      ),
    );
  }
}
