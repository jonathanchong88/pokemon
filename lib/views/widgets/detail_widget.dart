import 'package:flutter/material.dart';
import 'package:flutter_app_pokemon/configs/utils/custom_extention.dart';

import '../view.dart';

Widget detailWidget(DetailController controller) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Name',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Text(controller.pokemonAbilities.name!.capitalize()),
      const SizedBox(
        height: 18,
      ),
      const Text(
        'Abilities',
        style: TextStyle(fontWeight: FontWeight.bold),
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
}
