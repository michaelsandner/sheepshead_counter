import 'package:sheepshead_counter/domain/entities/game.dart';
import 'package:sheepshead_counter/domain/repositories/game_repository.dart';

class GetAllGamesUseCase {
  final GameRepository repository;

  GetAllGamesUseCase(this.repository);

  Future<List<Game>> call() {
    return repository.getAllGames();
  }
}
