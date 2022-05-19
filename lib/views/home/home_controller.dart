import 'package:flutter/material.dart';
import 'package:flutter_app_pokemon/data/data.dart';

import '../../configs/config.dart';

class HomeController extends GetxController {
  final _sessionState = ViewState.idle.obs;

  ViewState get sessionState => _sessionState.value;

  List<Pokemon> pokemonList = [];
  var pokemonEntity = const PokemonsEntity();

  bool hasReachedMax, isAscendingOrder = true;

  final ScrollController scrollController = ScrollController();
  final RxBool isLoading = false.obs;

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
      if (value['results'] == null) {
        _sessionState.value = ViewState.error;
        CommonWidget.errorPrompt(Constant.errorMessage);
        return;
      }
      _sessionState.value = ViewState.retrived;
      pokemonEntity = PokemonsEntity.fromJson(value);

      if (pokemonEntity.next!.isEmpty) {
        hasReachedMax = true;
      }
      if (pokemonEntity.previous == null || pokemonEntity.previous!.isEmpty) {
        pokemonList = CommonWidget()
            .getPokemonInOrder(pokemonEntity.pokemons!, isAscendingOrder);
      } else {
        pokemonList.addAll(pokemonEntity.pokemons!);
        pokemonList =
            CommonWidget().getPokemonInOrder(pokemonList, isAscendingOrder);
        update();
      }
      update();
    }).catchError((onError) {
      CommonWidget.errorPrompt(onError.toString());
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
}
