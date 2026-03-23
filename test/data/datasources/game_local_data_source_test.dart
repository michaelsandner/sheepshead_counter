import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sheepshead_counter/data/datasources/game_local_data_source.dart';
import 'package:sheepshead_counter/data/models/game_model.dart';
import 'package:sheepshead_counter/domain/entities/game_config.dart';
import 'package:sheepshead_counter/domain/entities/player.dart';

final _gameModel = GameModel(
  id: 'g1',
  name: 'Testspiel',
  players: const [Player(id: 'p1', name: 'Anna')],
  config: const GameConfig(),
  entries: const [],
  createdAt: DateTime(2024),
);

void main() {
  late GameLocalDataSourceImpl dataSource;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<GameLocalDataSourceImpl> createDataSource() async {
    final prefs = await SharedPreferences.getInstance();
    return GameLocalDataSourceImpl(sharedPreferences: prefs);
  }

  group('Given no stored games', () {
    group('When getAllGames is called', () {
      test('Then returns an empty list', () async {
        dataSource = await createDataSource();
        final result = await dataSource.getAllGames();
        expect(result, isEmpty);
      });
    });
  });

  group('Given a game is saved', () {
    group('When getAllGames is called', () {
      test('Then returns the saved game', () async {
        dataSource = await createDataSource();
        await dataSource.saveGame(_gameModel);

        final result = await dataSource.getAllGames();
        expect(result.length, 1);
        expect(result.first.id, 'g1');
        expect(result.first.name, 'Testspiel');
      });
    });
  });

  group('Given a game already exists', () {
    group('When saveGame is called with the same id', () {
      test('Then updates the existing game', () async {
        dataSource = await createDataSource();
        await dataSource.saveGame(_gameModel);

        final updatedGame = GameModel(
          id: 'g1',
          name: 'Updated',
          players: const [Player(id: 'p1', name: 'Anna')],
          config: const GameConfig(),
          entries: const [],
          createdAt: DateTime(2024),
        );
        await dataSource.saveGame(updatedGame);

        final result = await dataSource.getAllGames();
        expect(result.length, 1);
        expect(result.first.name, 'Updated');
      });
    });
  });
}
