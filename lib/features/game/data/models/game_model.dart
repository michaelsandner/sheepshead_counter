import 'package:sheepshead_counter/features/game/domain/entities/game.dart';
import 'package:sheepshead_counter/features/game/data/models/game_config_model.dart';
import 'package:sheepshead_counter/features/game/data/models/game_entry_model.dart';
import 'package:sheepshead_counter/features/game/data/models/player_model.dart';

class GameModel extends Game {
  const GameModel({
    required super.id,
    required super.name,
    required super.players,
    required super.config,
    required super.entries,
    super.isFinished = false,
    required super.createdAt,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'] as String,
      name: json['name'] as String,
      players: (json['players'] as List)
          .map((p) => PlayerModel.fromJson(p as Map<String, dynamic>))
          .toList(),
      config: GameConfigModel.fromJson(json['config'] as Map<String, dynamic>),
      entries: (json['entries'] as List)
          .map((e) => GameEntryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isFinished: json['isFinished'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'players':
            players.map((p) => PlayerModel.fromEntity(p).toJson()).toList(),
        'config': GameConfigModel.fromEntity(config).toJson(),
        'entries':
            entries.map((e) => GameEntryModel.fromEntity(e).toJson()).toList(),
        'isFinished': isFinished,
        'createdAt': createdAt.toIso8601String(),
      };

  factory GameModel.fromEntity(Game game) {
    return GameModel(
      id: game.id,
      name: game.name,
      players: game.players,
      config: game.config,
      entries: game.entries,
      isFinished: game.isFinished,
      createdAt: game.createdAt,
    );
  }
}
