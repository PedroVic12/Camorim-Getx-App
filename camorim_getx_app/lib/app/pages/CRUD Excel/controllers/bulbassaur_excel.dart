import 'dart:io';

import 'package:camorim_getx_app/app/pages/CRUD%20Excel/model/contact_model.dart';
import 'package:camorim_getx_app/app/pages/Relatorio%20OS/models/RelatorioModel.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:universal_html/html.dart' show AnchorElement;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';

class BulbassaurExcelController extends GetxController {
  void abrirArquivo() async {
    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = '$path/output_flutter.xlsx';
    //final File file = File(fileName);
    //await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
  }

  void connectExcel() async {
    final Workbook wb = Workbook();
    final List<int> bytes = wb.saveAsStream();
    wb.dispose();
  }

  void salvar_excel(wb) {
    final List<int> bytes = wb.saveAsStream();
    wb.dispose();
  }

  Future<void> create_excel() async {
    final Workbook wb = Workbook();
    final Worksheet sheet = wb.worksheets[0];
    final sheetNames = wb.worksheets;

    sheet.getRangeByName('A1').setText('Hello World');

    salvar_excel(wb);
  }

  //! ANTIGO CONTROLLER
  var contatos = <Contact>[].obs;

  var relatorios_array = <Relatorio>[].obs;

  final ExcelTitle excelTitle =
      ExcelTitle(nameTitle: "Nome", emailTitle: "Email"); // Títulos da planilha

  salvarExcelWeb(Workbook wb, fileName) async {
    final Worksheet sheet = wb.worksheets[0];
    sheet.getRangeByName('A1').setText('Hello World!');
    final List<int> bytes = wb.saveAsStream();
    wb.dispose();
    if (kIsWeb) {
      AnchorElement(
          href:
              'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
        ..setAttribute('download', 'Output.xlsx')
        ..click();
    } else {
      final String path = (await getApplicationSupportDirectory()).path;
      final String fileName =
          Platform.isWindows ? '$path\\Output.xlsx' : '$path/Output.xlsx';
      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
      OpenFile.open(fileName);
    }
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

      await salvarExcelWeb(workbook, '$nomeArquivo.xlsx');

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

    await salvarExcelWeb(workbook, '$nomeArquivo.xlsx');

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
  }
}
