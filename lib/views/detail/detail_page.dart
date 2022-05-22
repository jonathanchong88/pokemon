import 'package:flutter/material.dart';

import '../../configs/config.dart';
import '../widgets/widgets.dart';
import 'detail_controller.dart';

class DetailPage extends GetView<DetailController> {
  DetailPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: CommonWidget.appBar(context, 'Detail', null, Colors.black),
          backgroundColor: Colors.white,
          body: GetBuilder<DetailController>(
            initState: controller.iniState(),
            builder: (value) => Padding(
              padding: const EdgeInsets.all(10.0),
              child: detailWidget(value),
            ),
          ),
        ),
      ],
    );
  }
}
