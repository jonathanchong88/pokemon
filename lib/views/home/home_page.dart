import 'package:flutter/material.dart';

import '../../configs/config.dart';
import '../widgets/widgets.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            appBar: CommonWidget.appBar(context, 'Pokemons', null, Colors.black,
                actonWidget: PopupMenuButton(
                  icon: const Icon(
                    Icons.filter_list,
                    color: Colors.blue,
                  ),
                  onSelected: (value) {
                    if (value == 1) {
                      controller.changeItemInOrder(true);
                    } else {
                      controller.changeItemInOrder(false);
                    }
                  },
                  itemBuilder: (ctx) => [
                    const PopupMenuItem(
                      value: 1,
                      child: Text("Ascending"),
                    ),
                    const PopupMenuItem(
                      value: 2,
                      child: Text("Descending"),
                    )
                  ],
                )),
            backgroundColor: Colors.white,
            body: GetBuilder<HomeController>(
              initState: controller.initState(),
              builder: (value) => Padding(
                padding: const EdgeInsets.all(10.0),
                child: homeWidget(value),
              ),
            )),
      ],
    );
  }
}
