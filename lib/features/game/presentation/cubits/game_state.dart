import 'package:equatable/equatable.dart';
import 'package:sheepshead_counter/features/game/domain/entities/game.dart';

abstract class GameState extends Equatable {
  const GameState();
  @override
  List<Object?> get props => [];
}

class GameInitial extends GameState {
  const GameInitial();
}

class GameLoaded extends GameState {
  final Game game;
  const GameLoaded({required this.game});
  @override
  List<Object?> get props => [game];
}

class GameError extends GameState {
  final String message;
  const GameError({required this.message});
  @override
  List<Object?> get props => [message];
}
