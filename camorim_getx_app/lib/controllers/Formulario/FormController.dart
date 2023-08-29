import 'dart:io';

import 'package:camorim_getx_app/repository/nivelRepository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;

import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:universal_html/html.dart' show AnchorElement;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';

class FormController extends GetxController {
  //! Formulário Ferramentas
  final nomeController = TextEditingController();
  final ferramentaController = TextEditingController();
  final quantidadeController = TextEditingController();
  final dataNascimentoController = TextEditingController();
  final localController = TextEditingController();

  //! Formulário Dique
  final idItem = TextEditingController();
  final nomeEquipamento = TextEditingController();
  final bordo = TextEditingController();
  final potencia = TextEditingController();
  final endereco = TextEditingController();
  final dataRetiradaDique = TextEditingController();
  final dataEntradaDique = TextEditingController();
  final nomeNavio = TextEditingController();
  final opcoesDique = TextEditingController();
  final isOkayParaUso = TextEditingController();
  final classificacao = TextEditingController();
  final situacaoEquipamento = TextEditingController();
  final assetsEquipamento = TextEditingController();
  final observacoesDique = TextEditingController();
  var campos = <String>[].obs;

  //!Variáveis
  var dataNascimento = DateTime.now().obs;
  var nivelSelecionado = ''.obs;
  var opcaoSelecionada = <String>[].obs;
  var salarioEscolhido = 0.0.obs;
  var quantidade = 1.obs;

  //! Repositórios
  final NivelRepository nivelRepository = NivelRepository();
  final OpcoesRepository opcoesRepository = OpcoesRepository();
  var niveis = <String>[].obs;
  var opcoes = <String>[].obs;

  //! Métodos
  Future<void> createExcel({
    required List<TextEditingController> controllers,
    required List<String> labels,
  }) async {
    final DateTime now = DateTime.now();
    final String formattedDate = "${now.year}-${now.month}-${now.day}";
    final String fileName = "${idItem}_$formattedDate.xlsx";

    final Workbook workbook = Workbook();

    Worksheet sheet;
    if (workbook.worksheets.count > 0 &&
        workbook.worksheets[0].name == 'Sample') {
      sheet = workbook.worksheets[0];
    } else {
      sheet = workbook.worksheets.addWithName('Sample');
    }

    int nextEmptyRow = 2;
    while (sheet.getRangeByName('A${nextEmptyRow}').text != '') {
      nextEmptyRow++;
    }

    // If it's a new file, add labels
    if (nextEmptyRow == 2) {
      for (int i = 0; i < labels.length; i++) {
        final String cellName = String.fromCharCode(65 + i) + '1';
        sheet.getRangeByName(cellName).setText(labels[i]);
      }
    }

    // Add data to the next empty row
    for (int i = 0; i < controllers.length; i++) {
      final String cellName =
          String.fromCharCode(65 + i) + nextEmptyRow.toString();
      sheet.getRangeByName(cellName).setText(controllers[i].text);
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    if (kIsWeb) {
      AnchorElement(
          href:
              'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
        ..setAttribute('download', fileName)
        ..click();
    } else {
      final String appDirectoryPath =
          (await getApplicationSupportDirectory()).path;
      final String repositoryPath =
          p.join(appDirectoryPath, "lib", "repository");
      final Directory directory = Directory(repositoryPath);
      final String filePath = p.join(directory.path, fileName);
      final File file = File(filePath);
      await file.writeAsBytes(bytes, flush: true);
      OpenFile.open(filePath);
    }
  }

  bool validateFormData() {
    if (nomeController.text.trim().length < 3) {
      Get.snackbar(
        'Erro',
        'Nome da ferramenta deve ter mais de 3 caracteres',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (dataNascimento == null) {
      Get.snackbar(
        'Erro',
        'Selecione uma data de retirada',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (opcaoSelecionada.isEmpty) {
      Get.snackbar(
        'Erro',
        'Selecione ao menos uma opção',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (nivelSelecionado.isEmpty) {
      Get.snackbar(
        'Erro',
        'Selecione um nível',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (salarioEscolhido == 0) {
      Get.snackbar(
        'Erro',
        'Defina uma pretensão salarial',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  @override
  void onInit() {
    super.onInit();
    niveis.assignAll(nivelRepository.retornaNiveis());
    opcoes.assignAll(opcoesRepository.retornarOpcoes());
  }
}
