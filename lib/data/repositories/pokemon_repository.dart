import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_app_pokemon/data/providers/local/local_database.dart';

import '../../configs/config.dart';
import '../models/model.dart';
import '../providers/network/base_provider.dart';

abstract class IPokemonRepository {
  Future<dynamic> getPokemons({required String url});
  Future<dynamic> getFavouritePokemons();
  Future<dynamic> getPokemonDetail({required String url, String? name});
  Future<dynamic> updatePokemonFavourite({required Pokemon pokemon});
}

class PokemonRepository extends BaseProvider implements IPokemonRepository {
  LocalDatabase localDatabase = LocalDatabase();
  final Connectivity _connectivity = Connectivity();
  var connectivityResult = ConnectivityResult.none;
  var value;

  @override
  Future<PokemonsEntity> getPokemons({required String url}) async {
    try {
      connectivityResult = await _connectivity.checkConnectivity();

      if (connectivityResult != ConnectivityResult.none) {
        await request(
          method: Requests.get,
          path: url,
        );

        value = decodeResponse(response);

        if (value['results'] == null) {
          return const PokemonsEntity(count: 0);
        }

        var pokemonEntity = PokemonsEntity.fromJson(value);

        //insert data to database
        await localDatabase.insertPokemons(pokemonEntity.pokemons!);
      }
      List<Pokemon> pokemons = await localDatabase.getPokemons();

      if (pokemons.isEmpty) {
        throw FetchDataException('No Internet Connection');
      }

      return PokemonsEntity(
          pokemons: pokemons,
          next: pokemons.isNotEmpty
              ? sprintf(Api.pokemonDbLimitOffsetUrl, [pokemons.length])
              : '',
          previous: '',
          count: pokemons.length);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ServiceNotRespondingException(
          'Service not responding in time please check your Internet Connection');
    } on Exception {
      throw FetchDataException('No Internet Connection');
    }
  }

  @override
  Future getPokemonDetail({required String url, String? name}) async {
    try {
      connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return await localDatabase.getPokemonDetailByName(name!);
      } else {
        await request(
          method: Requests.get,
          path: url,
        );

        value = decodeResponse(response);

        if (value['abilities'] == null) {
          return PokemonAbilities(name: '');
        }

        var pokemonAbilities = PokemonAbilities.fromJson(value);

        //insert data to database
        localDatabase.insertPokemonDetail(pokemonAbilities);

        return pokemonAbilities;
      }
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ServiceNotRespondingException(
          'Service not responding in time please check your Internet Connection');
    }
  }

  @override
  Future updatePokemonFavourite({required Pokemon pokemon}) async {
    return await localDatabase.updatePokemonFavourite(pokemon);
  }

  @override
  Future getFavouritePokemons() async {
    List<Pokemon> pokemons = await localDatabase.getFavouritePokemons();

    return PokemonsEntity(
        pokemons: pokemons,
        next: pokemons.isNotEmpty
            ? sprintf(Api.pokemonDbLimitOffsetUrl, [pokemons.length])
            : '',
        previous: '',
        count: pokemons.length);
  }
}
