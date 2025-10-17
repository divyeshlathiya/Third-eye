// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
// import 'package:thirdeye/repositories/certificate_repository.dart';
// import 'package:thirdeye/sharable_widget/snack_bar.dart';
// // import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

// import 'package:permission_handler/permission_handler.dart';

// class CertificateScreen extends StatefulWidget {
//   const CertificateScreen({super.key});

//   @override
//   State<CertificateScreen> createState() => _CertificateScreenState();
// }

// class _CertificateScreenState extends State<CertificateScreen> {
//   final CertificateRepository _repository = CertificateRepository();

//   Uint8List? _certificateBytes;
//   bool _loading = false;
//   File? _localFile;

//   @override
//   void initState() {
//     super.initState();
//     _loadCertificateFromLocal();
//   }

//   Future<File> _getLocalFile() async {
//     final dir = await getApplicationDocumentsDirectory();
//     return File("${dir.path}/certificate.png");
//   }

//   Future<void> _loadCertificateFromLocal() async {
//     final file = await _getLocalFile();
//     if (await file.exists()) {
//       final bytes = await file.readAsBytes();
//       setState(() {
//         _certificateBytes = bytes;
//         _localFile = file;
//       });
//     } else {
//       // If not found locally, auto-fetch once
//       _downloadCertificate();
//     }
//   }

//   Future<bool> _requestGalleryPermission() async {
//     if (await Permission.photos.request().isGranted) return true;
//     if (await Permission.storage.request().isGranted) return true;
//     return false;
//   }

//   Future<void> _downloadCertificate() async {
//     setState(() => _loading = true);

//     final bytes = await _repository.getCertificate();
//     if (bytes != null) {
//       // Save in app's local storage
//       final file = await _getLocalFile();
//       await file.writeAsBytes(bytes);

//       setState(() {
//         _certificateBytes = bytes;
//         _localFile = file;
//       });

//       // 🔹 Save to Gallery
//       // 🔹 Save to Gallery
//       if (await _requestGalleryPermission()) {
//         final result = await ImageGallerySaverPlus.saveImage(
//           bytes,
//           quality: 100,
//           name: "my_certificate_${DateTime.now().millisecondsSinceEpoch}",
//         );
//         debugPrint("Gallery Save Result: $result");
//       }

//       if (!mounted) return;
//       CustomSnackBar.showCustomSnackBar(
//           context, "Certificate downloaded to gallery 🎉");
//     } else {
//       if (!mounted) return;
//       CustomSnackBar.showCustomSnackBar(context, "Failed to fetch certificate");
//     }

//     setState(() => _loading = false);
//   }

//   Future<void> _shareCertificate() async {
//     if (_localFile == null || !await _localFile!.exists()) {
//       CustomSnackBar.showCustomSnackBar(
//           context, "Please download certificate first");
//       return;
//     }

//     await Share.shareXFiles(
//       [XFile(_localFile!.path)],
//       text: "Here is my certificate 🎉",
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 0,
//         title: const Text(
//           "Certificate",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: false,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: Column(
//           children: [
//             const SizedBox(height: 16),
//             // Certificate Preview
//             Container(
//               width: double.infinity,
//               height: 525,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: _certificateBytes != null
//                       ? MemoryImage(_certificateBytes!)
//                       : const AssetImage("assets/Certificate.png")
//                           as ImageProvider,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       foregroundColor: const Color(0xFF1d0e6b),
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                     onPressed: _shareCertificate,
//                     icon: const Icon(Icons.share),
//                     label: const Text("Share"),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF1d0e6b),
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                     onPressed: _loading ? null : _downloadCertificate,
//                     icon: _loading
//                         ? const SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               color: Colors.white,
//                             ),
//                           )
//                         : const Icon(Icons.download),
//                     label: const Text("Download"),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thirdeye/repositories/certificate_repository.dart';
import 'package:thirdeye/repositories/scores_repositories.dart';
import 'package:thirdeye/sharable_widget/snack_bar.dart';

class CertificateScreen extends StatefulWidget {
  const CertificateScreen({super.key});

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  final CertificateRepository _repository = CertificateRepository();
  final ScoresRepositories _scoreRepository = ScoresRepositories();

  Uint8List? _certificateBytes;
  bool _loading = false;
  File? _localFile;

  @override
  void initState() {
    super.initState();
    _loadCertificateFromLocal();
  }

  Future<File> _getLocalFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File("${dir.path}/certificate.png");
  }

  Future<void> _loadCertificateFromLocal() async {
    final file = await _getLocalFile();
    if (await file.exists()) {
      final bytes = await file.readAsBytes();
      setState(() {
        _certificateBytes = bytes;
        _localFile = file;
      });
    }
  }

  Future<int> _getStreakCount() async {
    try {
      final scoreData = await _scoreRepository.fetchScore();
      final scores = scoreData?['scores'] as List<dynamic>? ?? [];
      return scores.length; // ✅ Number of days completed
    } catch (e) {
      debugPrint("❌ Error fetching streak count: $e");
      return 0;
    }
  }

  Future<bool> _requestGalleryPermission() async {
    if (await Permission.photos.request().isGranted) return true;
    if (await Permission.storage.request().isGranted) return true;
    return false;
  }

  Future<void> _downloadCertificate() async {
    final streakCount = await _getStreakCount();

    // 🔹 Allow only if user completed 21 days
    if (streakCount < 21) {
      CustomSnackBar.showCustomSnackBar(
        context,
        "Complete your 21-day journey to unlock your certificate 🎯",
      );
      return;
    }

    setState(() => _loading = true);

    final bytes = await _repository.getCertificate();
    if (bytes != null) {
      final file = await _getLocalFile();
      await file.writeAsBytes(bytes);

      setState(() {
        _certificateBytes = bytes;
        _localFile = file;
      });

      if (await _requestGalleryPermission()) {
        await ImageGallerySaverPlus.saveImage(
          bytes,
          quality: 100,
          name: "my_certificate_${DateTime.now().millisecondsSinceEpoch}",
        );
      }

      if (!mounted) return;
      CustomSnackBar.showCustomSnackBar(
        context,
        "Certificate downloaded to gallery 🎉",
      );
    } else {
      if (!mounted) return;
      CustomSnackBar.showCustomSnackBar(
        context,
        "Failed to fetch certificate 😔",
      );
    }

    setState(() => _loading = false);
  }

  Future<void> _shareCertificate() async {
    if (_localFile == null || !await _localFile!.exists()) {
      CustomSnackBar.showCustomSnackBar(
          context, "Please download certificate first");
      return;
    }

    await Share.shareXFiles(
      [XFile(_localFile!.path)],
      text: "Here is my 21-Day Self-Awareness Certificate 🎉",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Certificate",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Certificate Preview
            Container(
              width: double.infinity,
              height: 525,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: _certificateBytes != null
                      ? MemoryImage(_certificateBytes!)
                      : const AssetImage("assets/Certificate.png")
                          as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1d0e6b),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _shareCertificate,
                    icon: const Icon(Icons.share),
                    label: const Text("Share"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1d0e6b),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _loading ? null : () => _downloadCertificate(),
                    icon: _loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.download),
                    label: const Text("Download"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
