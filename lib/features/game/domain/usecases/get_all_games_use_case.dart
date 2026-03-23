import '../entities/game.dart';
import '../repositories/game_repository.dart';

class GetAllGamesUseCase {
  final GameRepository repository;

  GetAllGamesUseCase(this.repository);

  Future<List<Game>> call() {
    return repository.getAllGames();
  }
}
