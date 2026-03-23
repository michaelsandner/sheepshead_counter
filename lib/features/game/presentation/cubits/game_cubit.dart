import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:sheepshead_counter/features/game/domain/entities/game.dart';
import 'package:sheepshead_counter/features/game/domain/entities/game_entry.dart';
import 'package:sheepshead_counter/features/game/domain/entities/game_mode.dart';
import 'package:sheepshead_counter/features/game/domain/entities/player.dart';
import 'package:sheepshead_counter/features/game/domain/usecases/calculate_points_use_case.dart';
import 'package:sheepshead_counter/features/game/domain/usecases/save_game_use_case.dart';
import 'package:sheepshead_counter/features/game/presentation/cubits/game_state.dart';

class GameCubit extends Cubit<GameState> {
  final SaveGameUseCase saveGame;
  final _uuid = const Uuid();
  final _calculatePoints = CalculatePointsUseCase();

  GameCubit({required this.saveGame}) : super(const GameInitial());

  void loadGame(Game game) {
    emit(GameLoaded(game: game));
  }

  Future<void> addEntry({
    required GameMode gameMode,
    required List<String> winnerIds,
    int? spritze,
    int? laufende,
  }) async {
    final currentState = state;
    if (currentState is! GameLoaded) {
      return;
    }

    final entry = GameEntry(
      id: _uuid.v4(),
      gameMode: gameMode,
      winnerIds: winnerIds,
      spritze: spritze,
      laufende: laufende,
      timestamp: DateTime.now(),
    );

    final game = currentState.game;
    final points = _calculatePoints(entry, game.config);
    final updatedPlayers = _applyPoints(game.players, entry, points);
    final updatedGame = game.copyWith(
      players: updatedPlayers,
      entries: [...game.entries, entry],
    );

    await saveGame(updatedGame);
    emit(GameLoaded(game: updatedGame));
  }

  Future<void> finishGame() async {
    final currentState = state;
    if (currentState is! GameLoaded) {
      return;
    }
    final updatedGame = currentState.game.copyWith(isFinished: true);
    await saveGame(updatedGame);
    emit(GameLoaded(game: updatedGame));
  }

  List<Player> _applyPoints(
    List<Player> players,
    GameEntry entry,
    int points,
  ) {
    return players.map((player) {
      final isWinner = entry.winnerIds.contains(player.id);
      int delta = 0;

      switch (entry.gameMode) {
        case GameMode.rufspiel:
          // 2 winners, 2 losers: each winner gets +points, each loser gets -points
          delta = isWinner ? points : -points;
          break;
        case GameMode.solo:
        case GameMode.wenz:
          // 1 winner gets +3*points, 3 losers each get -points
          delta = isWinner ? points * 3 : -points;
          break;
      }
      return player.copyWith(points: player.points + delta);
    }).toList();
  }
}
