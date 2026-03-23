import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheepshead_counter/injection_container.dart' as di;
import 'package:sheepshead_counter/domain/entities/game.dart';
import 'package:sheepshead_counter/features/game/presentation/cubits/game_cubit.dart';
import 'package:sheepshead_counter/features/game/presentation/cubits/home_cubit.dart';
import 'package:sheepshead_counter/features/game/presentation/pages/game_page.dart';

class GameListItem extends StatelessWidget {
  final Game game;

  const GameListItem({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(game.name),
        subtitle: Text(
          '${game.players.length} Spieler · '
          '${game.entries.length} Runden · '
          '${game.isFinished ? "Beendet" : "Aktiv"}',
        ),
        trailing: game.isFinished
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.play_circle, color: Colors.blue),
        onTap: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => di.sl<GameCubit>()..loadGame(game),
                child: const GamePage(),
              ),
            ),
          )
              .then((_) {
            if (context.mounted) {
              context.read<HomeCubit>().loadGames();
            }
          });
        },
      ),
    );
  }
}
