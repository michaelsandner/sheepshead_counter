import 'package:equatable/equatable.dart';
import 'package:sheepshead_counter/features/game/domain/entities/game_mode.dart';

class GameEntry extends Equatable {
  final String id;
  final GameMode gameMode;
  final List<String> winnerIds;
  final int? spritze;
  final int? laufende;
  final DateTime timestamp;

  const GameEntry({
    required this.id,
    required this.gameMode,
    required this.winnerIds,
    this.spritze,
    this.laufende,
    required this.timestamp,
  });

  @override
  List<Object?> get props =>
      [id, gameMode, winnerIds, spritze, laufende, timestamp];
}
