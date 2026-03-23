import 'package:sheepshead_counter/features/game/domain/entities/game_config.dart';

class GameConfigModel extends GameConfig {
  const GameConfigModel({
    super.rufspielPoints = 10,
    super.soloPoints = 30,
    super.wenzPoints = 30,
    super.laufendePoints = 5,
  });

  factory GameConfigModel.fromJson(Map<String, dynamic> json) {
    return GameConfigModel(
      rufspielPoints: json['rufspielPoints'] as int? ?? 10,
      soloPoints: json['soloPoints'] as int? ?? 30,
      wenzPoints: json['wenzPoints'] as int? ?? 30,
      laufendePoints: json['laufendePoints'] as int? ?? 5,
    );
  }

  Map<String, dynamic> toJson() => {
        'rufspielPoints': rufspielPoints,
        'soloPoints': soloPoints,
        'wenzPoints': wenzPoints,
        'laufendePoints': laufendePoints,
      };

  factory GameConfigModel.fromEntity(GameConfig config) {
    return GameConfigModel(
      rufspielPoints: config.rufspielPoints,
      soloPoints: config.soloPoints,
      wenzPoints: config.wenzPoints,
      laufendePoints: config.laufendePoints,
    );
  }
}
