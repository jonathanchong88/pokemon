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

  void _onScroll() {
    if (_isBottom && pokemonEntity.next!.isNotEmpty) {
      pokemonRequest(pokemonEntity.next!);
    } else {
      hasReachedMax = true;
    }
  }

  bool get _isBottom {
    if (scrollController.position.atEdge &&
        scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
      return true;
    } else {
      return false;
    }
  }

  Future pokemonRequest(String url) async {
    await iPokemonRepository.getPokemons(url: url).then((value) {
      pokemonEntity = value;
      if (pokemonEntity.count == 0) {
        // _sessionState.value = ViewState.error;
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

  Future favouritePokemonRequest() async {
    await iPokemonRepository.getFavouritePokemons().then((value) {
      pokemonEntity = value;
      if (pokemonEntity.count == 0) {
        // _sessionState.value = ViewState.error;
        CommonWidget.errorPrompt(Constant.errorMessage);
        return;
      }
      // _sessionState.value = ViewState.retrived;

      pokemonList = CommonWidget()
          .getPokemonInOrder(pokemonEntity.pokemons!, isAscendingOrder);
      update();
    }).catchError((onError) {
      CommonWidget.errorPrompt(onError.toString());
    });
  }

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

  changeItemInOrder(bool isAscending) {
    isAscendingOrder = isAscending;
    if (isAscending) {
      pokemonList = CommonWidget().getPokemonInOrder(pokemonList, true);
    } else {
      pokemonList = CommonWidget().getPokemonInOrder(pokemonList, false);
    }
    update();
  }

  Future<void> onRefresh() async {
    pokemonList.clear();
    if (viewState == ViewType.all) {
      pokemonRequest(Api.pokemonDbDefaultUrl);
    } else {
      favouritePokemonRequest();
    }
  }
}
