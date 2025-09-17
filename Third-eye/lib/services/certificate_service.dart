import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:thirdeye/config/urls.dart';

class CertificateService {
  static Future<Uint8List?> fetchCertificate(String accessToken) async {
    final url = Uri.parse(ConfigURL.getCertificate); // e.g. http://your-api/certificate

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return response.bodyBytes; // returns image bytes
    }
    return null;
  }
}
