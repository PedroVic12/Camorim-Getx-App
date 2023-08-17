import 'package:camorim_getx_app/pages/CamScannerPage.dart';
import 'package:camorim_getx_app/pages/RelatoriosPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          children: [
            Text('HomePage'),
            Container(
              height: 200,
              width: 200,
              color: Colors.red,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              onPressed: () {
                Get.to(RelatorioPage());
              },
              child: const Text('Ver pagina Relatorio'),
            ),
            SizedBox(
              height: 25,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              onPressed: () {
                Get.to(CamScannerPage());
              },
              child: const Text('Ver CamScanner'),
            ),
          ],
        ),
      ),
    );
  }
}
