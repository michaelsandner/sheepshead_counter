import 'package:equatable/equatable.dart';

class Player extends Equatable {
  final String id;
  final String name;
  final int points;

  const Player({
    required this.id,
    required this.name,
    this.points = 0,
  });

  Player copyWith({String? id, String? name, int? points}) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      points: points ?? this.points,
    );
  }

  @override
  List<Object?> get props => [id, name, points];
}
