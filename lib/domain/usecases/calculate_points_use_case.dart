import 'package:sheepshead_counter/domain/entities/game_config.dart';
import 'package:sheepshead_counter/domain/entities/game_entry.dart';
import 'package:sheepshead_counter/domain/entities/game_mode.dart';

class CalculatePointsUseCase {
  int call(GameEntry entry, GameConfig config) {
    int baseValue = _getGameModePoints(entry.gameMode, config);
    if (entry.laufende != null && entry.laufende! >= 3) {
      baseValue += entry.laufende! * config.laufendePoints;
    }
    int value = baseValue;
    if (entry.spritze != null && entry.spritze! > 0) {
      // Left-shift = multiply by 2^spritze (max picker value is 3, no overflow risk)
      value = value << entry.spritze!;
    }
    return value;
  }

  int _getGameModePoints(GameMode mode, GameConfig config) {
    switch (mode) {
      case GameMode.rufspiel:
        return config.rufspielPoints;
      case GameMode.solo:
        return config.soloPoints;
      case GameMode.wenz:
        return config.wenzPoints;
      case GameMode.geier:
        return config.geierPoints;
    }
  }
}
