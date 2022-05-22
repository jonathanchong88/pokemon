import 'package:flutter_app_pokemon/data/data.dart';
import 'package:get/get.dart';

import 'detail_controller.dart';

class DetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IPokemonRepository>(() => PokemonRepository());
    Get.lazyPut(() => DetailController(iPokemonRepository: Get.find()));
  }
}
