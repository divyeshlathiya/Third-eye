import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:thirdeye/config/urls.dart';

class ScoreService {
  static Future<Map<String, dynamic>?> fetchScore(String accessToken) async {
    final url = Uri.parse(ConfigURL.getscore);

    debugPrint("➡ GET $url");
    debugPrint("➡ Headers: {Authorization: Bearer $accessToken}");

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    debugPrint("⬅ Response [${response.statusCode}]: ${response.body}");

    if (response.statusCode == 200) {
      
      return json.decode(response.body);
    }

    return null;
  }

  static Future<Map<String, dynamic>?> updateScore(
      String accessToken, String quizName, int score) async {
    final url = Uri.parse(ConfigURL.updatescore);

    final body = {
      "quiz_name": quizName,
      "score": score,
    };

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );

    debugPrint("➡ POST $url");
    debugPrint("➡ Body: ${json.encode(body)}");
    debugPrint("➡ Headers: ${response.request?.headers}");
    debugPrint("⬅ Response [${response.statusCode}]: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    }
    return null;
  }
}