import 'package:equatable/equatable.dart';
import 'game_config.dart';
import 'game_entry.dart';
import 'player.dart';

class Game extends Equatable {
  final String id;
  final String name;
  final List<Player> players;
  final GameConfig config;
  final List<GameEntry> entries;
  final bool isFinished;
  final DateTime createdAt;

  const Game({
    required this.id,
    required this.name,
    required this.players,
    required this.config,
    required this.entries,
    this.isFinished = false,
    required this.createdAt,
  });

  Game copyWith({
    String? id,
    String? name,
    List<Player>? players,
    GameConfig? config,
    List<GameEntry>? entries,
    bool? isFinished,
    DateTime? createdAt,
  }) {
    return Game(
      id: id ?? this.id,
      name: name ?? this.name,
      players: players ?? this.players,
      config: config ?? this.config,
      entries: entries ?? this.entries,
      isFinished: isFinished ?? this.isFinished,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, name, players, config, entries, isFinished, createdAt];
}
