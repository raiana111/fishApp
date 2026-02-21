import 'package:flutter/material.dart';

class ScoreWidget extends StatelessWidget {
  final int score;
  final int caughtFish;

  const ScoreWidget({
    super.key,
    required this.score,
    required this.caughtFish,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildScoreItem(Icons.emoji_events, 'Очки: $score', Colors.amber),
          const SizedBox(width: 20),
          _buildScoreItem(Icons.waves, 'Рыбок: $caughtFish', Colors.lightBlue),
        ],
      ),
    );
  }

  Widget _buildScoreItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
