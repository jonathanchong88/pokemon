import 'package:flutter_app_pokemon/data/data.dart';
import 'package:flutter_app_pokemon/views/home/home.dart';
import 'package:get/get.dart';

///The Binding class is a class that will decouple dependency injection, while "binding" routes to the state manager and dependency manager.
class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IPokemonRepository>(() => PokemonRepository());
    Get.lazyPut(() => HomeController(iPokemonRepository: Get.find()));
  }
}
