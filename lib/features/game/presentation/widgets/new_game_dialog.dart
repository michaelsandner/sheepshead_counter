import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheepshead_counter/domain/entities/game_config.dart';
import 'package:sheepshead_counter/features/game/presentation/cubits/home_cubit.dart';
import 'package:sheepshead_counter/features/game/presentation/widgets/player_name_field.dart';

class NewGameDialog extends StatefulWidget {
  const NewGameDialog({super.key});

  @override
  State<NewGameDialog> createState() => _NewGameDialogState();
}

class _NewGameDialogState extends State<NewGameDialog> {
  final _nameController = TextEditingController(text: 'Spiel');
  final _playerControllers = List.generate(
    5,
    (i) => TextEditingController(text: 'Spieler ${i + 1}'),
  );
  int _playerCount = 4;
  bool _showPointsConfig = false;

  // Config controllers with default values
  final _rufspielController = TextEditingController(text: '10');
  final _soloController = TextEditingController(text: '30');
  final _wenzController = TextEditingController(text: '30');
  final _geierController = TextEditingController(text: '30');
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
    _geierController.dispose();
    _laufendeController.dispose();
    super.dispose();
  }

  bool _canRemovePlayer(int index) =>
      _playerCount > 3 && index == _playerCount - 1;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: colorScheme.primaryContainer,
              child: Column(
                children: [
                  Icon(
                    Icons.style_rounded,
                    size: 36,
                    color: colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Neues Spiel',
                    style: textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Game name
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Spielname',
                        prefixIcon: const Icon(Icons.edit),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Players section
                    const _SectionHeader(
                      icon: Icons.people,
                      title: 'Spieler',
                    ),
                    const SizedBox(height: 8),
                    for (int i = 0; i < _playerCount; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: PlayerNameField(
                          controller: _playerControllers[i],
                          label: 'Spieler ${i + 1}',
                          playerIndex: i,
                          onRemove: _canRemovePlayer(i)
                              ? () => setState(() => _playerCount--)
                              : null,
                        ),
                      ),
                    if (_playerCount < 5)
                      Center(
                        child: TextButton.icon(
                          onPressed: () => setState(() => _playerCount++),
                          icon: const Icon(Icons.person_add),
                          label: const Text('Spieler hinzufügen'),
                        ),
                      ),
                    const SizedBox(height: 12),

                    // Points config (collapsible)
                    _PointsConfigSection(
                      isExpanded: _showPointsConfig,
                      onToggle: () => setState(
                        () => _showPointsConfig = !_showPointsConfig,
                      ),
                      showRufspiel: _playerCount >= 4,
                      rufspielController: _rufspielController,
                      soloController: _soloController,
                      wenzController: _wenzController,
                      geierController: _geierController,
                      laufendeController: _laufendeController,
                    ),
                  ],
                ),
              ),
            ),
            // Actions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Abbrechen'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.check),
                      label: const Text('Erstellen'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      return;
    }

    final playerNames = _playerControllers
        .take(_playerCount)
        .map((c) => c.text.trim())
        .where((n) => n.isNotEmpty)
        .toList();

    if (playerNames.length < 3) {
      return;
    }

    final config = GameConfig(
      rufspielPoints: int.tryParse(_rufspielController.text) ?? 10,
      soloPoints: int.tryParse(_soloController.text) ?? 30,
      wenzPoints: int.tryParse(_wenzController.text) ?? 30,
      geierPoints: int.tryParse(_geierController.text) ?? 30,
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

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

class _PointsConfigSection extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;
  final bool showRufspiel;
  final TextEditingController rufspielController;
  final TextEditingController soloController;
  final TextEditingController wenzController;
  final TextEditingController geierController;
  final TextEditingController laufendeController;

  const _PointsConfigSection({
    required this.isExpanded,
    required this.onToggle,
    required this.showRufspiel,
    required this.rufspielController,
    required this.soloController,
    required this.wenzController,
    required this.geierController,
    required this.laufendeController,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorScheme.surfaceContainerLow,
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(Icons.tune, size: 20, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Punkte anpassen',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  if (showRufspiel)
                    _PointsField(
                        label: 'Rufspiel', controller: rufspielController),
                  _PointsField(label: 'Solo', controller: soloController),
                  _PointsField(label: 'Wenz', controller: wenzController),
                  _PointsField(label: 'Geier', controller: geierController),
                  _PointsField(
                      label: 'Laufende', controller: laufendeController),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _PointsField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _PointsField({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          suffixText: 'Pkt.',
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );
  }
}
