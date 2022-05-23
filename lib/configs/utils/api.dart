import 'package:flutter_app_pokemon/configs/config.dart';

class Api {
  //Base URLs
  static const String pokemonDbBaseUrl = "https://pokeapi.co/api/v2/";
  static const String pokemonDbDefaultUrl =
      '${pokemonDbBaseUrl}pokemon/?limit=${Constant.listLimit}';
  static const String pokemonDbLimitOffsetUrl =
      '${pokemonDbBaseUrl}pokemon/?offset=%i&limit=${Constant.listLimit}';
  static String pokemonDbImagetUrl =
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/%i.png';
}
