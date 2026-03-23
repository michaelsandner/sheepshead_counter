import 'package:flutter/material.dart';
import 'package:sheepshead_counter/domain/entities/game_entry.dart';
import 'package:sheepshead_counter/domain/entities/game_mode.dart';
import 'package:sheepshead_counter/domain/entities/player.dart';
import 'package:sheepshead_counter/features/game/presentation/widgets/player_colors.dart';

class GameEntryListItem extends StatelessWidget {
  final GameEntry entry;
  final List<Player> players;
  final int value;

  const GameEntryListItem({
    super.key,
    required this.entry,
    required this.players,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final winners = players
        .asMap()
        .entries
        .where((e) => entry.winnerIds.contains(e.value.id))
        .toList();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(_gameModeShort(entry.gameMode)),
        ),
        title: Text(_gameModeName(entry.gameMode)),
        subtitle: winners.isEmpty
            ? const Text('Gewinner: –')
            : Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: 'Gewinner: '),
                    for (int i = 0; i < winners.length; i++) ...[
                      TextSpan(
                        text: winners[i].value.name,
                        style: TextStyle(
                          color: PlayerColors.accent(winners[i].key),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (i < winners.length - 1) const TextSpan(text: ', '),
                    ],
                  ],
                ),
              ),
        trailing: _EntryDetails(entry: entry, value: value),
      ),
    );
  }

  String _gameModeName(GameMode mode) {
    switch (mode) {
      case GameMode.rufspiel:
        return 'Rufspiel';
      case GameMode.solo:
        return 'Solo';
      case GameMode.wenz:
        return 'Wenz';
      case GameMode.geier:
        return 'Geier';
    }
  }

  String _gameModeShort(GameMode mode) {
    switch (mode) {
      case GameMode.rufspiel:
        return 'R';
      case GameMode.solo:
        return 'S';
      case GameMode.wenz:
        return 'W';
      case GameMode.geier:
        return 'G';
    }
  }
}

class _EntryDetails extends StatelessWidget {
  final GameEntry entry;
  final int value;
  const _EntryDetails({required this.entry, required this.value});

  @override
  Widget build(BuildContext context) {
    final parts = <String>[];
    if (entry.spritze != null) {
      parts.add('Spritze: ${entry.spritze}');
    }
    if (entry.laufende != null) {
      parts.add('Laufende: ${entry.laufende}');
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '$value Pkt.',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (parts.isNotEmpty)
          Text(
            parts.join(' · '),
            style: Theme.of(context).textTheme.bodySmall,
          ),
      ],
    );
  }
}
