import '../entities/game.dart';
import '../repositories/game_repository.dart';

class SaveGameUseCase {
  final GameRepository repository;

  SaveGameUseCase(this.repository);

  Future<void> call(Game game) {
    return repository.saveGame(game);
  }
}
