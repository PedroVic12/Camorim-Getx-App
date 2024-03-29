import 'dart:convert';
import 'dart:io';
import 'dart:core';

import 'package:camorim_getx_app/app/pages/CRUD%20Excel/model/contact_model.dart';
import 'package:camorim_getx_app/app/pages/Relatorio%20OS/models/RelatorioModel.dart';
import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/cadastro_controllers.dart';
import 'package:dio/dio.dart' as DioApp;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;

import '../../Scanner PDF/controller/nota_fiscal_controller.dart';

class BulbassauroExcelController {
  final NotaFiscalController controller = Get.put(NotaFiscalController());
  final CadastroController relatorio_controller = Get.put(CadastroController());
  DioApp.Dio dio = DioApp.Dio();
  final String urlRaichu = 'https://docker-raichu.onrender.com';

  Future<void> uploadFiles(fileBytes) async {
    for (var file in fileBytes) {
      print(file.runtimeType);
    }

    // Construct FormData manually
    final DioApp.FormData formData = DioApp.FormData.fromMap({
      'arquivo':
          DioApp.MultipartFile.fromBytes(fileBytes, filename: "fileName"),
    });

    // Send the request using Dio
    final response = await dio.post(
      '$urlRaichu/upload',
      data: formData,
      options: DioApp.Options(
        headers: {'Content-Type': 'multipart/form-data'},
      ),
    );
    print("resposta = ${response.statusCode}");

    if (response.statusCode == 200) {
      print("Email enviado com sucesso!");
    }
  }

  Future<void> sendEmailFiles(
    List<int> fileBytesPdf,
    List<int> fileBytesExcel,
    String fileNamePdf,
    String fileNameExcel,
  ) async {
    try {
      // Construir FormData com os dois arquivos
      DioApp.FormData formData = DioApp.FormData.fromMap({
        'arquivo_pdf': DioApp.MultipartFile.fromBytes(
          fileBytesPdf,
          filename: fileNamePdf,
        ),
        'arquivo_excel': DioApp.MultipartFile.fromBytes(
          fileBytesExcel,
          filename: fileNameExcel,
        ),
      });

      // Enviar a solicitação POST
      DioApp.Response response = await dio.post(
        'https://docker-raichu.onrender.com/enviar-email-arquivos',
        data: formData,
        //options: DioApp.Options(),
      );

      // Verificar o código de status da resposta
      if (response.statusCode == 200) {
        print("\n\nEmail enviado com sucesso!");
      } else {
        print("Falha ao enviar email: ${response.statusCode}");
      }
    } catch (e) {
      print("Erro: $e");
    }
  }

  void saveBytesOnWeb(bytes, fileName) {
    // Salvar o arquivo no disco
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", fileName)
      ..click();

    // Limpar a URL
    html.Url.revokeObjectUrl(url);
  }

