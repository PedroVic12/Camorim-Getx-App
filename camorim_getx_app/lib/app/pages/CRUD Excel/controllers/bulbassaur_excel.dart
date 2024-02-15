import 'dart:io';

import 'package:camorim_getx_app/app/pages/CRUD%20Excel/model/contact_model.dart';
import 'package:camorim_getx_app/app/pages/Relatorio%20OS/models/RelatorioModel.dart';
import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/cadastro_controllers.dart';
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
  final CadastroController relatorio_controller = Get.put(CadastroController());

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

  void salvarDadosRelatorioOS() async {
    final workbook = Workbook();
    final sheet = workbook.worksheets[0];

    // Add headers
    int lineHeader = 1;
    sheet.getRangeByName('A$lineHeader').setText('EMBARCAÇÃO');
    sheet.getRangeByName('B1').setText('DATA INICIO');
    sheet.getRangeByName('C1').setText('DESCRIÇÃO DA FALHA');
    sheet.getRangeByName('D1').setText('EQUIPAMENTO');
    sheet.getRangeByName('E1').setText('MANUTENÇÃO');
    sheet.getRangeByName('F1').setText('SERVIÇO EXECUTADO');
    sheet.getRangeByName('G1').setText('DATA INICIO');
    sheet.getRangeByName('H$lineHeader').setText('RESPONSAVEL');
    sheet.getRangeByName('I$lineHeader').setText('OFICINA');
    sheet.getRangeByName('J$lineHeader').setText('FINALIZADO');
    sheet.getRangeByName('K$lineHeader').setText('DATA FINAL');
    sheet.getRangeByName('L$lineHeader').setText('FORA DE OPERAÇÃO ');
    sheet.getRangeByName('M$lineHeader').setText('OBS');

    // formatação
    sheet.getRangeByName('A1:F1').cellStyle.fontSize = 14;
    sheet.getRangeByName('A1:F1').cellStyle.bold = true;
    sheet.getRangeByName('A1:F1').cellStyle.backColor = "#ff0000";
    sheet.getRangeByName('A1:F1').cellStyle.fontColor = "#ffffff";
    sheet.getRangeByName('A1:G1').autoFitColumns();

    // Add data from the list
    int row = 2;
    for (final data in relatorio_controller.array_cadastro) {
      sheet.getRangeByName('A$row').setText(data.rebocador);
      sheet.getRangeByName('B$row').setText(data.dataInicial);
      sheet.getRangeByName('C$row').setText(data.descFalha);
      sheet.getRangeByName('D$row').setText(data.equipamento);
      sheet.getRangeByName('E$row').setText(data.tipoManutencao);
      sheet.getRangeByName('F$row').setText(data.servicoExecutado);
      sheet.getRangeByName('G$row').setText(data.dataInicial);
      sheet.getRangeByName('H$row').setText(data.funcionario.join(', '));
      sheet.getRangeByName('I$row').setText(data.oficina);
      sheet.getRangeByName('J$row').setText(data.status_finalizado.toString());
      sheet.getRangeByName('J$row').setText(data.dataFinal.toString());
      sheet.getRangeByName('J$row').setText(data.obs);

      row++;
    }

    // Save the Excel file
    salvarExcelWeb(workbook, 'relatorio_info.xlsx');

    // Show success message
    BulbassauroExcelController().showMessage("Excel Salvo!");
  }

  void salvarDadosNotaFiscal() async {
    final workbook = Workbook();
    final sheet = workbook.worksheets[0];

    // Add headers
    int lineHeader = 1;
    sheet.getRangeByName('A$lineHeader').setText('Data');
    sheet.getRangeByName('B1').setText('Embarcação');
    sheet.getRangeByName('C1').setText('Tipo de Despesas');
    sheet.getRangeByName('D1').setText('Local');
    sheet.getRangeByName('E1').setText('Produtos');
    sheet.getRangeByName('F1').setText('Total');

    // formatação
    sheet.getRangeByName('A1:F1').cellStyle.fontSize = 14;
    sheet.getRangeByName('A1:F1').cellStyle.bold = true;
    sheet.getRangeByName('A1:F1').cellStyle.backColor = "#ff0000";
    sheet.getRangeByName('A1:F1').cellStyle.fontColor = "#ffffff";
    sheet.getRangeByName('A1:G1').autoFitColumns();

    // Add data from the list
    int row = 2;
    for (final notaFiscal in controller.notasFiscais_ARRAY) {
      sheet.getRangeByName('A$row').setText(notaFiscal.data);
      sheet.getRangeByName('B$row').setText(notaFiscal.navio);
      sheet.getRangeByName('C$row').setText(notaFiscal.categoria);
      sheet.getRangeByName('D$row').setText(notaFiscal.local);
      sheet.getRangeByName('E$row').setText(notaFiscal.produtos.join(', '));
      sheet.getRangeByName('F$row').setNumber(notaFiscal.total);

      row++;
    }

    // Save the Excel file
    salvarExcelWeb(workbook, 'notas_fiscais.xlsx');

    // Show success message
    BulbassauroExcelController().showMessage("Excel Salvo!");
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

  void showMessage(texto) {
    // Adiciona Snackbar para notificar sucesso
    try {
      Get.snackbar('Sucesso', texto, snackPosition: SnackPosition.TOP);
    } catch (e) {
      // Adiciona Snackbar para notificar erro
      Get.snackbar('Erro', 'Erro: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
