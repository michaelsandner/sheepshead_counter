import 'package:flutter/material.dart';
import '../../domain/entities/player.dart';

class PlayerScoreCard extends StatelessWidget {
  final Player player;
  const PlayerScoreCard({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    final isPositive = player.points >= 0;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: isPositive
          ? Colors.green.shade50
          : Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              player.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '${isPositive ? "+" : ""}${player.points}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isPositive ? Colors.green.shade700 : Colors.red.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
