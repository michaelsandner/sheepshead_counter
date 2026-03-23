import '../../domain/entities/game_entry.dart';
import '../../domain/entities/game_mode.dart';

class GameEntryModel extends GameEntry {
  const GameEntryModel({
    required super.id,
    required super.gameMode,
    required super.winnerIds,
    super.spritze,
    super.laufende,
    required super.timestamp,
  });

  factory GameEntryModel.fromJson(Map<String, dynamic> json) {
    return GameEntryModel(
      id: json['id'] as String,
      gameMode: GameMode.values.byName(json['gameMode'] as String),
      winnerIds: List<String>.from(json['winnerIds'] as List),
      spritze: json['spritze'] as int?,
      laufende: json['laufende'] as int?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'gameMode': gameMode.name,
        'winnerIds': winnerIds,
        'spritze': spritze,
        'laufende': laufende,
        'timestamp': timestamp.toIso8601String(),
      };

  factory GameEntryModel.fromEntity(GameEntry entry) {
    return GameEntryModel(
      id: entry.id,
      gameMode: entry.gameMode,
      winnerIds: entry.winnerIds,
      spritze: entry.spritze,
      laufende: entry.laufende,
      timestamp: entry.timestamp,
    );
  }
}
