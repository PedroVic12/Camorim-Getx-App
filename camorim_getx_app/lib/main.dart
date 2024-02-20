import 'package:camorim_getx_app/app/pages/HomePage.dart';
import 'package:camorim_getx_app/app/pages/Scanner%20PDF/NotaFiscalOcr/nota_fiscal_ocr_page.dart';
import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/views/cadastro_desktop.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'app/pages/Scanner PDF/views/widget_extrairTexto.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
          scrollbarTheme: ScrollbarThemeData(
            thumbColor: MaterialStateProperty.all(Colors.lightBlue),
          ),
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('pt', 'BR'), // Português do Brasil
        ],
        getPages: [
          GetPage(name: '/OcrPage', page: () => NotaFiscalOcrPage()),
          GetPage(name: '/relatorioOS', page: () => SistemaCadastroDesktop()),
        ],
        home: HomePage());
  }
}
