import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sheepshead_counter/features/game/domain/entities/game.dart';
import 'package:sheepshead_counter/features/game/domain/entities/game_config.dart';
import 'package:sheepshead_counter/features/game/domain/entities/player.dart';
import 'package:sheepshead_counter/features/game/domain/usecases/create_game_use_case.dart';
import 'package:sheepshead_counter/features/game/domain/usecases/get_all_games_use_case.dart';
import 'package:sheepshead_counter/features/game/presentation/cubits/home_cubit.dart';
import 'package:sheepshead_counter/features/game/presentation/cubits/home_state.dart';

class MockGetAllGamesUseCase extends Mock implements GetAllGamesUseCase {}

class MockCreateGameUseCase extends Mock implements CreateGameUseCase {}

final _sampleGame = Game(
  id: '1',
  name: 'Testspiel',
  players: const [
    Player(id: 'p1', name: 'Anna'),
    Player(id: 'p2', name: 'Bob'),
    Player(id: 'p3', name: 'Cara'),
    Player(id: 'p4', name: 'Dan'),
  ],
  config: const GameConfig(),
  entries: const [],
  createdAt: DateTime(2024),
);

void main() {
  late HomeCubit cubit;
  late MockGetAllGamesUseCase mockGetAll;
  late MockCreateGameUseCase mockCreate;

  setUp(() {
    mockGetAll = MockGetAllGamesUseCase();
    mockCreate = MockCreateGameUseCase();
    cubit = HomeCubit(getAllGames: mockGetAll, createGame: mockCreate);
  });

  tearDown(() => cubit.close());

  group('Given the repository has games', () {
    setUp(() {
      when(() => mockGetAll()).thenAnswer((_) async => [_sampleGame]);
    });

    group('When loadGames is called', () {
      blocTest<HomeCubit, HomeState>(
        'Then emits Loading then Loaded with games',
        build: () => cubit,
        act: (c) => c.loadGames(),
        expect: () => [
          const HomeLoading(),
          HomeLoaded(games: [_sampleGame]),
        ],
      );
    });
  });

  group('Given the repository throws an error', () {
    setUp(() {
      when(() => mockGetAll()).thenThrow(Exception('DB error'));
    });

    group('When loadGames is called', () {
      blocTest<HomeCubit, HomeState>(
        'Then emits Loading then Error',
        build: () => cubit,
        act: (c) => c.loadGames(),
        expect: () => [
          const HomeLoading(),
          isA<HomeError>(),
        ],
      );
    });
  });

  group('Given a new game can be created', () {
    setUp(() {
      when(
        () => mockCreate(
          name: any(named: 'name'),
          playerNames: any(named: 'playerNames'),
          config: any(named: 'config'),
        ),
      ).thenAnswer((_) async => _sampleGame);
      when(() => mockGetAll()).thenAnswer((_) async => [_sampleGame]);
    });

    group('When newGame is called', () {
      blocTest<HomeCubit, HomeState>(
        'Then emits HomeGameCreated with the new game',
        build: () => cubit,
        act: (c) => c.newGame(
          name: 'Testspiel',
          playerNames: ['Anna', 'Bob', 'Cara', 'Dan'],
        ),
        expect: () => [
          isA<HomeGameCreated>()
              .having((s) => s.game, 'game', _sampleGame)
              .having((s) => s.games, 'games', [_sampleGame]),
        ],
      );
    });
  });
}
