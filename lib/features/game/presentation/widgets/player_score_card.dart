import 'package:flutter/material.dart';
import 'package:sheepshead_counter/domain/entities/player.dart';
import 'package:sheepshead_counter/features/game/presentation/widgets/player_colors.dart';

class PlayerScoreCard extends StatelessWidget {
  final Player player;
  final int playerIndex;

  const PlayerScoreCard({
    super.key,
    required this.player,
    required this.playerIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = player.points >= 0;
    final accent = PlayerColors.accent(playerIndex);
    final container = PlayerColors.container(playerIndex);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: container,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              player.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: accent,
              ),
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
