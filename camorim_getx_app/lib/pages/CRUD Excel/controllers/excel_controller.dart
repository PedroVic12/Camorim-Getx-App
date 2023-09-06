import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:universal_html/html.dart' show AnchorElement;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:camorim_getx_app/pages/CRUD%20Excel/model/contact_model.dart';
import 'package:get/get.dart';

class ExcelController extends GetxController {
  var contacts = <Contact>[].obs;

  final ExcelTitle excelTitle =
      ExcelTitle(nameTitle: "Name", emailTitle: "Email"); //! Títulos da planilha

  //! Função para salvar arquivo Excel
  Future<void> saveExcel(Workbook workbook, String filename) async {
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    if (kIsWeb) {
      downloadFileWeb(bytes, filename);
    } else {
      await saveFileLocal(bytes, filename);
    }
  }

  // !Função para baixar arquivo em ambiente Web
  void downloadFileWeb(List<int> bytes, String filename) {
    AnchorElement(
        href:
            'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
      ..setAttribute('download', filename)
      ..click();
  }

  //! Função para salvar arquivo localmente
  Future<void> saveFileLocal(List<int> bytes, String filename) async {
    final String path = (await getApplicationSupportDirectory()).path;
    final String filePath =
        Platform.isWindows ? '$path\\$filename' : '$path/$filename';
    final File file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(filePath);
  }

  //! CRUD - Create
  Future<void> addContact(Contact contact) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];

    // Definindo os títulos para as colunas
    sheet.getRangeByIndex(1, 1).setText(excelTitle.nameTitle);
    sheet.getRangeByIndex(1, 2).setText(excelTitle.emailTitle);

    // Adicionando o contato ao Excel na próxima linha disponível
    final int nextRow = contacts.length + 2;
    sheet.getRangeByIndex(nextRow, 1).setText(contact.name);
    sheet.getRangeByIndex(nextRow, 2).setText(contact.email);

    // Salva o arquivo Excel
    await saveExcel(workbook, 'Contacts.xlsx');

    // Adiciona o contato à lista observável
    contacts.add(contact);
  }

  // !CRUD - Update (esboço)
  Future<void> updateContact(int index, Contact updatedContact) async {
    // Aqui, você irá carregar o arquivo Excel existente, encontrar o contato pelo índice, atualizar e salvar novamente.
    // Para simplicidade, estou omitindo a implementação detalhada aqui.
  }

  //! CRUD - Delete (esboço)
  Future<void> deleteContact(int index) async {
    // Aqui, você irá carregar o arquivo Excel existente, encontrar o contato pelo índice, deletar e salvar novamente.
    // Para simplicidade, estou omitindo a implementação detalhada aqui.
  }

  // !CRUD - Read (esboço)
  Future<void> loadContacts() async {
    // Aqui, você irá carregar o arquivo Excel e adicionar contatos à lista de contatos (contacts).
    // Para simplicidade, estou omitindo a implementação detalhada aqui.
  }
}
