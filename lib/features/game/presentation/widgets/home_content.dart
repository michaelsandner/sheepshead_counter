import 'package:flutter/material.dart';
import 'package:sheepshead_counter/domain/entities/game.dart';
import 'package:sheepshead_counter/features/game/presentation/widgets/game_list_item.dart';

class HomeContent extends StatelessWidget {
  final List<Game> games;

  const HomeContent({super.key, required this.games});

  @override
  Widget build(BuildContext context) {
    if (games.isEmpty) {
      return const Center(
        child: Text(
          'Noch keine Spiele.\nErstelle ein neues Spiel!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[games.length - 1 - index];
        return GameListItem(game: game);
      },
    );
  }
}
