import 'package:flutter_app_pokemon/data/data.dart';

import '../../configs/config.dart';

class DetailController extends GetxController {
  final _sessionState = ViewState.idle.obs;

  ViewState get sessionState => _sessionState.value;

  var pokemonAbilities = PokemonAbilities();
  var argument = Get.arguments['pokemon'];

  DetailController({required this.iPokemonRepository});

  final IPokemonRepository iPokemonRepository;

  iniState() {
    getPokemonDetailRequest(argument.detailUrl);
  }

  Future getPokemonDetailRequest(String url) async {
    await iPokemonRepository.getPokemonDetail(url: url).then((value) {
      if (value['abilities'] == null) {
        _sessionState.value = ViewState.error;
        CommonWidget.errorPrompt(Constant.errorMessage);
        return;
      }
      _sessionState.value = ViewState.retrived;

      pokemonAbilities = PokemonAbilities.fromJson(value);
      update();
    }).catchError((onError) {
      CommonWidget.errorPrompt(onError.toString());
    });
  }
}
