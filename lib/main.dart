import 'package:flutter/material.dart';

import 'configs/config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pokemon',
      debugShowCheckedModeBanner: false,
      logWriterCallback: (String text, {bool isError = false}) {
        debugPrint("GetXLog: $text");
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: AppRoutes.HOME,
      getPages: Routes.getRoutes(),
      navigatorObservers: <NavigatorObserver>[
        GetObserver(),
      ],
    );
  }
}
