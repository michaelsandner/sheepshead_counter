import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheepshead_counter/domain/entities/game.dart';
import 'package:sheepshead_counter/domain/entities/game_entry.dart';
import 'package:sheepshead_counter/domain/entities/game_mode.dart';
import 'package:sheepshead_counter/domain/entities/player.dart';
import 'package:sheepshead_counter/domain/usecases/calculate_points_use_case.dart';
import 'package:sheepshead_counter/features/game/presentation/cubits/game_cubit.dart';
import 'package:sheepshead_counter/features/game/presentation/widgets/player_colors.dart';

class AddEntryDialog extends StatefulWidget {
  final Game game;
  const AddEntryDialog({super.key, required this.game});

  @override
  State<AddEntryDialog> createState() => _AddEntryDialogState();
}

class _AddEntryDialogState extends State<AddEntryDialog> {
  GameMode _selectedMode = GameMode.rufspiel;
  final Set<String> _selectedWinnerIds = {};
  int? _spritze;
  int? _laufende;

  final _calculatePoints = CalculatePointsUseCase();

  bool get _isRufspiel => _selectedMode == GameMode.rufspiel;
  int get _requiredWinners => _isRufspiel ? 2 : 1;

  List<Player> get _players => widget.game.players;

  // For 5-player games, one player sits out each round based on round number
  String? get _sittingOutPlayerId {
    if (_players.length != 5) {
      return null;
    }
    final index = widget.game.entries.length % _players.length;
    return _players[index].id;
  }

  // Rufspiel requires at least 4 active players
  List<GameMode> get _availableModes {
    final activeCount =
        _sittingOutPlayerId != null ? _players.length - 1 : _players.length;
    if (activeCount < 4) {
      return [GameMode.solo, GameMode.wenz, GameMode.geier];
    }
    return GameMode.values;
  }

  int get _previewValue {
    final tempEntry = GameEntry(
      id: '',
      gameMode: _selectedMode,
      winnerIds: const [],
      spritze: _spritze,
      laufende: _laufende,
      timestamp: DateTime.now(),
    );
    return _calculatePoints(tempEntry, widget.game.config);
  }

  @override
  void initState() {
    super.initState();
    final activeCount =
        _sittingOutPlayerId != null ? _players.length - 1 : _players.length;
    if (activeCount < 4) {
      _selectedMode = GameMode.solo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Eintrag hinzufügen',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _GameModeSelector(
                modes: _availableModes,
                selected: _selectedMode,
                onChanged: (mode) {
                  setState(() {
                    _selectedMode = mode;
                    _selectedWinnerIds.clear();
                  });
                },
              ),
              const SizedBox(height: 12),
              if (_sittingOutPlayerId != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.pause_circle_outline, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${_players.firstWhere((p) => p.id == _sittingOutPlayerId).name} setzt aus',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              Text(
                'Gewinner ($_requiredWinners auswählen):',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              _WinnerSelector(
                players: _players,
                selectedIds: _selectedWinnerIds,
                maxSelectable: _requiredWinners,
                disabledPlayerId: _sittingOutPlayerId,
                onChanged: (id, selected) {
                  setState(() {
                    if (selected) {
                      if (_selectedWinnerIds.length < _requiredWinners) {
                        _selectedWinnerIds.add(id);
                      }
                    } else {
                      _selectedWinnerIds.remove(id);
                    }
                  });
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _NullableNumberPicker(
                      label: 'Spritze',
                      value: _spritze,
                      min: 1,
                      max: 3,
                      onChanged: (v) => setState(() => _spritze = v),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _NullableNumberPicker(
                      label: 'Laufende',
                      value: _laufende,
                      min: 3,
                      max: 8,
                      onChanged: (v) => setState(() => _laufende = v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Wert: $_previewValue Pkt.',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _selectedWinnerIds.length == _requiredWinners
                      ? _submit
                      : null,
                  child: const Text('Hinzufügen'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    context.read<GameCubit>().addEntry(
          gameMode: _selectedMode,
          winnerIds: _selectedWinnerIds.toList(),
          spritze: _spritze,
          laufende: _laufende,
        );
    Navigator.of(context).pop();
  }
}

class _GameModeSelector extends StatelessWidget {
  final List<GameMode> modes;
  final GameMode selected;
  final ValueChanged<GameMode> onChanged;

  const _GameModeSelector({
    required this.modes,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<GameMode>(
      segments: modes
          .map(
            (m) => ButtonSegment(
              value: m,
              label: Text(_label(m)),
            ),
          )
          .toList(),
      selected: {selected},
      onSelectionChanged: (s) => onChanged(s.first),
    );
  }

  String _label(GameMode mode) {
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
}

class _WinnerSelector extends StatelessWidget {
  final List<Player> players;
  final Set<String> selectedIds;
  final int maxSelectable;
  final String? disabledPlayerId;
  final void Function(String id, bool selected) onChanged;

  const _WinnerSelector({
    required this.players,
    required this.selectedIds,
    required this.maxSelectable,
    this.disabledPlayerId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: players.asMap().entries.map((entry) {
        final index = entry.key;
        final player = entry.value;
        final isSelected = selectedIds.contains(player.id);
        final isDisabled = player.id == disabledPlayerId;
        final accent = PlayerColors.accent(index);
        final container = PlayerColors.container(index);
        return FilterChip(
          label: Text(
            player.name,
            style: TextStyle(
              color: isDisabled
                  ? accent.withAlpha(80)
                  : isSelected
                      ? accent
                      : accent.withAlpha(180),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          selected: isSelected,
          selectedColor: container,
          checkmarkColor: accent,
          side: BorderSide(
            color: isDisabled
                ? accent.withAlpha(40)
                : isSelected
                    ? accent
                    : accent.withAlpha(80),
          ),
          onSelected: isDisabled ? null : (selected) => onChanged(player.id, selected),
        );
      }).toList(),
    );
  }
}

class _NullableNumberPicker extends StatelessWidget {
  final String label;
  final int? value;
  final int min;
  final int max;
  final ValueChanged<int?> onChanged;

  const _NullableNumberPicker({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      const DropdownMenuItem<int?>(child: Text('-')),
      for (int i = min; i <= max; i++)
        DropdownMenuItem<int?>(value: i, child: Text('$i')),
    ];

    return DropdownButtonFormField<int?>(
      value: value,
      decoration: InputDecoration(labelText: label, isDense: true),
      items: items,
      onChanged: onChanged,
    );
  }
}
