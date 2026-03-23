import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart' as di;
import '../../domain/entities/game.dart';
import '../../domain/entities/game_config.dart';
import '../cubits/game_cubit.dart';
import '../cubits/home_cubit.dart';
import '../cubits/home_state.dart';
import '../widgets/player_name_field.dart';
import 'game_page.dart';

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
            title: const Text('Schafkopf Zähler'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: switch (state) {
            HomeInitial() || HomeLoading() =>
              const Center(child: CircularProgressIndicator()),
            HomeError() => const Center(child: Text('Fehler beim Laden')),
            HomeLoaded() => _HomeContent(games: state.games),
            HomeGameCreated() => _HomeContent(games: state.games),
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
        .then((_) => context.read<HomeCubit>().loadGames());
  }

  void _showNewGameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<HomeCubit>(),
        child: const _NewGameDialog(),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final List<Game> games;
  const _HomeContent({required this.games});

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
        return _GameListItem(game: game);
      },
    );
  }
}

class _GameListItem extends StatelessWidget {
  final Game game;
  const _GameListItem({required this.game});

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
              .then((_) => context.read<HomeCubit>().loadGames());
        },
      ),
    );
  }
}

class _NewGameDialog extends StatefulWidget {
  const _NewGameDialog();

  @override
  State<_NewGameDialog> createState() => _NewGameDialogState();
}

class _NewGameDialogState extends State<_NewGameDialog> {
  final _nameController = TextEditingController(text: 'Spiel');
  final _playerControllers = List.generate(
    4,
    (i) => TextEditingController(text: 'Spieler ${i + 1}'),
  );
  int _playerCount = 4;

  // Config controllers with default values
  final _rufspielController = TextEditingController(text: '10');
  final _soloController = TextEditingController(text: '30');
  final _wenzController = TextEditingController(text: '30');
  final _laufendeController = TextEditingController(text: '5');

  @override
  void dispose() {
    _nameController.dispose();
    for (final c in _playerControllers) {
      c.dispose();
    }
    _rufspielController.dispose();
    _soloController.dispose();
    _wenzController.dispose();
    _laufendeController.dispose();
    super.dispose();
  }

  // Returns true if the player at the given index can be removed.
  // Only the last player can be removed, and only if there are more than 3 players.
  bool _canRemovePlayer(int index) =>
      _playerCount > 3 && index == _playerCount - 1;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Neues Spiel'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Spielname'),
            ),
            const SizedBox(height: 16),
            const Text('Spieler:', style: TextStyle(fontWeight: FontWeight.bold)),
            for (int i = 0; i < _playerCount; i++)
              PlayerNameField(
                controller: _playerControllers[i],
                label: 'Spieler ${i + 1}',
                onRemove: _canRemovePlayer(i)
                    ? () => setState(() => _playerCount--)
                    : null,
              ),
            if (_playerCount < 4)
              TextButton.icon(
                onPressed: () => setState(() => _playerCount++),
                icon: const Icon(Icons.add),
                label: const Text('Spieler hinzufügen'),
              ),
            const SizedBox(height: 16),
            const Text('Punkte:', style: TextStyle(fontWeight: FontWeight.bold)),
            if (_playerCount == 4)
              _PointsField(
                label: 'Rufspiel',
                controller: _rufspielController,
              ),
            _PointsField(label: 'Solo', controller: _soloController),
            _PointsField(label: 'Wenz', controller: _wenzController),
            _PointsField(label: 'Laufende', controller: _laufendeController),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Erstellen'),
        ),
      ],
    );
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final playerNames = _playerControllers
        .take(_playerCount)
        .map((c) => c.text.trim())
        .where((n) => n.isNotEmpty)
        .toList();

    if (playerNames.length < 3) return;

    final config = GameConfig(
      rufspielPoints: int.tryParse(_rufspielController.text) ?? 10,
      soloPoints: int.tryParse(_soloController.text) ?? 30,
      wenzPoints: int.tryParse(_wenzController.text) ?? 30,
      laufendePoints: int.tryParse(_laufendeController.text) ?? 5,
    );

    context.read<HomeCubit>().newGame(
          name: name,
          playerNames: playerNames,
          config: config,
        );
    Navigator.of(context).pop();
  }
}

class _PointsField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _PointsField({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          suffixText: 'Punkte',
          isDense: true,
        ),
      ),
    );
  }
}
