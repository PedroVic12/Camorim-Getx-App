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

import '../../Scanner PDF/controller/nota_fiscal_controller.dart';

class BulbassauroExcelController {
  final NotaFiscalController controller = Get.put(NotaFiscalController());

//!CRUD
  // Função para ler um arquivo Excel
  void lerArquivoExcel(String filename) {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];

    // Realize as operações desejadas com os dados do arquivo Excel

    workbook.dispose();
  }

  // Função para deletar uma linha do arquivo Excel
  void deletarLinha(Worksheet sheet, int rowIndex) {
    sheet.deleteRow(rowIndex);
  }

  // Função para atualizar o arquivo Excel
  void updateExcel(
      Worksheet sheet, int rowIndex, int columnIndex, dynamic value) {
    final Range cell = sheet.getRangeByIndex(rowIndex, columnIndex);
    cell.setText(value.toString());
  }

  // Função para salvar o arquivo Excel
  void salvarExcel(Workbook workbook, String filename) {
    final List<int> bytes = workbook.saveAsStream();
    File(filename).writeAsBytes(bytes);
    workbook.dispose();
  }

  // Function to create an Excel document
  Future<void> createExcelDocument(String filename) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];

    final List<int> bytes = workbook.saveAsStream();
    await File(filename).writeAsBytes(bytes);
    workbook.dispose();
  }

  void salvarDadosNotaFiscal() async {
    final workbook = Workbook();
    final sheet = workbook.worksheets[0];

    // Add headers
    sheet.getRangeByName('A1').setText('Data');
    sheet.getRangeByName('B1').setText('Local');
    sheet.getRangeByName('C1').setText('Produtos');
    sheet.getRangeByName('D1').setText('Total');

    // Add data from the list
    int row = 2;
    for (final notaFiscal in controller.notasFiscais_ARRAY) {
      sheet.getRangeByName('A$row').setText(notaFiscal.data);
      sheet.getRangeByName('B$row').setText(notaFiscal.local);
      sheet.getRangeByName('C$row').setText(notaFiscal.produtos.join(', '));
      sheet.getRangeByName('D$row').setNumber(notaFiscal.total);
      row++;
    }

    // Save the Excel file
    salvarExcelWeb(workbook, 'notas_fiscais.xlsx');

    // Show success message
    BulbassauroExcelController().showMessage();
  }

//!GPT
  void insertRowsAndColumns(
      Worksheet sheet, int columnIndex, int startRow, int endRow) {
    sheet.insertColumn(columnIndex, 1);
    sheet.insertRow(
        startRow, endRow - startRow + 1, ExcelInsertOptions.formatAsAfter);
  }

// Function to get all rows from the document
  List<List<Range>> getAllRows(Worksheet sheet) {
    List<List<Range>> tableData = [];
    for (int row = 1; row <= sheet.getLastRow(); row++) {
      List<Range> rowData = [];
      for (int col = 1; col <= sheet.getLastColumn(); col++) {
        Range value = sheet.getRangeByIndex(row, col);
        rowData.add(value);
      }
      tableData.add(rowData);
    }
    return tableData;
  }

  // Function to read all rows and columns
  // Function to read all rows and columns
  List<List<Object>> readAllData(String filename) {
    final Workbook workbook = Workbook();
    final Worksheet sheet = Worksheet(workbook);

    final List<List<Object>> data = getAllRows(sheet);
    workbook.dispose();
    return data;
  }

//!UTILS
  salvarExcelWeb(Workbook wb, fileName) async {
    final List<int> bytes = wb.saveAsStream();
    wb.dispose();
    if (kIsWeb) {
      AnchorElement(
          href:
              'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
        ..setAttribute('download', '$fileName')
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

class BulbassauroExcelRepository {}

//! ANTIGO CONTROLLER
var contatos = <Contact>[].obs;

var relatorios_array = <Relatorio>[].obs;

final ExcelTitle excelTitle =
    ExcelTitle(nameTitle: "Nome", emailTitle: "Email"); // Títulos da planilha

Future<void> adicionarContato(Contact contato, String nomeArquivo) async {
  try {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];

    sheet.getRangeByIndex(1, 1).setText(excelTitle.nameTitle);
    sheet.getRangeByIndex(1, 2).setText(excelTitle.emailTitle);

    final int proximaLinha = contatos.length + 2;
    sheet.getRangeByIndex(proximaLinha, 1).setText(contato.name);
    sheet.getRangeByIndex(proximaLinha, 2).setText(contato.email);

    //await salvarExcelWeb(workbook, '$nomeArquivo.xlsx');

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
Future<void> adicionarRelatorio(Relatorio relatorio, String nomeArquivo) async {
  final Workbook workbook = Workbook();
  final Worksheet sheet = workbook.worksheets[0];

  sheet.getRangeByIndex(1, 1).setText(excelTitle.nameTitle);
  sheet.getRangeByIndex(1, 2).setText(excelTitle.emailTitle);

  final int proximaLinha = contatos.length + 2;
  sheet.getRangeByIndex(proximaLinha, 1).setText(relatorio.nomeRebocador);
  sheet.getRangeByIndex(proximaLinha, 2).setText(relatorio.descricaoFalha);

//  await salvarExcelWeb(workbook, '$nomeArquivo.xlsx');

  relatorios_array.add(relatorio);
}
