import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../configs/config.dart';
import '../view.dart';

Widget homeWidget(HomeController controller) {
  if (controller.sessionState == ViewState.loss_internet) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Internet Connection Loss',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          IconButton(
            onPressed: () {
              controller.onRefresh();
            },
            icon: const Icon(
              Icons.refresh,
              color: Colors.blue,
              size: 40,
            ),
          ),
        ],
      ),
    );
  } else {
    return RefreshIndicator(
      onRefresh: controller.onRefresh,
      child: StaggeredGridView.countBuilder(
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
            margin: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl: sprintf(Api.pokemonDbImagetUrl,
                        [controller.pokemonList[index].id]),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      controller.pokemonList[index].name!,
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      softWrap: false,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: controller.pokemonList[index].isFavourite!
                              ? Colors.red
                              : Colors.grey,
                        ),
                        onPressed: () {
                          controller.updatePokemonFavourite(index);
                        }),
                  ],
                )
              ],
            ),
          ),
        ),
        staggeredTileBuilder: (int index) => const StaggeredTile.count(2, 2),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      ),
    );
  }
}
