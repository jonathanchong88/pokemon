import 'package:flutter_app_pokemon/data/data.dart';
import 'package:get/get.dart';

import 'detail_controller.dart';

///The Binding class is a class that will decouple dependency injection, while "binding" routes to the state manager and dependency manager.
class DetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IPokemonRepository>(() => PokemonRepository());
    Get.lazyPut(() => DetailController(iPokemonRepository: Get.find()));
  }
}
