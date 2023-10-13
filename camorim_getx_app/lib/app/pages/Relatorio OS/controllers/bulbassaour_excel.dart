import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:universal_html/html.dart' show AnchorElement;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:camorim_getx_app/app/pages/CRUD%20Excel/model/contact_model.dart';
import 'package:get/get.dart';

import '../models/RelatorioModel.dart';

class ExcelController extends GetxController {
  var contatos = <Contact>[].obs;

  var relatorios_array = <Relatorio>[].obs;

  final ExcelTitle excelTitle =
      ExcelTitle(nameTitle: "Nome", emailTitle: "Email"); // Títulos da planilha

  Future<void> salvarExcel(Workbook workbook, String filename) async {
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    if (kIsWeb) {
      baixarArquivoWeb(bytes, filename);
    } else {
      await salvarArquivoLocal(bytes, filename);
    }
  }

  void baixarArquivoWeb(List<int> bytes, String filename) {
    AnchorElement(
        href:
            'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
      ..setAttribute('download', filename)
      ..click();
  }

  Future<void> salvarArquivoLocal(List<int> bytes, String filename) async {
    final String path = (await getApplicationSupportDirectory()).path;
    final String filePath =
        Platform.isWindows ? '$path\\$filename' : '$path/$filename';
    final File file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(filePath);
  }

  Future<void> adicionarContato(Contact contato, String nomeArquivo) async {
    try {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      sheet.getRangeByIndex(1, 1).setText(excelTitle.nameTitle);
      sheet.getRangeByIndex(1, 2).setText(excelTitle.emailTitle);

      final int proximaLinha = contatos.length + 2;
      sheet.getRangeByIndex(proximaLinha, 1).setText(contato.name);
      sheet.getRangeByIndex(proximaLinha, 2).setText(contato.email);

      await salvarExcel(workbook, '$nomeArquivo.xlsx');

      contatos.add(contato);

      // Adiciona Snackbar para notificar sucesso
      Get.snackbar('Sucesso', 'Contato adicionado com sucesso!',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      // Adiciona Snackbar para notificar erro
      Get.snackbar('Erro', 'Erro ao adicionar contato: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

//!CRUD
  Future<void> adicionarRelatorio(
      Relatorio relatorio, String nomeArquivo) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];

    sheet.getRangeByIndex(1, 1).setText(excelTitle.nameTitle);
    sheet.getRangeByIndex(1, 2).setText(excelTitle.emailTitle);

    final int proximaLinha = contatos.length + 2;
    sheet.getRangeByIndex(proximaLinha, 1).setText(relatorio.nomeRebocador);
    sheet.getRangeByIndex(proximaLinha, 2).setText(relatorio.descricaoFalha);

    await salvarExcel(workbook, '$nomeArquivo.xlsx');

    relatorios_array.add(relatorio);
  }

  void showMessage() {
    // Adiciona Snackbar para notificar sucesso
    try {
      Get.snackbar('Sucesso', 'Feito com sucesso!',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      // Adiciona Snackbar para notificar erro
      Get.snackbar('Erro', 'Erro: $e', snackPosition: SnackPosition.BOTTOM);
    }

    // As demais funções para update, delete e load permanecem similares e podem ser implementadas conforme a necessidade específica do aplicativo.
  }
}
