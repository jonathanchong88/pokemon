import 'package:flutter/material.dart';

import '../../configs/config.dart';
import '../widgets/widgets.dart';
import 'detail_controller.dart';

class DetailPage extends GetView<DetailController> {
  DetailPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DetailController>(
      initState: controller.iniState(),
      builder: (value) => Scaffold(
        appBar: CommonWidget.appBar(
          context,
          'Detail',
          Icons.arrow_back,
          Colors.black,
          callback: () {
            if (controller.isFavouriteChange) {
              Get.back(result: true);
            } else {
              Get.back();
            }
          },
          actonWidget: IconButton(
              icon: Icon(
                Icons.favorite,
                color: value.pokemon.isFavourite! ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                value.updatePokemonFavourite();
              }),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: detailWidget(value),
        ),
      ),
    );
  }
}
