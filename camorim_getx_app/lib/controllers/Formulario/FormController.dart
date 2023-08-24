import 'package:camorim_getx_app/repository/nivelRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class FormController extends GetxController {
  // Formulário
  final nomeController = TextEditingController();
  final ferramentaController = TextEditingController();
  final quantidadeController = TextEditingController();
  final dataNascimentoController = TextEditingController();
  final localController = TextEditingController();

  //Variáveis
  var dataNascimento = DateTime.now().obs;
  var nivelSelecionado = ''.obs;
  var opcaoSelecionada = <String>[].obs;
  var salarioEscolhido = 0.0.obs;
  var quantidade = 1.obs;

  // Repositórios
  final NivelRepository nivelRepository = NivelRepository();
  final OpcoesRepository opcoesRepository = OpcoesRepository();
  var niveis = <String>[].obs;
  var opcoes = <String>[].obs;

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
