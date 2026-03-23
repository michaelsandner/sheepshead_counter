import '../entities/game_config.dart';
import '../entities/game_entry.dart';
import '../entities/game_mode.dart';

class CalculatePointsUseCase {
  int call(GameEntry entry, GameConfig config) {
    int baseValue = _getGameModePoints(entry.gameMode, config);
    if (entry.laufende != null && entry.laufende! >= 3) {
      baseValue += entry.laufende! * config.laufendePoints;
    }
    int value = baseValue;
    if (entry.spritze != null) {
      for (int i = 0; i < entry.spritze!; i++) {
        value *= 2;
      }
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
    }
  }
}
