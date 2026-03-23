import 'package:flutter/material.dart';
import '../../domain/entities/game_entry.dart';
import '../../domain/entities/game_mode.dart';
import '../../domain/entities/player.dart';

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
    final winnerNames = players
        .where((p) => entry.winnerIds.contains(p.id))
        .map((p) => p.name)
        .join(', ');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(_gameModeShort(entry.gameMode)),
        ),
        title: Text(_gameModeName(entry.gameMode)),
        subtitle: Text('Gewinner: $winnerNames'),
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
    if (entry.spritze != null) parts.add('Spritze: ${entry.spritze}');
    if (entry.laufende != null) parts.add('Laufende: ${entry.laufende}');
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
