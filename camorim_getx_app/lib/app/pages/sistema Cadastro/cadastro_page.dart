import 'package:camorim_getx_app/widgets/NavBarCustom.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/AppBarPersonalizada.dart';
import '../../../widgets/CaixaDeTexto.dart';
import '../CRUD Excel/controllers/excel_controller.dart';

class SistemaCadastroPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final ExcelController excel_controller = Get.put(ExcelController());
  final CadastroController relatorio_controller = Get.put(CadastroController());

  SistemaCadastroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPersonalizada(
        titulo: 'Sistema de Cadastro Excel + Web Service',
      ),
      body: ListView(
        children: [
          FormsListRelatorio(),
          Obx(() {
            final model = relatorio_controller.currentModel.value;
            final models = relatorio_controller.array_cadastro;
            if (model != null) {
              return Column(
                children: models
                    .map((element) => Card(
                        color: Colors.lightBlue,
                        child: ListTile(
                          title: Text(element.equipamento),
                          subtitle: Column(
                            children: [
                              Text(
                                element.rebocador,
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                element.acao,
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              models.remove(element);
                            },
                          ),
                        )))
                    .toList(),
              );
            } else {
              return Text('Sem dados cadastrados :(');
            }
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          relatorio_controller.salvar(
            context,
          );
        },
        child: Text('SALVAR!'),
      ),
    );
  }
}

class FormsListRelatorio extends StatelessWidget {
  final CadastroController relatorio_controller = Get.put(CadastroController());
  FormsListRelatorio({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CaixaDeTexto(
            controller: relatorio_controller.EQUIPAMENTO_TEXT,
            labelText: 'EQUIPAMENTO'),
        CaixaDeTexto(
            controller: relatorio_controller.nomeRebocadorText,
            labelText: 'REBOCADOR'),
        CaixaDeTexto(
            controller: relatorio_controller.ACAOTEXT,
            labelText: 'DESCRIÇÃO DA AÇÃO'),
        CaixaDeTexto(
            controller: relatorio_controller.STATUSTEXT, labelText: 'STATUS'),
        CaixaDeTexto(
            controller: relatorio_controller.GRUPO, labelText: 'GRUPO'),
      ],
    );
  }
}

class CadastroController extends GetxController {
  final EQUIPAMENTO_TEXT = TextEditingController();
  final nomeRebocadorText = TextEditingController();
  final ACAOTEXT = TextEditingController();
  final STATUSTEXT = TextEditingController();
  final GRUPO = TextEditingController();

  final servicoFinalizado = false.obs;
  final _formKey = GlobalKey<FormState>();
  final array_cadastro = <CadastroModel>[].obs;

  // Modelo atual
  var currentModel = Rx<CadastroModel?>(null);

  void salvar(BuildContext context) {
    if (EQUIPAMENTO_TEXT.text.isEmpty ||
        nomeRebocadorText.text.isEmpty ||
        ACAOTEXT.text.isEmpty ||
        STATUSTEXT.text.isEmpty ||
        GRUPO.text.isEmpty) {
      Get.snackbar(
        "Erro",
        "Todos os campos devem ser preenchidos",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final model = CadastroModel(
      EQUIPAMENTO_TEXT.text,
      rebocador: nomeRebocadorText.text,
      acao: ACAOTEXT.text,
      status: STATUSTEXT.text,
      tipoManutencao: servicoFinalizado.value,
    );
    currentModel.value = model;

    array_cadastro.add(model);

    // Reset the text fields after saving
    EQUIPAMENTO_TEXT.clear();
    nomeRebocadorText.clear();
    ACAOTEXT.clear();
    STATUSTEXT.clear();
    GRUPO.clear();

    // Show a success message
    Get.snackbar(
      "Sucesso",
      "Cadastro salvo com sucesso",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

class CadastroModel {
  final String equipamento;
  final String rebocador;
  final String acao;
  final String status;
  final bool tipoManutencao;

  CadastroModel(
    this.equipamento, {
    required this.rebocador,
    required this.acao,
    required this.status,
    required this.tipoManutencao,
  });
}
