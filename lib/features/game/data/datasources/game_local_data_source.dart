import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sheepshead_counter/features/game/data/models/game_model.dart';

abstract class GameLocalDataSource {
  Future<List<GameModel>> getAllGames();
  Future<void> saveGame(GameModel game);
}

class GameLocalDataSourceImpl implements GameLocalDataSource {
  static const _key = 'games';
  final SharedPreferences sharedPreferences;

  GameLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<GameModel>> getAllGames() async {
    final jsonString = sharedPreferences.getString(_key);
    if (jsonString == null) {
      return [];
    }
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList
        .map((j) => GameModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveGame(GameModel game) async {
    final games = await getAllGames();
    final index = games.indexWhere((g) => g.id == game.id);
    if (index >= 0) {
      games[index] = game;
    } else {
      games.add(game);
    }
    final jsonString = json.encode(games.map((g) => g.toJson()).toList());
    await sharedPreferences.setString(_key, jsonString);
  }
}
