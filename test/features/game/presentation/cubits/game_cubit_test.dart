import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sheepshead_counter/domain/entities/game.dart';
import 'package:sheepshead_counter/domain/entities/game_config.dart';
import 'package:sheepshead_counter/domain/entities/game_mode.dart';
import 'package:sheepshead_counter/domain/entities/player.dart';
import 'package:sheepshead_counter/domain/usecases/save_game_use_case.dart';
import 'package:sheepshead_counter/features/game/presentation/cubits/game_cubit.dart';
import 'package:sheepshead_counter/features/game/presentation/cubits/game_state.dart';

class MockSaveGameUseCase extends Mock implements SaveGameUseCase {}

final _players = [
  const Player(id: 'p1', name: 'Anna'),
  const Player(id: 'p2', name: 'Bob'),
  const Player(id: 'p3', name: 'Cara'),
  const Player(id: 'p4', name: 'Dan'),
];

final _game = Game(
  id: 'g1',
  name: 'Testspiel',
  players: _players,
  config: const GameConfig(),
  entries: const [],
  createdAt: DateTime(2024),
);

final _players3 = [
  const Player(id: 'p1', name: 'Anna'),
  const Player(id: 'p2', name: 'Bob'),
  const Player(id: 'p3', name: 'Cara'),
];

final _game3 = Game(
  id: 'g2',
  name: 'Testspiel 3 Spieler',
  players: _players3,
  config: const GameConfig(),
  entries: const [],
  createdAt: DateTime(2024),
);

void main() {
  late GameCubit cubit;
  late MockSaveGameUseCase mockSave;

  setUpAll(() {
    registerFallbackValue(_game);
  });

  setUp(() {
    mockSave = MockSaveGameUseCase();
    cubit = GameCubit(saveGame: mockSave);
    when(() => mockSave(any())).thenAnswer((_) async {});
  });

  tearDown(() => cubit.close());

  group('Given a loaded game', () {
    setUp(() => cubit.loadGame(_game));

    group('When a Rufspiel entry is added with 2 winners', () {
      blocTest<GameCubit, GameState>(
        'Then points are applied correctly: winners +10, losers -10',
        build: () => cubit,
        seed: () => GameLoaded(game: _game),
        act: (c) => c.addEntry(
          gameMode: GameMode.rufspiel,
          winnerIds: ['p1', 'p2'],
        ),
        verify: (c) {
          final state = c.state as GameLoaded;
          final anna = state.game.players.firstWhere((p) => p.id == 'p1');
          final bob = state.game.players.firstWhere((p) => p.id == 'p2');
          final cara = state.game.players.firstWhere((p) => p.id == 'p3');
          final dan = state.game.players.firstWhere((p) => p.id == 'p4');
          expect(anna.points, 10);
          expect(bob.points, 10);
          expect(cara.points, -10);
          expect(dan.points, -10);
        },
      );
    });

    group('When a Solo entry is added with 1 winner in a 4-player game', () {
      blocTest<GameCubit, GameState>(
        'Then points are applied correctly: winner +90, losers -30',
        build: () => cubit,
        seed: () => GameLoaded(game: _game),
        act: (c) => c.addEntry(
          gameMode: GameMode.solo,
          winnerIds: ['p1'],
        ),
        verify: (c) {
          final state = c.state as GameLoaded;
          final anna = state.game.players.firstWhere((p) => p.id == 'p1');
          final bob = state.game.players.firstWhere((p) => p.id == 'p2');
          final cara = state.game.players.firstWhere((p) => p.id == 'p3');
          final dan = state.game.players.firstWhere((p) => p.id == 'p4');
          expect(anna.points, 90);
          expect(bob.points, -30);
          expect(cara.points, -30);
          expect(dan.points, -30);
        },
      );
    });

    group('When finishGame is called', () {
      blocTest<GameCubit, GameState>(
        'Then game is marked as finished',
        build: () => cubit,
        seed: () => GameLoaded(game: _game),
        act: (c) => c.finishGame(),
        verify: (c) {
          final state = c.state as GameLoaded;
          expect(state.game.isFinished, true);
        },
      );
    });
  });

  group('Given a loaded 3-player game', () {
    setUp(() => cubit.loadGame(_game3));

    group('When a Solo entry is added with 1 winner', () {
      blocTest<GameCubit, GameState>(
        'Then points are applied correctly: winner +60, losers -30',
        build: () => cubit,
        seed: () => GameLoaded(game: _game3),
        act: (c) => c.addEntry(
          gameMode: GameMode.solo,
          winnerIds: ['p1'],
        ),
        verify: (c) {
          final state = c.state as GameLoaded;
          final anna = state.game.players.firstWhere((p) => p.id == 'p1');
          final bob = state.game.players.firstWhere((p) => p.id == 'p2');
          final cara = state.game.players.firstWhere((p) => p.id == 'p3');
          expect(anna.points, 60);
          expect(bob.points, -30);
          expect(cara.points, -30);
        },
      );
    });
  });
}
