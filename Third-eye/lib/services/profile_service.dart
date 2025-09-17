import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thirdeye/config/urls.dart';

class ProfileService {
  static Future<Map<String, dynamic>?> fetchProfile(String accessToken) async {
    final url = Uri.parse(ConfigURL.fetchProfile);

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return null;
  }

  static Future<Map<String, dynamic>?> updateProfile(
      String accessToken, Map<String, dynamic> profileData) async {
    final url = Uri.parse(ConfigURL.updateProfile);

    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: json.encode(profileData),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return null;
  }

  static Future<Map<String, dynamic>?> updateDobGender(
      String accessToken, String dob, String gender) async {
    final url = Uri.parse(ConfigURL.updateDOBGender);

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "dob": dob,
        "gender": gender,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return null;
  }

  

}
