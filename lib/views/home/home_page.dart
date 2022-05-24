import 'package:flutter/material.dart';

import '../../configs/config.dart';
import '../widgets/widgets.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidget.appBar(context, 'Pokemons', null, Colors.black,
          actonWidget: PopupMenuButton(
            icon: const Icon(
              Icons.filter_list,
              color: Colors.blue,
            ),
            onSelected: (value) {
              if (value == 1) {
                controller.viewState = ViewType.all;
                controller.pokemonRequest(Api.pokemonDbDefaultUrl);
              } else if (value == 2) {
                controller.viewState = ViewType.favourite;
                controller.favouritePokemonRequest();
              } else if (value == 3) {
                controller.changeItemInOrder(true);
              } else {
                controller.changeItemInOrder(false);
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 1,
                child: Text("All"),
              ),
              const PopupMenuItem(
                value: 2,
                child: Text("Favourite"),
              ),
              const PopupMenuItem(
                value: 3,
                child: Text("Ascending"),
              ),
              const PopupMenuItem(
                value: 4,
                child: Text("Descending"),
              )
            ],
          )),
      backgroundColor: Colors.white,
      body: GetBuilder<HomeController>(
        initState: controller.initState(),
        builder: (value) => homeWidget(value),
      ),
    );
  }
}
