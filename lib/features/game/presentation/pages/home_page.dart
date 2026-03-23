import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheepshead_counter/injection_container.dart' as di;
import 'package:sheepshead_counter/domain/entities/game.dart';
import 'package:sheepshead_counter/features/game/presentation/cubits/game_cubit.dart';
import 'package:sheepshead_counter/features/game/presentation/cubits/home_cubit.dart';
import 'package:sheepshead_counter/features/game/presentation/cubits/home_state.dart';
import 'package:sheepshead_counter/features/game/presentation/pages/game_page.dart';
import 'package:sheepshead_counter/features/game/presentation/widgets/home_content.dart';
import 'package:sheepshead_counter/features/game/presentation/widgets/new_game_dialog.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is HomeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is HomeGameCreated) {
          _navigateToGame(context, state.game);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Schafkopf-Punkte-Zähler'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: switch (state) {
            HomeInitial() ||
            HomeLoading() =>
              const Center(child: CircularProgressIndicator()),
            HomeError() => const Center(child: Text('Fehler beim Laden')),
            HomeLoaded() => HomeContent(games: state.games),
            HomeGameCreated() => HomeContent(games: state.games),
          },
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showNewGameDialog(context),
            label: const Text('Neues Spiel'),
            icon: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _navigateToGame(BuildContext context, Game game) {
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
  }

  void _showNewGameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<HomeCubit>(),
        child: const NewGameDialog(),
      ),
    );
  }
}
