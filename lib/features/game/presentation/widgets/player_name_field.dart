import 'package:flutter/material.dart';
import 'package:sheepshead_counter/features/game/presentation/widgets/player_colors.dart';

class PlayerNameField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int playerIndex;
  final VoidCallback? onRemove;

  const PlayerNameField({
    super.key,
    required this.controller,
    required this.label,
    required this.playerIndex,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final accent = PlayerColors.accent(playerIndex);
    final container = PlayerColors.container(playerIndex);
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              isDense: true,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CircleAvatar(
                  radius: 13,
                  backgroundColor: container,
                  child: Text(
                    '${playerIndex + 1}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: accent,
                    ),
                  ),
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 44,
                minHeight: 44,
              ),
            ),
          ),
        ),
        if (onRemove != null)
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.remove_circle_outline),
            color: Colors.red,
          ),
      ],
    );
  }
}
