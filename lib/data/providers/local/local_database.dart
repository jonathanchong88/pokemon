import 'dart:convert';

import 'package:flutter_app_pokemon/data/data.dart';
import 'package:sqflite/sqflite.dart';

import '../../../configs/config.dart';

class LocalDatabase {
  /// For Pokemon table
  final String _pokemonsTableData = "pokemons"; // Table Name

  // All Columns
  final String _colPokemonName = "name";
  final String _colPokemonUrl = "url";
  final String _colPokemonIsFavourite = "isFavourite";
  final String _colPokemonId = "id";

  /// For Pokemon table
  final String _pokemonDetailTableData = "pokemon_detail"; // Table Name

  // All Columns
  final String _colPokemonDetailName = "name";
  final String _colPokemonDetailAbilities = "abilities";

  /// Create Singleton Objects(Only Created once in the whole application)
  static late LocalDatabase _localStorageHelper =
      LocalDatabase._createInstance();
  static late Database _database;

  /// Instantiate the obj
  LocalDatabase._createInstance(); // Named Constructor

  /// For access Singleton object
  factory LocalDatabase() {
    _localStorageHelper = LocalDatabase._createInstance();
    return _localStorageHelper;
  }

  /// Getter for taking instance of database
  Future<Database> get database async {
    _database = await initializeDatabase();
    return _database;
  }

  /// For make a database
  Future<Database> initializeDatabase() async {
    /// Get the directory path to store the database
    final String desirePath = await getDatabasesPath();

    final String path = '$desirePath/pokemon_local_storage.db';

    // create the database
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await createTableToStorePokemonData(db);
      await createTableToStorePokemonDetailData(db);
    });
  }

  /// Table for store pokemon data Table
  Future<void> createTableToStorePokemonData(Database db) async {
    try {
      await db.execute(
          "CREATE TABLE $_pokemonsTableData($_colPokemonName TEXT PRIMARY KEY, $_colPokemonUrl TEXT, $_colPokemonIsFavourite NUMERIC, $_colPokemonId INTEGER)");

      print('Pokemon table created');
    } catch (e) {
      print('Error in Create Pokemon Table: ${e.toString()}');
    }
  }

  /// Insert pokemons  to table
  insertPokemons(List<Pokemon> pokemons) async {
    final db = await database;

    for (Pokemon pokemon in pokemons) {
      try {
        await db.insert(_pokemonsTableData, pokemon.toJson());
      } catch (e) {
        print('Error in get pokemon Table: ${e.toString()}');
      }
    }
  }

  /// get pokemons from table
  Future<List<Pokemon>> getPokemons() async {
    final db = await database;
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery("SELECT * FROM $_pokemonsTableData");
    print(queryResult);
    return queryResult
        .map((e) => Pokemon(
              name: e['name'].toString(),
              url: e['url'].toString(),
              id: e['id'] as int,
              isFavourite: e['isFavourite'] == 0 ? false : true,
            ))
        .toList();
  }

  /// get favourite pokemons from table
  Future<List<Pokemon>> getFavouritePokemons() async {
    final db = await database;
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
        "SELECT * FROM $_pokemonsTableData WHERE $_colPokemonIsFavourite='1'");
    return queryResult
        .map((e) => Pokemon(
              name: e['name'].toString(),
              url: e['url'].toString(),
              id: e['id'] as int,
              isFavourite: e['isFavourite'] == 0 ? false : true,
            ))
        .toList();
  }

  /// update favourite pokemons
  Future<bool> updatePokemonFavourite(Pokemon pokemon) async {
    try {
      final db = await database;

      await db.update(
        _pokemonsTableData,
        pokemon.toJson(),
        where: '$_colPokemonName = ?',
        whereArgs: [pokemon.name],
      );

      print('Pokemon table created');
      return true;
    } catch (e) {
      print('Error in Create Pokemon Table: ${e.toString()}');
      return false;
    }
  }

  /// Table for store pokemon detaial data Table
  Future<void> createTableToStorePokemonDetailData(Database db) async {
    try {
      await db.execute(
          "CREATE TABLE $_pokemonDetailTableData($_colPokemonDetailName TEXT PRIMARY KEY, $_colPokemonDetailAbilities TEXT)");

      print('Pokemon table created');
    } catch (e) {
      print('Error in Create Pokemon Table: ${e.toString()}');
    }
  }

  /// insert pokemons detail to table
  insertPokemonDetail(PokemonAbilities pokemonAbilities) async {
    final db = await database;

    try {
      final Map<String, dynamic> detailData = <String, dynamic>{};

      String jsonTags = jsonEncode(pokemonAbilities.abilities);

      detailData[_colPokemonDetailName] = pokemonAbilities.name;
      detailData[_colPokemonDetailAbilities] = jsonTags;

      await db.insert(_pokemonDetailTableData, detailData);
    } catch (e) {
      print('Error in get pokemon Table: ${e.toString()}');
    }
  }

  /// get pokemon detail from table
  Future<PokemonAbilities> getPokemonDetailByName(String pokemonName) async {
    try {
      final Database db = await database;

      List<Map<String, Object?>> result = await db.rawQuery(
          "SELECT * FROM $_pokemonDetailTableData WHERE $_colPokemonDetailName='$pokemonName'");

      return PokemonAbilities(
          name: result[0]['name'] as String,
          abilities: (json.decode((result[0]['abilities'] as String))
                  as List<dynamic>?)
              ?.map((e) =>
                  PokemonAbilityDetail.fromJson(e as Map<String, dynamic>))
              .toList());
    } catch (e) {
      throw GetLocalDatabaseException();
    }
  }

  /// delete all records in the pokemon detail table
  Future<void> deleteAllFromTable() async {
    final Database db = await database;
    await db.rawDelete('DELETE FROM $_pokemonDetailTableData');
  }

  /// delete all records in the pokemon table
  Future<void> deletePokemonsAllFromTable() async {
    final Database db = await database;
    await db.rawDelete('DELETE FROM $_pokemonsTableData');
  }
}
