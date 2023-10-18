import 'dart:io';
import 'dart:typed_data';
import 'package:camorim_getx_app/app/pages/Scanner%20PDF/first_page.dart';
import 'package:camorim_getx_app/app/pages/Scanner%20PDF/widgets_scanner.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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
          separador('Pegando imagem e exibindo'),
          ImagePickerWidget(),
          separador('Pegando arquivo e e fazendo um POST'),
          DioFilesRestApiWidget(),
          separador('Coluna Botoes'),
          separador('Exibindo a Imagem'),
          PegandoArquivosPage(),
          separador('Exibindo o Arquivo PDF'),
          separador('Exibindo Resultado OCR'),
          ElevatedButton(onPressed: () {}, child: Text('Salvar Excel')),
          separador('Pegando varios arquivos'),
          // PrimeiraPagina(),
        ],
      ),
    );
  }

  _buildDisplayDataRelatorio() {}

  _buildCardImage() {}

  _buildColunaBotoes() {}

  _buildCardPdf() {}

  Widget separador(text) {
    return Column(
      children: [
        Divider(),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(text),
          ),
        )
      ],
    );
  }
}
