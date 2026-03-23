import '../entities/game.dart';

abstract class GameRepository {
  Future<List<Game>> getAllGames();
  Future<void> saveGame(Game game);
}
