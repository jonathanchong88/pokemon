import 'package:flutter/material.dart';
import 'package:flutter_app_pokemon/data/data.dart';

import '../../configs/config.dart';

class HomeController extends GetxController {
  final _sessionState = ViewState.idle.obs;

  ViewState get sessionState => _sessionState.value;

  ViewType viewState = ViewType.all;

  List<Pokemon> pokemonList = [];
  var pokemonEntity = const PokemonsEntity();

  bool hasReachedMax, isAscendingOrder = true;

  final ScrollController scrollController = ScrollController();

  HomeController(
      {required this.iPokemonRepository, this.hasReachedMax = false});

  final IPokemonRepository iPokemonRepository;

  // init function
  initState() {
    pokemonList.clear();
    pokemonRequest(Api.pokemonDbDefaultUrl);
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.removeListener(_onScroll);
  }

  // scroll function is triggered when user is scrolling
  void _onScroll() {
    if (_isBottom &&
        pokemonEntity.next!.isNotEmpty &&
        viewState == ViewType.all) {
      pokemonRequest(pokemonEntity.next!);
    } else {
      hasReachedMax = true;
    }
  }

  // checking the screen is scroll to bottom
  bool get _isBottom {
    if (scrollController.position.atEdge &&
        scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
      return true;
    } else {
      return false;
    }
  }

  // get pokemon list from repository
  Future pokemonRequest(String url) async {
    await iPokemonRepository.getPokemons(url: url).then((value) {
      pokemonEntity = value;
      if (pokemonEntity.count == 0) {
        CommonWidget.errorPrompt(Constant.errorMessage);
        return;
      }
      pokemonList = CommonWidget()
          .getPokemonInOrder(pokemonEntity.pokemons!, isAscendingOrder);
      _sessionState.value = ViewState.retrived;
      update();
    }).catchError((onError) {
      _sessionState.value = ViewState.loss_internet;
      update();
      CommonWidget.errorPrompt(onError.toString());
    });
  }

  // get favourite pokemon list from repository
  Future favouritePokemonRequest() async {
    await iPokemonRepository.getFavouritePokemons().then((value) {
      pokemonEntity = value;
      if (pokemonEntity.count == 0) {
        CommonWidget.errorPrompt(Constant.errorMessage);
        return;
      }

      pokemonList = CommonWidget()
          .getPokemonInOrder(pokemonEntity.pokemons!, isAscendingOrder);
      update();
    }).catchError((onError) {
      CommonWidget.errorPrompt(onError.toString());
    });
  }

  // update favourite for selected pokemon
  Future updatePokemonFavourite(int index) async {
    pokemonList[index].isFavourite = !pokemonList[index].isFavourite!;
    await iPokemonRepository
        .updatePokemonFavourite(pokemon: pokemonList[index])
        .then((value) {
      if (!value) {
        CommonWidget.errorPrompt(Constant.errorMessage);
        return;
      }
      update();
    });
  }

  // change list items order in ascending or descending
  changeItemInOrder(bool isAscending) {
    isAscendingOrder = isAscending;
    if (isAscending) {
      pokemonList = CommonWidget().getPokemonInOrder(pokemonList, true);
    } else {
      pokemonList = CommonWidget().getPokemonInOrder(pokemonList, false);
    }
    update();
  }

  // refresh the pokemon list
  Future<void> onRefresh() async {
    pokemonList.clear();
    if (viewState == ViewType.all) {
      pokemonRequest(Api.pokemonDbDefaultUrl);
    } else {
      favouritePokemonRequest();
    }
  }
}
