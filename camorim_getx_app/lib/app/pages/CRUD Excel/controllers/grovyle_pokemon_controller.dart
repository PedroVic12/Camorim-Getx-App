import 'dart:html' as html;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class GrovyleController {
  late String _filePath;
  late Workbook wb;

  GrovyleController() {
    _init();
  }

  setWorkBook() {
    wb = Workbook();
    return wb;
  }

  Future<void> _init() async {
    if (kIsWeb) {
      _filePath = 'database.xlsx'; // Caminho do arquivo para o Flutter web
    }
    setWorkBook();
  }

  Future<void> createData(Map<String, dynamic> data) async {
    try {
      final workbook = Workbook();
      final sheet = workbook.worksheets[0];
      final lastRow = sheet.getRangeByName('A1').lastRow + 1;
      _addData(sheet, lastRow, data, workbook);
      await workbook.save();
      workbook.dispose();
    } catch (e) {
      print('Error creating data: $e');
    }
  }

  Future<List<Map<String, dynamic>>> readData(Workbook workbook) async {
    try {
      final sheet = workbook.worksheets[0];
      final List<Map<String, dynamic>> dataList = [];

      for (var i = 2; i <= sheet.getRangeByName('A1').lastRow; i++) {
        final data = {
          'id': i,
          'embarcacao': sheet.getRangeByIndex(i, 1).text,
          'descricaoFalha': sheet.getRangeByIndex(i, 2).text,
          'equipamento': sheet.getRangeByIndex(i, 3).text,
          'dataCadastro': sheet.getRangeByIndex(i, 4).text,
        };
        dataList.add(data);
      }

      workbook.dispose();
      return dataList;
    } catch (e) {
      print('Error reading data: $e');
      return [];
    }
  }

  void _addHeaders(Worksheet sheet, Workbook workbook) {
    sheet.getRangeByIndex(1, 1).setText('Embarcação');
    sheet.getRangeByIndex(1, 2).setText('Descrição da Falha');
    sheet.getRangeByIndex(1, 3).setText('Equipamento');
    sheet.getRangeByIndex(1, 4).setText('Data de Cadastro');
    final headerStyle = workbook.styles.add('HeaderStyle');
    headerStyle.backColorRgb = Color.fromARGB(255, 0, 176, 240);
    headerStyle.bold = true;
    headerStyle.fontSize = 12;
    for (var i = 1; i <= sheet.rows.count; i++) {
      for (var j = 1; j <= sheet.columns.count; j++) {
        sheet.getRangeByIndex(i, j).cellStyle = headerStyle;
      }
    }
  }

  void _addData(Worksheet sheet, int rowIndex, Map<String, dynamic> data,
      Workbook workbook) {
    sheet.getRangeByIndex(rowIndex, 1).setText(data['embarcacao']);
    sheet.getRangeByIndex(rowIndex, 2).setText(data['descricaoFalha']);
    sheet.getRangeByIndex(rowIndex, 3).setText(data['equipamento']);
    sheet.getRangeByIndex(rowIndex, 4).setText(DateTime.now().toString());
    final dataStyle = workbook.styles.add('DataStyle');
    dataStyle.fontSize = 10;
    for (var i = rowIndex; i <= rowIndex; i++) {
      for (var j = 1; j <= sheet.columns.count; j++) {
        sheet.getRangeByIndex(i, j).cellStyle = dataStyle;
      }
    }
  }

  Future<void> deleteData(int rowIndex, Workbook workbook) async {
    try {
      final sheet = workbook.worksheets[0];
      sheet.deleteRow(rowIndex);
      await workbook.save();
      workbook.dispose();
    } catch (e) {
      print('Error deleting data: $e');
    }
  }
}
