import 'package:camorim_getx_app/app/controllers/imagem%20e%20pdf/dio_image_controller.dart';
import 'package:camorim_getx_app/app/pages/Scanner%20PDF/widgets_scanner.dart';
import 'package:flutter/material.dart';

import '../../controllers/imagem e pdf/pegando_arquivo_page.dart';

class ScannerOcrPage extends StatefulWidget {
  @override
  State<ScannerOcrPage> createState() => _ScannerOcrPageState();
}

class _ScannerOcrPageState extends State<ScannerOcrPage> {
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



        ],
      ),
    );
  }

  Widget buildListOptions(){
    return Column(
      children: [
        
          ElevatedButton(onPressed: () {Get.to(Secondpage);}, child: Text('Ir para Segunda Pagina')),



          separador('Pegando arquivo e e fazendo um POST'),
          DioFilesRestApiController(),
          separador('Coluna Botoes'),

          separador('Exibindo o Arquivo PDF'),
          separador('Exibindo Resultado OCR'),
          ElevatedButton(onPressed: () {}, child: Text('Salvar Excel')),
          separador('Pegando varios arquivos'),
      ]
    )
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
