import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sheepshead_counter/features/game/domain/entities/game.dart';
import 'package:sheepshead_counter/features/game/domain/entities/game_config.dart';
import 'package:sheepshead_counter/features/game/domain/entities/player.dart';
import 'package:sheepshead_counter/features/game/domain/repositories/game_repository.dart';
import 'package:sheepshead_counter/features/game/domain/usecases/save_game_use_case.dart';

class MockGameRepository extends Mock implements GameRepository {}

final _game = Game(
  id: 'g1',
  name: 'Testspiel',
  players: const [Player(id: 'p1', name: 'Anna')],
  config: const GameConfig(),
  entries: const [],
  createdAt: DateTime(2024),
);

void main() {
  late SaveGameUseCase useCase;
  late MockGameRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(_game);
  });

  setUp(() {
    mockRepository = MockGameRepository();
    useCase = SaveGameUseCase(mockRepository);
  });

  group('Given a game to save', () {
    setUp(() {
      when(() => mockRepository.saveGame(any())).thenAnswer((_) async {});
    });

    group('When call is invoked', () {
      test('Then delegates to the repository', () async {
        await useCase(_game);
        verify(() => mockRepository.saveGame(_game)).called(1);
      });
    });
  });
}
