import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class CrudExcelBulbasaur {
  late Workbook workbook;
  final String fileName;

  CrudExcelBulbasaur({this.fileName = 'sample.xlsx'}) {
    workbook = Workbook();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File(join(path, fileName));
  }

  //! Criar uma nova planilha e adicionar dados
  Future<void> criarArquivoExcel() async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.name = "Plan1";
    sheet.getRangeByName('A1').setText('TEXTO');
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String path = await _localPath;
    final String fileName = '$path/output.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    abrirArquivo(fileName);
  }


    Future<void> criarRelatorioOS() async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.name = "Plan1";
    sheet.getRangeByName('A1').setText('TEXTO'); // TODO AQUI COM MODEL E CONTROLLER COM TEXTFORMFIELD
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String path = await _localPath;
    final String fileName = '$path/output.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    abrirArquivo(fileName);
  }

  void abrirArquivo(name) {
    OpenFile.open(name);
  }

  // Ler os dados de uma planilha
  Future<List<List<Object>>> readSheet(String sheetName) async {
    final file = await _localFile;
    if (!await file.exists()) {
      return [];
    }

    final List<int> bytes = await file.readAsBytes();
    final Worksheet sheet = workbook.worksheets[sheetName];

    // final int rowCount = sheet.usedRange.rowCount;
    //final int colCount = sheet.usedRange.columnCount;
    int rowCount = 10;
    int colCount = 10;

    List<List<Object>> data = [];
    for (int i = 0; i < rowCount; i++) {
      List<Object> rowData = [];
      for (int j = 0; j < colCount; j++) {
        //rowData.add(sheet.getRangeByIndex(i + 1, j + 1).text);
      }
      data.add(rowData);
    }
    return data;
  }

  // Atualizar uma célula específica
  Future<void> updateCell(
      {required String sheetName,
      required int row,
      required int col,
      required Object value}) async {
    final file = await _localFile;
    final List<int> bytes = await file.readAsBytes();
    //workbook.openBytes(bytes);

    final Worksheet sheet = workbook.worksheets[sheetName];
    sheet.getRangeByIndex(row, col).setValue(value.toString());

    final List<int> newBytes = workbook.saveAsStream();
    await file.writeAsBytes(newBytes);
  }

  // Deletar uma planilha
  Future<void> deleteSheet(String sheetName) async {
    //workbook.worksheets.remove(sheetName);

    final file = await _localFile;
    final List<int> newBytes = workbook.saveAsStream();
    await file.writeAsBytes(newBytes);
  }
}
