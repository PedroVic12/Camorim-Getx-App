import 'package:camorim_getx_app/app/controllers/Formulario/FormController.dart';
import 'package:camorim_getx_app/app/controllers/GoogleSheetsController.dart';
import 'package:camorim_getx_app/widgets/CaixaDeTexto.dart';
import 'package:camorim_getx_app/widgets/DropMenuForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../pages/CRUD Excel/controllers/excel_controller.dart';


// TODO -> Tensão, funções, atuadores, VB, TORREs

class ControleDiquePage extends StatefulWidget {
  ControleDiquePage({super.key});

  @override
  State<ControleDiquePage> createState() => _ControleDiquePageState();
}

class _ControleDiquePageState extends State<ControleDiquePage> {
  final formController = Get.put(FormController());
  final planilhaController = Get.put(GoogleSheetsController());
  final excelController = Get.put(ExcelController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle Dique'),
        backgroundColor: Colors.red,
        bottomOpacity: BorderSide.strokeAlignInside,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            CaixaDeTexto(
              controller: formController.idItem,
              labelText: "Id do Item",
            ),
            CaixaDeTexto(
              controller: formController.nomeEquipamento,
              labelText: "Nome da Peça",
            ),
            DropMenuForm(
              labelText: 'Bordo',
              options: const ['BOMBORDO', 'BORESTE', 'OUTRO'],
              textController: formController.bordo,
            ),
            CaixaDeTexto(
              controller: formController.potencia,
              labelText: "Potencia",
            ),
            CaixaDeTexto(
              controller: formController.potencia,
              labelText: "Tensão",
            ),
            DropMenuForm(
              labelText: 'Local da Aplicação',
              options: const ['TORRE 1', 'TORRE 2', 'TORRE 3', 'TORRE 4'],
              textController: formController.endereco,
            ),
            CaixaDeTexto(
              controller: formController.dataEntradaDique,
              labelText: "Data de Entrada ",
              onTap: () async {
                var date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1990),
                  lastDate: DateTime(2030),
                );
                if (date != null) {
                  formController.dataEntradaDique.text = date.toIso8601String();
                }
              },
            ),
            DropMenuForm(
              labelText: 'Nome da Embarcação',
              options: const ['DIQUE'],
              textController: formController.nomeNavio,
            ),
            DropMenuForm(
              labelText: 'Apto para uso?',
              options: const ['SIM', 'NÃO'],
              textController: formController.isOkayParaUso,
            ),
            DropMenuForm(
              labelText: 'Classificação',
              options: const ['MCP', 'MCA', 'PROPULSÃO', 'N/A'],
              textController: formController.classificacao,
            ),
            DropMenuForm(
              labelText: 'Situação da Peça',
              options: const ['APTO PARA USO', 'REPARAR'],
              textController: formController.situacaoEquipamento,
            ),
            CaixaDeTexto(
              controller: formController.assetsEquipamento,
              labelText: "Foto da Peça ",
            ),
            CaixaDeTexto(
              controller: formController.observacoesDique,
              labelText: "Observações ",
              height: 100,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
              ),
              onPressed: () {
                //save dados csv na pasta repository
                formController.createExcel(controllers: [
                  formController.idItem,
                  formController.nomeEquipamento,
                  formController.bordo,
                  formController.potencia,
                  formController.opcoesDique,
                  formController.endereco,
                  formController.dataEntradaDique,
                  formController.nomeNavio,
                  formController.isOkayParaUso,
                  formController.classificacao,
                  formController.situacaoEquipamento,
                  formController.assetsEquipamento,
                  formController.observacoesDique
                ], labels: [
                  "Id do Item",
                  "Nome do Equipamento",
                  "Bordo",
                  "Potencia",
                  "OPÇÕES",
                  "Endereço de Aplicação",
                  "Data de Entrada",
                  "Embarcação",
                  "Apto para Uso",
                  "Classificação",
                  "Situação da Peça",
                  "Foto da Peça",
                  "Observações",
                ]);

                Get.snackbar('Sucesso', 'Dados salvos com sucesso!',
                    backgroundColor: Colors.green, colorText: Colors.white);

                // Resetar o formulário
                formController.idItem.clear();
                formController.nomeEquipamento.clear();
                formController.bordo.clear();
                formController.potencia.clear();
                formController.opcoesDique.clear();
                formController.endereco.clear();
                formController.dataEntradaDique.clear();
                formController.nomeNavio.clear();
                formController.isOkayParaUso.clear();
                formController.classificacao.clear();
                formController.situacaoEquipamento.clear();
                formController.assetsEquipamento.clear();
                formController.observacoesDique.clear();
              },
              child: Obx(() {
                if (planilhaController.isLoading.value) {
                  return const CircularProgressIndicator();
                }
                return const Text("Adicionar dados");
              }),
            )
          ],
        ),
      ),
    );
  }
}
