import 'package:thirdeye/services/score_service.dart';
import 'package:thirdeye/utils/storage_helper.dart';

class ScoresRepositories {
  Future<Map<String, dynamic>?> fetchScore() async {
    final accessToken = await StorageHelper.getToken('access_token');
    if (accessToken == null) return null;

    return await ScoreService.fetchScore(accessToken);
  }
  Future<Map<String, dynamic>?> updateScore(
    String quizName,
    int score,
  ) async {
    final accessToken = await StorageHelper.getToken('access_token');
    if (accessToken == null) return null;

    return await ScoreService.updateScore(accessToken, quizName, score);
  }
}