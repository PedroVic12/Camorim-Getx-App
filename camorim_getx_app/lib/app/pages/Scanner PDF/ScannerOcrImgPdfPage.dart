import 'package:camorim_getx_app/app/controllers/imagem%20e%20pdf/dio_image_controller.dart';
import 'package:camorim_getx_app/app/pages/Scanner%20PDF/models/Dragonite.dart';
import 'package:camorim_getx_app/app/pages/Scanner%20PDF/views/second_page.dart';
import 'package:camorim_getx_app/app/pages/Scanner%20PDF/views/widget_extrairTexto.dart';
import 'package:camorim_getx_app/app/pages/Scanner%20PDF/widgets_scanner.dart';
import 'package:camorim_getx_app/widgets/CustomTabVIew.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';

import '../../controllers/imagem e pdf/pegando_arquivo_page.dart';

class ScannerOcrPage extends StatefulWidget {
  @override
  State<ScannerOcrPage> createState() => _ScannerOcrPageState();
}

class _ScannerOcrPageState extends State<ScannerOcrPage> {
  final dragonite = Get.put(DragonitePDF());
  final ImagePickerController controller = Get.put(ImagePickerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("OCR Page")),
      body: ListView(
        children: [
          separador('Pegando imagem da Camera  e exibindo'),
          ImagePickerWidget(),
          separador('Exibindo a Imagem'),
          PegandoArquivosPage(),
          Container(
            color: Colors.blueGrey,
            child: Column(children: [
              ElevatedButton(
                onPressed: () async {},
                child: Text('GERAR OS PDF'),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await dragonite.captureImage('arquivo');
                    Get.snackbar('FOi', 'message');
                  } catch (e) {
                    Get.snackbar('Erro', e.toString());
                  }
                },
                child: Text('Salvar PDF'),
              ),
              ElevatedButton(
                  onPressed: () {
                    Get.to(MyTabbedPage());
                  },
                  child: Text('TAB'))
            ]),
          )
        ],
      ),
    );
  }

  Widget buildListOptions() {
    return Column(children: [
      ElevatedButton(
          onPressed: () {
            Get.to(Secondpage);
          },
          child: Text('Ir para Segunda Pagina')),
      separador('Pegando arquivo e e fazendo um POST'),
      DioFilesRestApiController(),
      separador('Coluna Botoes'),
      separador('Exibindo o Arquivo PDF'),
      separador('Exibindo Resultado OCR'),
      ElevatedButton(onPressed: () {}, child: Text('Salvar Excel')),
      separador('Pegando varios arquivos'),
    ]);
  }

  Widget separador(text) {
    return Column(
      children: [
        Divider(),
        Card(
          color: Colors.red.shade300,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
