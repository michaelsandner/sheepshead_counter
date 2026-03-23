import 'package:equatable/equatable.dart';
import '../../domain/entities/game.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<Game> games;
  const HomeLoaded({required this.games});
  @override
  List<Object?> get props => [games];
}

class HomeError extends HomeState {
  final String message;
  const HomeError({required this.message});
  @override
  List<Object?> get props => [message];
}
