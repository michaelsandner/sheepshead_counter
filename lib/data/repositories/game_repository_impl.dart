import 'package:sheepshead_counter/domain/entities/game.dart';
import 'package:sheepshead_counter/domain/repositories/game_repository.dart';
import 'package:sheepshead_counter/data/datasources/game_local_data_source.dart';
import 'package:sheepshead_counter/data/models/game_model.dart';

class GameRepositoryImpl implements GameRepository {
  final GameLocalDataSource localDataSource;

  GameRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Game>> getAllGames() {
    return localDataSource.getAllGames();
  }

  @override
  Future<void> saveGame(Game game) {
    return localDataSource.saveGame(GameModel.fromEntity(game));
  }
}
