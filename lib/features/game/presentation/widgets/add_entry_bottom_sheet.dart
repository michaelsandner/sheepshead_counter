import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/game.dart';
import '../../domain/entities/game_mode.dart';
import '../../domain/entities/player.dart';
import '../cubits/game_cubit.dart';

class AddEntryBottomSheet extends StatefulWidget {
  final Game game;
  const AddEntryBottomSheet({super.key, required this.game});

  @override
  State<AddEntryBottomSheet> createState() => _AddEntryBottomSheetState();
}

class _AddEntryBottomSheetState extends State<AddEntryBottomSheet> {
  GameMode _selectedMode = GameMode.rufspiel;
  final Set<String> _selectedWinnerIds = {};
  int? _spritze;
  int? _laufende;

  bool get _isRufspiel => _selectedMode == GameMode.rufspiel;
  int get _requiredWinners => _isRufspiel ? 2 : 1;

  List<Player> get _players => widget.game.players;

  // Rufspiel requires 4 players; with 3 players only Solo/Wenz available
  List<GameMode> get _availableModes {
    if (_players.length < 4) return [GameMode.solo, GameMode.wenz];
    return GameMode.values;
  }

  @override
  void initState() {
    super.initState();
    if (_players.length < 4) {
      _selectedMode = GameMode.solo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
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
          Text(
            'Gewinner ($_requiredWinners auswählen):',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          _WinnerSelector(
            players: _players,
            selectedIds: _selectedWinnerIds,
            maxSelectable: _requiredWinners,
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
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed:
                  _selectedWinnerIds.length == _requiredWinners ? _submit : null,
              child: const Text('Hinzufügen'),
            ),
          ),
          const SizedBox(height: 16),
        ],
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
    }
  }
}

class _WinnerSelector extends StatelessWidget {
  final List<Player> players;
  final Set<String> selectedIds;
  final int maxSelectable;
  final void Function(String id, bool selected) onChanged;

  const _WinnerSelector({
    required this.players,
    required this.selectedIds,
    required this.maxSelectable,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: players.map((player) {
        final isSelected = selectedIds.contains(player.id);
        return FilterChip(
          label: Text(player.name),
          selected: isSelected,
          onSelected: (selected) => onChanged(player.id, selected),
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
      const DropdownMenuItem<int?>(value: null, child: Text('-')),
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
