import 'package:flutter/material.dart';
import 'package:thirdeye/repositories/scores_repositories.dart';

// ✅ Backend response model
class StreakRecord {
  final int day;
  final int score;

  StreakRecord({required this.day, required this.score});
}

class PastScoresScreen extends StatefulWidget {
  const PastScoresScreen({super.key});

  @override
  State<PastScoresScreen> createState() => _PastScoresScreenState();
}

class _PastScoresScreenState extends State<PastScoresScreen> {
  late Future<List<StreakRecord>> _streakFuture;
  final _scoreRepository = ScoresRepositories();

  // ✅ Fixed: Return List<StreakRecord>
  Future<List<StreakRecord>> fetchStreaksFromBackend() async {
    try {
      final scoreData = await _scoreRepository.fetchScore();

      // Expecting {"scores": [ { "score": 80, ... }, ... ]}
      final scores = scoreData?['scores'] as List<dynamic>? ?? [];

      return List.generate(scores.length, (index) {
        final scoreEntry = scores[index] as Map<String, dynamic>;
        return StreakRecord(
          day: index + 1,
          score: (scoreEntry["score"] ?? 0) as int,
        );
      });
    } catch (e) {
      debugPrint("❌ Error fetching scores: $e");
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _streakFuture = fetchStreaksFromBackend();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1EEFE),
        elevation: 0,
        title: const Text(
          "Past Scores",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      backgroundColor: const Color(0xFFF1EEFE),
      body: SafeArea(
        child: FutureBuilder<List<StreakRecord>>(
          future: _streakFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            final streaks = snapshot.data ?? [];

            if (streaks.isEmpty) {
              return const Center(
                child: Text(
                  "No past scores available.",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),

                // Rocket Image
                Center(
                  child: Image.asset(
                    "assets/rocket.gif", // make sure file exists
                    height: 250,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 10),

                // Certificate Title
                const Text(
                  "You've earned a Certificate",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 8),
                const Text(
                  "21 Day Achiever",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3B2EB0),
                  ),
                ),
                const Text(
                  "Keep up this good work!",
                  style: TextStyle(fontSize: 14, color: Colors.black45),
                ),

                const SizedBox(height: 30),

                // Streak Record
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Streak Record",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Days and Scores
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: streaks.map((streak) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C63FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Day ${streak.day}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "${streak.score > 0 ? '+${streak.score}' : streak.score} 🪙",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const Spacer(),

                // Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B2EB0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            // ✅ Download logic here
                          },
                          icon: const Icon(Icons.download, color: Colors.white),
                          label: const Text(
                            "Download",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF3B2EB0)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            // ✅ Share logic here
                          },
                          icon: const Icon(
                            Icons.share,
                            color: Color(0xFF3B2EB0),
                          ),
                          label: const Text(
                            "Share",
                            style: TextStyle(
                              color: Color(0xFF3B2EB0),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
