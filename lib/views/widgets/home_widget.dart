import 'package:flutter/material.dart';

import '../../configs/config.dart';
import '../view.dart';

Widget homeWidget(HomeController controller) {
  return StaggeredGridView.countBuilder(
    controller: controller.scrollController,
    crossAxisCount: 4,
    itemCount: controller.pokemonList.length,
    itemBuilder: (BuildContext context, int index) => InkWell(
      onTap: () async {
        final result = await Get.toNamed(AppRoutes.DETAIL,
            arguments: {'pokemon': controller.pokemonList[index]});

        if (result != null) {
          controller.pokemonRequest(Api.pokemonDbDefaultUrl);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black),
        ),
        child: ListTile(
          title: Center(
            child: Text(controller.pokemonList[index].name!),
          ),
          trailing: IconButton(
              icon: Icon(
                Icons.favorite,
                color: controller.pokemonList[index].isFavourite!
                    ? Colors.red
                    : Colors.grey,
              ),
              onPressed: () {
                controller.updatePokemonFavourite(index);
              }),
        ),
      ),
    ),
    staggeredTileBuilder: (int index) => const StaggeredTile.count(2, 2),
    mainAxisSpacing: 4.0,
    crossAxisSpacing: 4.0,
  );
}
