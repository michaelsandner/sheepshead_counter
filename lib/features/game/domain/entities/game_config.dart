import 'package:equatable/equatable.dart';

class GameConfig extends Equatable {
  final int rufspielPoints;
  final int soloPoints;
  final int wenzPoints;
  final int laufendePoints;

  const GameConfig({
    this.rufspielPoints = 10,
    this.soloPoints = 30,
    this.wenzPoints = 30,
    this.laufendePoints = 5,
  });

  GameConfig copyWith({
    int? rufspielPoints,
    int? soloPoints,
    int? wenzPoints,
    int? laufendePoints,
  }) {
    return GameConfig(
      rufspielPoints: rufspielPoints ?? this.rufspielPoints,
      soloPoints: soloPoints ?? this.soloPoints,
      wenzPoints: wenzPoints ?? this.wenzPoints,
      laufendePoints: laufendePoints ?? this.laufendePoints,
    );
  }

  @override
  List<Object?> get props => [rufspielPoints, soloPoints, wenzPoints, laufendePoints];
}
