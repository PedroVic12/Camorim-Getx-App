import 'package:camorim_getx_app/app/pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'app/pages/Scanner PDF/views/widget_extrairTexto.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //! This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'CAMORIM MANUTENÇÃO APP',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
          useMaterial3: true,
        ),
        getPages: [
          GetPage(name: '/OcrPage', page: () => WidgetSelecionadorImagem()),
        ],
        home: HomePage());
  }
}
