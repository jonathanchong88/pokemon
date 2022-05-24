import 'package:flutter_app_pokemon/data/data.dart';

import '../../configs/config.dart';

class DetailController extends GetxController {
  final _sessionState = ViewState.idle.obs;

  ViewState get sessionState => _sessionState.value;

  var pokemonAbilities = PokemonAbilities();
  Pokemon pokemon = Get.arguments['pokemon'] as Pokemon;

  DetailController({required this.iPokemonRepository});

  final IPokemonRepository iPokemonRepository;

  bool isFavouriteChange = false;

  //init function
  iniState() {
    getPokemonDetailRequest();
  }

  //get pokemon detail from repository
  Future getPokemonDetailRequest() async {
    _sessionState.value = ViewState.busy;
    await iPokemonRepository
        .getPokemonDetail(url: pokemon.url!, name: pokemon.name)
        .then((value) {
      pokemonAbilities = value;
      if (pokemonAbilities.name!.isEmpty) {
        _sessionState.value = ViewState.error;
        CommonWidget.errorPrompt(Constant.errorMessage);
        return;
      }
      _sessionState.value = ViewState.retrived;
      update();
    }).catchError((onError) {
      CommonWidget.errorPrompt(onError.toString());
    });
  }

  //update pokemon favourite
  Future updatePokemonFavourite() async {
    pokemon.isFavourite = !pokemon.isFavourite!;
    isFavouriteChange = !isFavouriteChange;
    await iPokemonRepository
        .updatePokemonFavourite(pokemon: pokemon)
        .then((value) {
      if (!value) {
        CommonWidget.errorPrompt(Constant.errorMessage);
        return;
      }
      update();
    });
  }
}
