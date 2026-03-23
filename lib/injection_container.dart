import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/game/data/datasources/game_local_data_source.dart';
import 'features/game/data/repositories/game_repository_impl.dart';
import 'features/game/domain/repositories/game_repository.dart';
import 'features/game/domain/usecases/get_all_games_use_case.dart';
import 'features/game/domain/usecases/save_game_use_case.dart';
import 'features/game/domain/usecases/create_game_use_case.dart';
import 'features/game/presentation/cubits/home_cubit.dart';
import 'features/game/presentation/cubits/game_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Data sources
  sl.registerLazySingleton<GameLocalDataSource>(
    () => GameLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Repositories
  sl.registerLazySingleton<GameRepository>(
    () => GameRepositoryImpl(localDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllGamesUseCase(sl()));
  sl.registerLazySingleton(() => SaveGameUseCase(sl()));
  sl.registerLazySingleton(() => CreateGameUseCase(sl()));

  // Cubits
  sl.registerFactory(
    () => HomeCubit(
      getAllGames: sl(),
      createGame: sl(),
    ),
  );
  sl.registerFactory(
    () => GameCubit(
      saveGame: sl(),
    ),
  );
}
