import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thirdeye/Menu/menu.dart';
import 'package:thirdeye/repositories/profile_repositories.dart';
import 'package:thirdeye/repositories/scores_repositories.dart';
import 'package:thirdeye/screen/play_quiz_screen.dart';
import 'package:thirdeye/utils/storage_helper.dart';

import '../../Menu/past_score.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _scoreRepository = ScoresRepositories();
  final _profileRepository = ProfileRepository();

  String? firstName;
  String? profilePicUrl;
  int? latestScore;
  int? pastScore;
  int? streakCount;
  bool isLoading = true;
  String? gender;

  // quiz availability variables
  DateTime? lastQuizDate;
  bool isQuizAvailable = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkQuizAvailability();
  }

  Future<void> _loadUserData() async {
    setState(() => isLoading = true);

    try {
      // Load from storage
      final name = await StorageHelper.getToken('first_name');
      final pic = await StorageHelper.getToken('profile_pic');
      final profile = await _profileRepository.fetchProfile();

      // Load scores
      final scoreData = await _scoreRepository.fetchScore();
      final scores = scoreData?['scores'] as List<dynamic>? ?? [];
      final past =
      scores.fold<int>(0, (sum, item) => sum + (item["score"] as int));
      final latest = scores.isNotEmpty ? scores.last : null;
      final streak = scoreData?["current_streak"] as int?;

      setState(() {
        firstName = name;
        profilePicUrl = pic;
        latestScore = latest?['score'];
        pastScore = past;
        streakCount = streak;
        isLoading = false;
        gender = profile?["gender"];
      });
    } catch (e) {
      debugPrint("❌ Error loading user data: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> _checkQuizAvailability() async {
    final savedDate = await StorageHelper.getToken('last_quiz_date');

    if (savedDate != null) {
      final parsedDate = DateTime.tryParse(savedDate);
      if (parsedDate != null) {
        final today = DateTime.now();
        final isSameDay = parsedDate.year == today.year &&
            parsedDate.month == today.month &&
            parsedDate.day == today.day;

        setState(() {
          isQuizAvailable = !isSameDay;
          lastQuizDate = parsedDate;
        });
      }
    }
  }

  String _getGreeting() {
    final hour = DateTime
        .now()
        .hour;
    if (hour < 12) return "Good morning";
    if (hour < 17) return "Good afternoon";
    return "Good evening";
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery
        .of(context)
        .size
        .width;
    final height = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadUserData();
          await _checkQuizAvailability();
        },
        child: Column(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: height * 0.02),

                // Top content
                Padding(
                  padding: EdgeInsets.all(width * 0.04),
                  child: Row(
                    children: [
                      // Profile pic
                      Container(
                        width: width * 0.12,
                        height: width * 0.12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: ClipOval(
                          child: profilePicUrl != null &&
                              profilePicUrl!.isNotEmpty
                              ? Image.network(
                            profilePicUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.person, size: width * 0.07),
                          )
                              : Icon(Icons.person, size: width * 0.07),
                        ),
                      ),
                      SizedBox(width: width * 0.03),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getGreeting(),
                            style: TextStyle(
                              fontSize: width * 0.03,
                              color: Colors.grey,
                            ),
                          ),
                          isLoading
                              ? const SizedBox(
                            height: 16,
                            width: 16,
                            child:
                            CircularProgressIndicator(strokeWidth: 2),
                          )
                              : Text(
                            firstName ?? "User",
                            style: TextStyle(
                              fontSize: width * 0.04,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            _loadUserData();
                            _checkQuizAvailability();
                          },
                          icon: Icon(Icons.refresh_outlined)),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MenuDrawer(),
                            ),
                          );
                        },
                        icon: Icon(Icons.menu, size: width * 0.07),
                      ),
                    ],
                  ),
                ),

                // Banner Card
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SvgPicture.asset(
                      "assets/Card.svg",
                      fit: BoxFit.fitWidth,
                      width: double.infinity,
                      height: height * 0.12,
                    ),
                  ),
                ),

                SizedBox(height: height * 0.02),
              ],
            ),

            // Expanded Purple container
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF1d0e6b),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(width * 0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 16),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: width * 0.045,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            const TextSpan(text: "Start Your "),
                            TextSpan(
                              text: "21-Days",
                              style: const TextStyle(
                                color: Color(0xFFad9dff),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(
                                text:
                                " journey to\nBoost mental clarity & Emotional wellness."),
                          ],
                        ),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset("assets/agna.png"),
                          Text(
                            "${streakCount ?? 0}/21",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isQuizAvailable
                                ? Colors.white
                                : Colors.grey.shade400,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          onPressed: isQuizAvailable
                              ? () async {
                            final today = DateTime.now();
                            await StorageHelper.saveToken('last_quiz_date',
                                today.toIso8601String());

                            setState(() {
                              isQuizAvailable = false;
                              lastQuizDate = today;
                            });

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      WellnessScreen(
                                          isMale:
                                          gender!.toLowerCase() == "male")),
                            );
                          }
                              : null,
                          child: Text(
                            isQuizAvailable
                                ? "Start Quiz"
                                : "Come back tomorrow",
                            style: TextStyle(
                              color: const Color(0xFF4B1FA1),
                              fontSize: width * 0.045,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: _buildScoreCard(
                              context,
                              title: "Score",
                              value: latestScore?.toString() ?? "--",
                              icon: Icons.emoji_events,
                            ),
                          ),
                          Expanded(
                            child: _buildScoreCard(
                              context,
                              title: "View Past Score",
                              value: pastScore?.toString() ?? "--",
                              icon: Icons.history,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PastScoresScreen(),
                                  ),
                                );
                              },
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    VoidCallback? onTap, // 👈 added
  }) {
    final width = MediaQuery
        .of(context)
        .size
        .width;
    return GestureDetector(
      onTap: onTap, // 👈 handle tap
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        padding: EdgeInsets.all(width * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: width * 0.08,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF4B1FA1),
                  ),
                ),
                SizedBox(width: width * 0.02),
                Icon(icon, color: const Color(0xFF4B1FA1), size: width * 0.09),
              ],
            ),
            const SizedBox(height: 8),
            FittedBox(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF4B1FA1).withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}