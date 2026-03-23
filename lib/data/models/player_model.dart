import 'package:sheepshead_counter/domain/entities/player.dart';

class PlayerModel extends Player {
  const PlayerModel({
    required super.id,
    required super.name,
    super.points = 0,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      points: json['points'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'points': points,
      };

  factory PlayerModel.fromEntity(Player player) {
    return PlayerModel(id: player.id, name: player.name, points: player.points);
  }
}
