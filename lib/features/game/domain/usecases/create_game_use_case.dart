import 'package:uuid/uuid.dart';
import '../entities/game.dart';
import '../entities/game_config.dart';
import '../entities/player.dart';
import '../repositories/game_repository.dart';

class CreateGameUseCase {
  final GameRepository repository;
  final _uuid = const Uuid();

  CreateGameUseCase(this.repository);

  Future<Game> call({
    required String name,
    required List<String> playerNames,
    GameConfig config = const GameConfig(),
  }) async {
    final players = playerNames
        .map((n) => Player(id: _uuid.v4(), name: n, points: 0))
        .toList();
    final game = Game(
      id: _uuid.v4(),
      name: name,
      players: players,
      config: config,
      entries: const [],
      isFinished: false,
      createdAt: DateTime.now(),
    );
    await repository.saveGame(game);
    return game;
  }
}