  gerarOsDigital(dataset) async {
    try {
      // Dados para enviar como JSON
      var requestData = dataset;

      // Enviar solicitação POST para o servidor FastAPI
      var response = await http.post(
        Uri.parse('https://docker-raichu.onrender.com/gerar-pdf'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      print('\nStatus code: ${response.statusCode}');

      // Verificar se a solicitação foi bem-sucedida
      if (response.statusCode == 200) {
        // Converter a resposta em bytes
        Uint8List bytes = response.bodyBytes;

        var formattedDate =
            dataset["dados"]?["DATA INICIO"]?.replaceAll("/", "_");

        var fileName =
            "${dataset["dados"]?["EMBARCAÇÃO"]} - ${dataset["dados"]?["EQUIPAMENTO"]} - ${formattedDate}.pdf";

        print("Arquivo ${fileName} gerado!");

        return bytes;
      } else {
        print('Erro ao baixar o PDF: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro: $e');
    }
  }

  Future<void> enviarEmail(fileBytes, String fileName) async {
    try {
      // Construct FormData manually
      final DioApp.FormData formData = DioApp.FormData.fromMap({
        'arquivo':
            DioApp.MultipartFile.fromBytes(fileBytes, filename: fileName),
      });

      // Send the request using Dio
      final response = await dio.post(
        'https://rayquaza-citta-server.onrender.com/enviar-email-arquivos',
        data: formData,
        options: DioApp.Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );

      if (response.statusCode == 200) {
        print("Email enviado com sucesso!");
        showMessage("Email enviado");
      } else {
        print("Falha ao enviar email: ${response.statusCode}");
      }
    } catch (e) {
      print("Erro: $e");
    }
  }

  //!UTILS
  salvarExcelWeb(Workbook wb, fileName) async {
    final List<int> bytes = wb.saveAsStream();
    wb.dispose();
    if (kIsWeb) {
      saveBytesOnWeb(bytes, fileName);
      return bytes.toList();
    } else {
      final String path = (await getApplicationSupportDirectory()).path;
      final String filePath = '$path/$fileName';
      final File file = File(filePath);
      await file.writeAsBytes(bytes, flush: true);
      OpenFile.open(filePath);
      return await file.readAsBytes();
    }
  }

  void showMessage(texto) {
    // Adiciona Snackbar para notificar sucesso
    try {
      Get.snackbar('Sucesso', texto,
          snackPosition: SnackPosition.TOP,
          colorText: Colors.white,
          backgroundColor: Colors.green);
    } catch (e) {
      // Adiciona Snackbar para notificar erro
      Get.snackbar('Erro', 'Erro: $e',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
  }

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

  gerarExcelDatabaseMongoDB(List array) async {
    final workbook = Workbook();
    final sheet = workbook.worksheets[0];
    var dataAtualFormatada = DateTime.now().toString().split(" ")[0];

    // Add headers
    int lineHeader = 1;
    sheet.getRangeByName('A$lineHeader').setText('EMBARCAÇÃO');
    sheet.getRangeByName('B1').setText('DATA INICIO');
    sheet.getRangeByName('C1').setText('DESCRIÇÃO DA FALHA');
    sheet.getRangeByName('D1').setText('EQUIPAMENTO');
    sheet.getRangeByName('E1').setText('MANUTENÇÃO');
    sheet.getRangeByName('F1').setText('SERVIÇO EXECUTADO');
    sheet.getRangeByName('G1').setText('DATA INICIO');
    sheet.getRangeByName('H1').setText('HORA INICIAL');
    sheet.getRangeByName('I$lineHeader').setText('RESPONSAVEL');
    sheet.getRangeByName('J$lineHeader').setText('OFICINA');
    sheet.getRangeByName('K$lineHeader').setText('FINALIZADO');
    sheet.getRangeByName('L$lineHeader').setText('DATA FINAL');
    sheet.getRangeByName('M$lineHeader').setText('HORA FINAL');
    sheet.getRangeByName('N$lineHeader').setText('FORA DE OPERAÇÃO ');
    sheet.getRangeByName('O$lineHeader').setText('OBS');
    sheet.getRangeByName('P$lineHeader').setText('CADASTRO DATE BY FLUTTER');

    // formatação
    sheet.getRangeByName('A1:P1').cellStyle.fontSize = 14;
    sheet.getRangeByName('A1:P1').cellStyle.bold = true;
    sheet.getRangeByName('A1:P1').cellStyle.backColor = "#ff0000";
    sheet.getRangeByName('A1:P1').cellStyle.fontColor = "#ffffff";
    sheet.getRangeByName('A1:P1').autoFitColumns();

    // Add data from the list
    int row = 2;
    for (var data in array) {
      sheet.getRangeByName('A$row').setText(data["BARCO"]);
      sheet.getRangeByName('B$row').setText(data["DATA_INICIO"]);
      sheet.getRangeByName('C$row').setText(data["DESC_FALHA"]);
      sheet.getRangeByName('D$row').setText(data["EQUIPAMENTO"]);
      sheet.getRangeByName('E$row').setText(data["MANUTENCAO"]);
      sheet.getRangeByName('F$row').setText(data["SERV_EXECUTADO"]);
      sheet.getRangeByName('G$row').setText(data["DATA_EXEC"]);
      sheet.getRangeByName('H$row').setText(data["HORA_INICIO"]);
      sheet.getRangeByName('I$row').setText(data["RESPONSAVEL"].toString());
      sheet.getRangeByName('J$row').setText(data["OFICINA"]);
      sheet.getRangeByName('K$row').setText(data["FINALIZADO"].toString());
      sheet.getRangeByName('L$row').setText(data["DATA_CONCLUSAO"].toString());
      sheet.getRangeByName('M$row').setText(data["HORA_FINAL"].toString());
      sheet.getRangeByName('N$row').setText(data["FORA_OPERACAO"]);
      sheet.getRangeByName('O$row').setText(data["OBS"]);
      sheet.getRangeByName('P$row').setText(dataAtualFormatada);

      row++;
    }

    // Save the Excel file
    var fileBytesExcel = await salvarExcelWeb(workbook, 'relatorio.xlsx');

    try {
      return fileBytesExcel;
    } catch (e) {
      print("Erro ao enviar email: $e");
    }

    // Show success message
    BulbassauroExcelController().showMessage(" Salvo!");
  }

  gerarExcelDadosRelatorioOS() async {
    final workbook = Workbook();
    final sheet = workbook.worksheets[0];
    var dataAtualFormatada = DateTime.now().toString().split(" ")[0];

    // Add headers
    int lineHeader = 1;
    sheet.getRangeByName('A$lineHeader').setText('EMBARCAÇÃO');
    sheet.getRangeByName('B1').setText('DATA INICIO');
    sheet.getRangeByName('C1').setText('DESCRIÇÃO DA FALHA');
    sheet.getRangeByName('D1').setText('EQUIPAMENTO');
    sheet.getRangeByName('E1').setText('MANUTENÇÃO');
    sheet.getRangeByName('F1').setText('SERVIÇO EXECUTADO');
    sheet.getRangeByName('G1').setText('DATA INICIO');
    sheet.getRangeByName('H1').setText('HORA INICIAL');
    sheet.getRangeByName('I$lineHeader').setText('RESPONSAVEL');
    sheet.getRangeByName('J$lineHeader').setText('OFICINA');
    sheet.getRangeByName('K$lineHeader').setText('FINALIZADO');
    sheet.getRangeByName('L$lineHeader').setText('DATA FINAL');
    sheet.getRangeByName('M$lineHeader').setText('HORA FINAL');
    sheet.getRangeByName('N$lineHeader').setText('FORA DE OPERAÇÃO ');
    sheet.getRangeByName('O$lineHeader').setText('OBS');
    sheet.getRangeByName('P$lineHeader').setText('CADASTRO DATE BY FLUTTER');

    // formatação
    sheet.getRangeByName('A1:P1').cellStyle.fontSize = 14;
    sheet.getRangeByName('A1:P1').cellStyle.bold = true;
    sheet.getRangeByName('A1:P1').cellStyle.backColor = "#ff0000";
    sheet.getRangeByName('A1:P1').cellStyle.fontColor = "#ffffff";
    sheet.getRangeByName('A1:P1').autoFitColumns();

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
      sheet.getRangeByName('H$row').setText(data.horaInicial);
      sheet.getRangeByName('I$row').setText(data.funcionario.join(', '));
      sheet.getRangeByName('J$row').setText(data.oficina);
      sheet.getRangeByName('K$row').setText(data.status_finalizado.toString());
      sheet.getRangeByName('L$row').setText(data.dataFinal.toString());
      sheet.getRangeByName('M$row').setText(data.horaInicial);
      sheet.getRangeByName('N$row').setText("NÃO");
      sheet.getRangeByName('O$row').setText(data.obs);
      sheet.getRangeByName('P$row').setText(dataAtualFormatada);

      row++;
    }

    // Save the Excel file
    var fileBytesExcel = await salvarExcelWeb(workbook, 'relatorio.xlsx');

    try {
      return fileBytesExcel;
    } catch (e) {
      print("Erro ao enviar email: $e");
    }

    // Show success message
    BulbassauroExcelController().showMessage(" Salvo!");
  }

  salvarDadosRelatorioOS() async {
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
    sheet.getRangeByName('A1:M1').cellStyle.fontSize = 14;
    sheet.getRangeByName('A1:M1').cellStyle.bold = true;
    sheet.getRangeByName('A1:M1').cellStyle.backColor = "#ff0000";
    sheet.getRangeByName('A1:M1').cellStyle.fontColor = "#ffffff";
    sheet.getRangeByName('A1:M1').autoFitColumns();

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
      sheet.getRangeByName('K$row').setText(data.dataFinal.toString());
      sheet.getRangeByName('L$row').setText("NÃO");
      sheet.getRangeByName('M$row').setText(data.obs);

      row++;
    }

    // Save the Excel file
    var fileBytesExcel = await salvarExcelWeb(workbook, 'dados.xlsx');

    print("Arquivo excel salvo com sucesso!");

    try {
      return fileBytesExcel;
    } catch (e) {
      print("Erro ao enviar email: $e");
    }

    // Show success message
    BulbassauroExcelController().showMessage("Excel Salvo!");
  }

  getDadosToPdf() {
    var dadosCadastrados = {};
    for (final data in relatorio_controller.array_cadastro) {
      dadosCadastrados["BARCO"] = data.rebocador;
      dadosCadastrados["DATA_INICIO"] = data.dataInicial;
      dadosCadastrados["DESC_FALHA"] = data.descFalha;
      dadosCadastrados["EQUIPAMENTO"] = data.equipamento;
      dadosCadastrados["MANUTENCAO"] = data.tipoManutencao;
      dadosCadastrados["SERV_EXECUTADO"] = data.servicoExecutado;
      dadosCadastrados["DATA_EXEC"] = data.dataInicial;
      dadosCadastrados["RESPONSAVEL"] = data.funcionario.join(', ');
      dadosCadastrados["OFICINA"] = data.oficina;
      dadosCadastrados["FINALIZADO"] = data.status_finalizado.toString();
      dadosCadastrados["DATA_CONCLUSAO"] = data.dataFinal.toString();
      dadosCadastrados["FORA_OPERAÇÃO "] = "NÃO";
      dadosCadastrados["OBS"] = data.obs;
    }

    return dadosCadastrados;
  }

  void salvarDadosNotaFiscal() async {
    final workbook = Workbook();
    final sheet = workbook.worksheets[0];

    // Add headers
    int lineHeader = 1;
    sheet.getRangeByName('A$lineHeader').setText('Data');
    sheet.getRangeByName('B1').setText('Tipos de Despesas');
    sheet.getRangeByName('C1').setText('Valor');
    sheet.getRangeByName('D1').setText('CONTA CONTÁBIL');
    sheet.getRangeByName('E1').setText('Embarcação');
    sheet.getRangeByName('F1').setText('Local');
    sheet.getRangeByName('G1').setText('Produtos');

    // formatação
    sheet.getRangeByName('A1:G1').cellStyle.fontSize = 14;
    sheet.getRangeByName('A1:G1').cellStyle.bold = true;
    sheet.getRangeByName('A1:G1').cellStyle.backColor = "#ff0000";
    sheet.getRangeByName('A1:G1').cellStyle.fontColor = "#ffffff";
    sheet.getRangeByName('A1:G1').autoFitColumns();

    // Add data from the list
    int row = 2;
    for (final notaFiscal in controller.notasFiscais_ARRAY) {
      sheet.getRangeByName('A$row').setText(notaFiscal.data);
      sheet.getRangeByName('B$row').setText(notaFiscal.categoria);
      sheet.getRangeByName('C$row').setNumber(notaFiscal.total);
      sheet.getRangeByName('D$row').setText(" ");
      sheet.getRangeByName('E$row').setText(notaFiscal.navio);
      sheet.getRangeByName('F$row').setText(notaFiscal.produtos.join(', '));
      sheet.getRangeByName('G$row').setText(notaFiscal.local);

      row++;
    }
    sheet.getRangeByName('A2:F20').cellStyle.fontSize = 10;
    sheet.getRangeByName('A2:F20').cellStyle.hAlign = HAlignType.center;

    // Save the Excel file
    final List<int> fileBytes =
        await salvarExcelWeb(workbook, 'notas_fiscais.xlsx');
    try {
      // Enviar email
      await enviarEmail(fileBytes, 'Output.xlsx');
    } catch (e) {
      print("Erro ao enviar email: $e");
    }

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
}
