import 'package:flutter/material.dart';

import '../../configs/config.dart';
import '../view.dart';

Widget homeWidget(HomeController controller) {
  return StaggeredGridView.countBuilder(
    controller: controller.scrollController,
    crossAxisCount: 4,
    itemCount: controller.pokemonList.length,
    itemBuilder: (BuildContext context, int index) => InkWell(
      onTap: () {
        // var pokemon = controller.pokemonList[index];
        Get.toNamed(AppRoutes.DETAIL,
            arguments: {'pokemon': controller.pokemonList[index]});
      },
      child: Container(
          margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black),
          ),
          child: Center(
            child: Text(controller.pokemonList[index].name!),
          )),
    ),
    staggeredTileBuilder: (int index) => const StaggeredTile.count(2, 2),
    mainAxisSpacing: 4.0,
    crossAxisSpacing: 4.0,
  );
}
