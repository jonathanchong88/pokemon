import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_app_pokemon/data/providers/local/local_database.dart';
import 'package:sprintf/sprintf.dart';

import '../../configs/config.dart';
import '../models/model.dart';
import '../providers/network/base_provider.dart';

abstract class IPokemonRepository {
  Future<dynamic> getPokemons({required String url});
  Future<dynamic> getPokemonDetail({required String url});
}

class PokemonRepository extends BaseProvider implements IPokemonRepository {
  LocalDatabase localDatabase = LocalDatabase();
  final Connectivity _connectivity = Connectivity();
  var connectivityResult = ConnectivityResult.none;

  @override
  Future<PokemonsEntity> getPokemons({
    required String url,
  }) async {
    try {
      connectivityResult = await _connectivity.checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        List<Pokemon> pokemons = await localDatabase.retrievePokemons();

        return PokemonsEntity(
            pokemons: pokemons,
            next: pokemons.isNotEmpty
                ? sprintf(Api.pokemonDbLimitOffsetUrl, [pokemons.length])
                : '',
            previous: '',
            count: pokemons.length);
      } else {
        await request(
          method: Requests.get,
          path: url,
        );

        var value = decodeResponse(response);

        if (value['results'] == null) {
          return const PokemonsEntity(count: 0);
        }

        var pokemonEntity = PokemonsEntity.fromJson(value);

        //insert data to database
        localDatabase.insertPersons(pokemonEntity.pokemons!);

        return pokemonEntity;
      }
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ServiceNotRespondingException(
          'Service not responding in time please check your Internet Connection');
    }
  }

  @override
  Future getPokemonDetail({
    required String url,
  }) async {
    try {
      await request(
        method: Requests.get,
        path: url,
      );

      return decodeResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ServiceNotRespondingException(
          'Service not responding in time please check your Internet Connection');
    }
  }
}
