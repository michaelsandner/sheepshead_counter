import 'package:flutter_test/flutter_test.dart';
import 'package:sheepshead_counter/domain/entities/game_config.dart';
import 'package:sheepshead_counter/domain/entities/game_entry.dart';
import 'package:sheepshead_counter/domain/entities/game_mode.dart';
import 'package:sheepshead_counter/domain/usecases/calculate_points_use_case.dart';

void main() {
  late CalculatePointsUseCase useCase;
  const config = GameConfig();

  setUp(() {
    useCase = CalculatePointsUseCase();
  });

  group('Given a Rufspiel entry with no extras', () {
    group('When calculating points', () {
      test('Then returns base rufspiel points', () {
        final entry = GameEntry(
          id: '1',
          gameMode: GameMode.rufspiel,
          winnerIds: const ['a', 'b'],
          timestamp: DateTime(2024),
        );
        expect(useCase(entry, config), 10);
      });
    });
  });

  group('Given a Solo entry with Laufende >= 3', () {
    group('When calculating points', () {
      test('Then adds laufende bonus', () {
        final entry = GameEntry(
          id: '2',
          gameMode: GameMode.solo,
          winnerIds: const ['a'],
          laufende: 3,
          timestamp: DateTime(2024),
        );
        // 30 + 3*5 = 45
        expect(useCase(entry, config), 45);
      });
    });
  });

  group('Given a Wenz entry with Spritze=1', () {
    group('When calculating points', () {
      test('Then doubles the value', () {
        final entry = GameEntry(
          id: '3',
          gameMode: GameMode.wenz,
          winnerIds: const ['a'],
          spritze: 1,
          timestamp: DateTime(2024),
        );
        // 30 * 2 = 60
        expect(useCase(entry, config), 60);
      });
    });
  });

  group('Given a Rufspiel with Laufende=2 (below minimum)', () {
    group('When calculating points', () {
      test('Then does not add laufende bonus', () {
        final entry = GameEntry(
          id: '4',
          gameMode: GameMode.rufspiel,
          winnerIds: const ['a', 'b'],
          laufende: 2,
          timestamp: DateTime(2024),
        );
        expect(useCase(entry, config), 10);
      });
    });
  });

  group('Given a Solo with Laufende=3 and Spritze=2', () {
    group('When calculating points', () {
      test('Then applies laufende then doubles twice', () {
        final entry = GameEntry(
          id: '5',
          gameMode: GameMode.solo,
          winnerIds: const ['a'],
          laufende: 3,
          spritze: 2,
          timestamp: DateTime(2024),
        );
        // (30 + 15) * 2^2 = 45 * 4 = 180
        expect(useCase(entry, config), 180);
      });
    });
  });

  group('Given a Rufspiel entry with Spritze=3', () {
    group('When calculating points', () {
      test('Then doubles the value three times (x8)', () {
        final entry = GameEntry(
          id: '6',
          gameMode: GameMode.rufspiel,
          winnerIds: const ['a', 'b'],
          spritze: 3,
          timestamp: DateTime(2024),
        );
        // 10 * 2^3 = 80
        expect(useCase(entry, config), 80);
      });
    });
  });
}
