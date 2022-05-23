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

    // final Directory newDirectory =
    //     await Directory(desirePath + '/.Databases/').create();
    final String path = '$desirePath/pokemon_local_storage.db';

    // create the database
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await createTableToStorePokemonData(db);
      await createTableToStorePokemonDetailData(db);
    });
  }

  Future<void> deletePersonTable() async {
    final db = await database;
    try {
      db.delete(_pokemonsTableData);
      print('Pokemon Important table deleted');
    } catch (e) {
      print('Error in delete Import Table: ${e.toString()}');
    }
  }

  /// Table for store pokemon data Table
  Future<void> createTableToStorePokemonData(Database db) async {
    try {
      // final Database db = await database;
      await db.execute(
          "CREATE TABLE $_pokemonsTableData($_colPokemonName TEXT PRIMARY KEY, $_colPokemonUrl TEXT, $_colPokemonIsFavourite NUMERIC)");

      print('Pokemon table created');
    } catch (e) {
      print('Error in Create Pokemon Table: ${e.toString()}');
    }
  }

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

  Future<List<Pokemon>> getPokemons() async {
    final db = await database;
    final List<Map<String, Object?>> queryResult =
        await db.query(_pokemonsTableData);
    return queryResult
        .map((e) => Pokemon(
              name: e['name'].toString(),
              url: e['url'].toString(),
              isFavourite: e['isFavourite'] == 0 ? false : true,
            ))
        .toList();
  }

  Future<List<Pokemon>> getFavouritePokemons() async {
    final db = await database;
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
        "SELECT * FROM $_pokemonsTableData WHERE $_colPokemonIsFavourite='1'");
    return queryResult
        .map((e) => Pokemon(
              name: e['name'].toString(),
              url: e['url'].toString(),
              isFavourite: e['isFavourite'] == 0 ? false : true,
            ))
        .toList();
  }

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

  insertPersonDetail(PokemonAbilities pokemonAbilities) async {
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

  // delete all records in the table
  Future<void> deleteAllFromTable() async {
    final Database db = await database;
    await db.rawDelete('DELETE FROM $_pokemonDetailTableData');
  }

  // delete all records in the table
  Future<void> deletePokemonsAllFromTable() async {
    final Database db = await database;
    await db.rawDelete('DELETE FROM $_pokemonsTableData');
  }

  /// Insert or Update From Important Data Table
  // Future<bool> insertOrUpdateDataForThisAccount({
  //   required String userName,
  //   required String userMail,
  //   required String userToken,
  //   required String userAbout,
  //   required String userAccCreationDate,
  //   required String userAccCreationTime,
  //   String chatWallpaper = '',
  //   String profileImagePath = '',
  //   String profileImageUrl = '',
  //   String purpose = 'insert',
  // }) async {
  //   try {
  //     final Database db = await this.database;
  //
  //     if (purpose != 'insert') {
  //       final int updateResult = await db.rawUpdate(
  //           "UPDATE $_importantTableData SET $_colToken = '$userToken', $_colAbout = '$userAbout', $_colUserMail = '$userMail', $_colAccCreationDate = '$userAccCreationDate', $_colAccCreationTime = '$userAccCreationTime' WHERE $_colUserName = '$userName'");
  //
  //       print('Update Result is: $updateResult');
  //     } else {
  //       final Map<String, dynamic> _accountData = Map<String, dynamic>();
  //
  //       _accountData[_colUserName] = userName;
  //       _accountData[_colUserMail] = userMail;
  //       _accountData[_colToken] = userToken;
  //       _accountData[_colProfileImagePath] = profileImagePath;
  //       _accountData[_colProfileImageUrl] = profileImageUrl;
  //       _accountData[_colAbout] = userAbout;
  //       _accountData[_colWallpaper] = chatWallpaper;
  //       _accountData[_colMobileNumber] = '';
  //       _accountData[_colNotification] = "1";
  //       _accountData[_colAccCreationDate] = userAccCreationDate;
  //       _accountData[_colAccCreationTime] = userAccCreationTime;
  //
  //       await db.insert(this._importantTableData, _accountData);
  //     }
  //     return true;
  //   } catch (e) {
  //     print('Error in Insert or Update Important Data Table');
  //     return false;
  //   }
  // }

  // Future<String?> getUserNameForCurrentUser(String userEmail) async {
  //   try {
  //     final Database db = await this.database;
  //
  //     List<Map<String, Object?>> result = await db.rawQuery(
  //         "SELECT $_colUserName FROM ${this._importantTableData} WHERE $_colUserMail='$userEmail'");
  //
  //     return result[0].values.first.toString();
  //   } catch (e) {
  //     return null;
  //   }
  // }
  //
  // Future<String?> getParticularFieldDataFromImportantTable(
  //     {required String userName,
  //       required GetFieldForImportantDataLocalDatabase getField}) async {
  //   try {
  //     final Database db = await this.database;
  //
  //     final String? _particularSearchField =
  //     _getFieldNameHelpWithEnumerators(getField);
  //
  //     List<Map<String, Object?>> getResult = await db.rawQuery(
  //         "SELECT $_particularSearchField FROM ${this._importantTableData} WHERE $_colUserName = '$userName'");
  //
  //     return getResult[0].values.first.toString();
  //   } catch (e) {
  //     print(
  //         'Error in getParticularFieldDataFromImportantTable: ${e.toString()}');
  //   }
  // }

  // String? _getFieldNameHelpWithEnumerators(
  //     GetFieldForImportantDataLocalDatabase getField) {
  //   switch (getField) {
  //     case GetFieldForImportantDataLocalDatabase.UserEmail:
  //       return this._colUserMail;
  //     case GetFieldForImportantDataLocalDatabase.Token:
  //       return this._colToken;
  //     case GetFieldForImportantDataLocalDatabase.ProfileImagePath:
  //       return this._colProfileImagePath;
  //     case GetFieldForImportantDataLocalDatabase.ProfileImageUrl:
  //       return this._colProfileImageUrl;
  //     case GetFieldForImportantDataLocalDatabase.About:
  //       return this._colAbout;
  //     case GetFieldForImportantDataLocalDatabase.WallPaper:
  //       return this._colWallpaper;
  //     case GetFieldForImportantDataLocalDatabase.MobileNumber:
  //       return this._colMobileNumber;
  //     case GetFieldForImportantDataLocalDatabase.Notification:
  //       return this._colNotification;
  //     case GetFieldForImportantDataLocalDatabase.AccountCreationDate:
  //       return this._colAccCreationDate;
  //     case GetFieldForImportantDataLocalDatabase.AccountCreationTime:
  //       return this._colAccCreationTime;
  //   }
  // }

  // /// For Make Table for Status
  // Future<bool> createTableForUserActivity({required String tableName}) async {
  //   final Database db = await this.database;
  //   try {
  //     await db.execute(
  //         "CREATE TABLE ${tableName}_status($_colActivity, $_colActivityTime TEXT PRIMARY KEY, $_colActivityMediaType TEXT, $_colActivityExtraText TEXT, $_colActivityBGInformation TEXT)");
  //
  //     print('User Activity table creatred');
  //
  //     return true;
  //   } catch (e) {
  //     print("Error in Create Table For Status: ${e.toString()}");
  //     return false;
  //   }
  // }

  /// Insert ActivityData to Activity Table
  // Future<bool> insertDataInUserActivityTable(
  //     {required String tableName,
  //       required String statusLinkOrString,
  //       required StatusMediaTypes mediaTypes,
  //       required String activityTime,
  //       String extraText = '',
  //       String bgInformation = ''}) async {
  //   try {
  //     final Database db = await this.database;
  //     final Map<String, dynamic> _activityStoreMap = Map<String, dynamic>();
  //
  //     _activityStoreMap[_colActivity] = statusLinkOrString;
  //     _activityStoreMap[_colActivityTime] = activityTime;
  //     _activityStoreMap[_colActivityMediaType] = mediaTypes.toString();
  //     _activityStoreMap[_colActivityExtraText] = extraText;
  //     _activityStoreMap[_colActivityBGInformation] = bgInformation;
  //
  //     /// Result Insert to DB
  //     final int result =
  //     await db.insert('${tableName}_status', _activityStoreMap);
  //
  //     return result > 0 ? true : false;
  //   } catch (e) {
  //     print('Error: Activity Table Data insertion Error: ${e.toString()}');
  //     return false;
  //   }
  // }

  // Future<void> createTableForEveryUser({required String userName}) async {
  //   try {
  //     final Database db = await this.database;
  //
  //     await db.execute(
  //         "CREATE TABLE $userName($_colActualMessage TEXT, $_colMessageType TEXT, $_colMessageHolder TEXT, $_colMessageDate TEXT, $_colMessageTime TEXT)");
  //   } catch (e) {
  //     print("Error in Create Table For Every User: ${e.toString()}");
  //   }
  // }

  // Future<void> insertMessageInUserTable(
  //     {required String userName,
  //       required String actualMessage,
  //       required ChatMessageTypes chatMessageTypes,
  //       required MessageHolderType messageHolderType,
  //       required String messageDateLocal,
  //       required String messageTimeLocal}) async {
  //   try {
  //     final Database db = await this.database;
  //
  //     Map<String, String> tempMap = Map<String, String>();
  //
  //     tempMap[this._colActualMessage] = actualMessage;
  //     tempMap[this._colMessageType] = chatMessageTypes.toString();
  //     tempMap[this._colMessageHolder] = messageHolderType.toString();
  //     tempMap[this._colMessageDate] = messageDateLocal;
  //     tempMap[this._colMessageTime] = messageTimeLocal;
  //
  //     final int rowAffected = await db.insert(userName, tempMap);
  //     print('Row Affected: $rowAffected');
  //   } catch (e) {
  //     print('Error in Insert Message In User Table: ${e.toString()}');
  //   }
  // }

  // Future<List<PreviousMessageStructure>> getAllPreviousMessages(
  //     String userName) async {
  //   try {
  //     final Database db = await this.database;
  //
  //     final List<Map<String, Object?>> result =
  //     await db.rawQuery("SELECT * from $userName");
  //
  //     List<PreviousMessageStructure> takePreviousMessages = [];
  //
  //     for (int i = 0; i < result.length; i++) {
  //       Map<String, dynamic> tempMap = result[i];
  //       takePreviousMessages.add(PreviousMessageStructure.toJson(tempMap));
  //     }
  //
  //     return takePreviousMessages;
  //   } catch (e) {
  //     print("Error is: $e");
  //     return [];
  //   }
  // }
}
