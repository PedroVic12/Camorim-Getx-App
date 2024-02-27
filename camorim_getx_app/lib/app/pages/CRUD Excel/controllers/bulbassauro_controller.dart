import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../../Scanner PDF/controller/nota_fiscal_controller.dart';

import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ExcelOperations {
  Future generatePdf(Map<String, dynamic> dataset) async {
    final response = await http.post(
      Uri.parse('https://docker-raichu.onrender.com/gerar-pdf'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(dataset),
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Erro ao gerar PDF: ${response.statusCode}');
    }
  }

  Future<File> saveFile(Uint8List bytes, String fileName) async {
    final directory = await getApplicationSupportDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  Future<List<int>> saveRelatorioExcel() async {
    final workbook = Workbook();
    final sheet = workbook.worksheets[0];

    // Add headers
    int lineHeader = 1;
    sheet.getRangeByName('A$lineHeader').setText('EMBARCAÇÃO');
    // Add other headers...

    // Add data from the list
    int row = 2;
    // Add data to rows...

    final fileBytes = await _saveExcel(workbook, 'notas_fiscais.xlsx');
    workbook.dispose();
    return fileBytes;
  }

  Future<List<int>> _saveExcel(Workbook workbook, String filename) async {
    final bytes = workbook.saveAsStream();
    final directory = await getApplicationSupportDirectory();
    final file = File('${directory.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return bytes.toList();
  }
}

class BulbassauroController extends GetxController {
  final NotaFiscalController controller = Get.put(NotaFiscalController());
  final ExcelOperations excelOperations = ExcelOperations();

  Future<void> sendEmailFiles(List<int> fileBytesPdf, List<int> fileBytesExcel,
      String fileNamePdf, String fileNameExcel) async {
    try {
      // Construct FormData manually with the two files
      final formData = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://rayquaza-citta-server.onrender.com/enviar-email-arquivos'),
      );
      formData.files.add(http.MultipartFile.fromBytes(
        'arquivo_pdf',
        fileBytesPdf,
        filename: fileNamePdf,
      ));
      formData.files.add(http.MultipartFile.fromBytes(
        'arquivo_excel',
        fileBytesExcel,
        filename: fileNameExcel,
      ));

      // Send the request using http.Client
      final response = await http.Response.fromStream(await formData.send());

      if (response.statusCode == 200) {
        showMessage("Email enviado!!!");
      } else {
        print("Falha ao enviar email: ${response.statusCode}");
      }
    } catch (e) {
      print("Erro: $e");
    }
  }

  Future<void> gerarOsDigital(Map<String, dynamic> dataset) async {
    try {
      final Uint8List bytes = await excelOperations.generatePdf(dataset);

      var formattedDate =
          dataset["dados"]?["DATA INICIO"]?.replaceAll("/", "_");
      var fileName =
          "${dataset["dados"]?["EMBARCAÇÃO"]} - ${dataset["dados"]?["EQUIPAMENTO"]} - ${formattedDate}.pdf";

      final file = await excelOperations.saveFile(bytes, fileName);

      // Show success message
      showMessage("PDF Gerado: ${file.path}");
    } catch (e) {
      print('Erro ao gerar PDF: $e');
    }
  }

  void showMessage(String texto) {
    try {
      Get.snackbar(
        'Sucesso',
        texto,
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
        backgroundColor: Colors.green,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> salvarDadosRelatorioOS() async {
    try {
      final fileBytes = await excelOperations.saveRelatorioExcel();
      //await sendEmailFiles();
    } catch (e) {
      print("Erro ao salvar dados do relatório: $e");
    }
  }

  // Other controller methods...
}
