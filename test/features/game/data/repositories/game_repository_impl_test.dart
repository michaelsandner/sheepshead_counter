import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sheepshead_counter/features/game/data/datasources/game_local_data_source.dart';
import 'package:sheepshead_counter/features/game/data/models/game_model.dart';
import 'package:sheepshead_counter/features/game/data/repositories/game_repository_impl.dart';
import 'package:sheepshead_counter/features/game/domain/entities/game_config.dart';
import 'package:sheepshead_counter/features/game/domain/entities/player.dart';

class MockGameLocalDataSource extends Mock implements GameLocalDataSource {}

final _gameModel = GameModel(
  id: 'g1',
  name: 'Test',
  players: const [Player(id: 'p1', name: 'Anna')],
  config: const GameConfig(),
  entries: const [],
  createdAt: DateTime(2024),
);

void main() {
  late GameRepositoryImpl repository;
  late MockGameLocalDataSource mockDataSource;

  setUpAll(() {
    registerFallbackValue(_gameModel);
  });

  setUp(() {
    mockDataSource = MockGameLocalDataSource();
    repository = GameRepositoryImpl(localDataSource: mockDataSource);
  });

  group('Given the data source returns games', () {
    setUp(() {
      when(() => mockDataSource.getAllGames())
          .thenAnswer((_) async => [_gameModel]);
    });

    group('When getAllGames is called', () {
      test('Then returns the list of games', () async {
        final result = await repository.getAllGames();
        expect(result.length, 1);
        expect(result.first.id, 'g1');
      });
    });
  });

  group('Given a game to save', () {
    setUp(() {
      when(() => mockDataSource.saveGame(any())).thenAnswer((_) async {});
    });

    group('When saveGame is called', () {
      test('Then delegates to the data source', () async {
        await repository.saveGame(_gameModel);
        verify(() => mockDataSource.saveGame(any())).called(1);
      });
    });
  });
}
