import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sheepshead_counter/features/game/domain/entities/game.dart';
import 'package:sheepshead_counter/features/game/domain/entities/game_config.dart';
import 'package:sheepshead_counter/features/game/domain/entities/player.dart';
import 'package:sheepshead_counter/features/game/domain/repositories/game_repository.dart';
import 'package:sheepshead_counter/features/game/domain/usecases/create_game_use_case.dart';

class MockGameRepository extends Mock implements GameRepository {}

final _fallbackGame = Game(
  id: '',
  name: '',
  players: const [Player(id: '', name: '')],
  config: const GameConfig(),
  entries: const [],
  createdAt: DateTime(2024),
);

void main() {
  late CreateGameUseCase useCase;
  late MockGameRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(_fallbackGame);
  });

  setUp(() {
    mockRepository = MockGameRepository();
    useCase = CreateGameUseCase(mockRepository);
    when(() => mockRepository.saveGame(any())).thenAnswer((_) async {});
  });

  group('Given valid player names', () {
    group('When creating a game', () {
      test('Then saves and returns the new game', () async {
        final game = await useCase(
          name: 'Testspiel',
          playerNames: ['Anna', 'Bob', 'Cara', 'Dan'],
        );
        expect(game.name, 'Testspiel');
        expect(game.players.length, 4);
        expect(game.isFinished, false);
        verify(() => mockRepository.saveGame(any())).called(1);
      });
    });
  });
}
