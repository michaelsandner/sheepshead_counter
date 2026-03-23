import 'package:sheepshead_counter/domain/entities/game.dart';
import 'package:sheepshead_counter/domain/repositories/game_repository.dart';

class SaveGameUseCase {
  final GameRepository repository;

  SaveGameUseCase(this.repository);

  Future<void> call(Game game) {
    return repository.saveGame(game);
  }
}
