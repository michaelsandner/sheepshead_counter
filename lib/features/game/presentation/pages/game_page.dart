import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/game.dart';
import '../cubits/game_cubit.dart';
import '../cubits/game_state.dart';
import '../widgets/add_entry_bottom_sheet.dart';
import '../widgets/game_entry_list_item.dart';
import '../widgets/player_score_card.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameCubit, GameState>(
      listener: (context, state) {
        if (state is GameError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is GameLoaded && state.game.isFinished) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        if (state is! GameLoaded) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return _GameContent(game: state.game);
      },
    );
  }
}

class _GameContent extends StatelessWidget {
  final Game game;
  const _GameContent({required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(game.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          TextButton.icon(
            onPressed: () => _confirmFinish(context),
            icon: const Icon(Icons.stop_circle_outlined),
            label: const Text('Beenden'),
          ),
        ],
      ),
      body: Column(
        children: [
          _PlayerScoreSection(game: game),
          const Divider(height: 1),
          Expanded(child: _GameEntriesSection(game: game)),
        ],
      ),
      floatingActionButton: game.isFinished
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _showAddEntry(context),
              label: const Text('Eintrag'),
              icon: const Icon(Icons.add),
            ),
    );
  }

  void _showAddEntry(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: context.read<GameCubit>(),
        child: AddEntryBottomSheet(game: game),
      ),
    );
  }

  void _confirmFinish(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Spiel beenden?'),
        content: const Text('Das Spiel wird als beendet markiert.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<GameCubit>().finishGame();
            },
            child: const Text('Beenden'),
          ),
        ],
      ),
    );
  }
}

class _PlayerScoreSection extends StatelessWidget {
  final Game game;
  const _PlayerScoreSection({required this.game});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: game.players
              .map((p) => PlayerScoreCard(player: p))
              .toList(),
        ),
      ),
    );
  }
}

class _GameEntriesSection extends StatelessWidget {
  final Game game;
  const _GameEntriesSection({required this.game});

  @override
  Widget build(BuildContext context) {
    if (game.entries.isEmpty) {
      return const Center(
        child: Text(
          'Noch keine Einträge.\nFüge einen neuen Eintrag hinzu!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: game.entries.length,
      itemBuilder: (context, index) {
        final entry = game.entries[game.entries.length - 1 - index];
        return GameEntryListItem(entry: entry, players: game.players);
      },
    );
  }
}
