import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_pokemon/configs/config.dart';

import '../view.dart';

Widget detailWidget(DetailController controller) {
  if (controller.sessionState == ViewState.retrived) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl: sprintf(Api.pokemonDbImagetUrl, [controller.pokemon.id]),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        const Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Name',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            textAlign: TextAlign.start,
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Text(controller.pokemonAbilities.name!.capitalizeFirst!),
        ),
        const SizedBox(
          height: 18,
        ),
        const Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Abilities',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            textAlign: TextAlign.start,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: controller.pokemonAbilities.abilities!.length,
          itemBuilder: (context, index) {
            return Text(
                controller.pokemonAbilities.abilities![index].ability?.name ??
                    '');
          },
        )
      ],
    );
  } else {
    return Container();
  }
}
