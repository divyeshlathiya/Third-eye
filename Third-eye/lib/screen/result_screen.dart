import 'package:flutter/material.dart';
import 'package:thirdeye/screen/tips_screen.dart';
import 'package:thirdeye/sharable_widget/button.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  final String userName;
  final int day;

  const ResultScreen({
    super.key,
    required this.score,
    required this.userName,
    required this.day,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Placeholder for image/logo
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.star,
                  size: 60,
                  color: Color.fromARGB(255, 47, 41, 58),
                ),
              ),
              const SizedBox(height: 32),

              // Title
              const Text(
                "You're Today’s Score",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF4B1FA1),
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              // Score
              Text(
                "${widget.score}",
                style: const TextStyle(
                  fontSize: 48,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // Congrats text
              Text(
                "Congratulations!\nGreat Job ${widget.userName}! You have done well",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4B1FA1),
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 20),

              // Day + reward button
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4B1FA1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "Day ${widget.day}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.monetization_on,
                        size: 18, color: Colors.amber),
                    Text(
                      "${widget.score}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4B1FA1),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.20),
              MyButton(
                buttonLabel: "Next",
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TipsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
