import 'package:camorim_getx_app/pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'pages/CRUD Google Sheets/user_sheets_api.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await UserSheetsApi.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
          useMaterial3: true,
        ),
        home: HomePage());
  }
}
