import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/game_config.dart';
import '../../domain/usecases/create_game_use_case.dart';
import '../../domain/usecases/get_all_games_use_case.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetAllGamesUseCase getAllGames;
  final CreateGameUseCase createGame;

  HomeCubit({required this.getAllGames, required this.createGame})
      : super(const HomeInitial());

  Future<void> loadGames() async {
    emit(const HomeLoading());
    try {
      final games = await getAllGames();
      emit(HomeLoaded(games: games));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  Future<void> newGame({
    required String name,
    required List<String> playerNames,
    GameConfig config = const GameConfig(),
  }) async {
    try {
      final game = await createGame(name: name, playerNames: playerNames, config: config);
      final games = await getAllGames();
      emit(HomeGameCreated(game: game, games: games));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }
}
