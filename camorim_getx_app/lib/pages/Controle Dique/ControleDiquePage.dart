import 'package:camorim_getx_app/controllers/Formulario/FormController.dart';
import 'package:camorim_getx_app/controllers/GoogleSheetsController.dart';
import 'package:camorim_getx_app/widgets/CaixaDeTexto.dart';
import 'package:camorim_getx_app/widgets/DropMenuForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// TODO -> Tensão, funções, atuadores, VB, TORREs

class ControleDiquePage extends StatefulWidget {
  ControleDiquePage({super.key});

  @override
  State<ControleDiquePage> createState() => _ControleDiquePageState();
}

class _ControleDiquePageState extends State<ControleDiquePage> {
  final formController = Get.put(FormController());
  final planilhaController = Get.put(GoogleSheetsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Controle Dique'),
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
            CaixaDeTexto(
              controller: formController.bordo,
              labelText: "Bordo",
            ),
            CaixaDeTexto(
              controller: formController.potencia,
              labelText: "Potencia",
            ),
            DropMenuForm(),
            CaixaDeTexto(
              controller: formController.endereco,
              labelText: "Endereço de Aplicação ",
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
                  formController.dataEntradaDique.value =
                      date as TextEditingValue;
                }
              },
            ),
            CaixaDeTexto(
              controller: formController.nomeNavio,
              labelText: "Embarcação ",
            ),
            CaixaDeTexto(
              controller: formController.isOkayParaUso,
              labelText: "Apto para Uso ",
            ),
            CaixaDeTexto(
              controller: formController.classificacao,
              labelText: "Classificação ",
            ),
            CaixaDeTexto(
              controller: formController.situacaoEquipamento,
              labelText: "Situação da Peça ",
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
                //Get.find<GoogleSheetsController>().addDataToSheet(dataList);
              },
              child: Obx(() {
                if (planilhaController.isLoading.value) {
                  return CircularProgressIndicator();
                }
                return Text("Adicionar dados");
              }),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add),
        onPressed: () {
          //save dados csv na pasta repository
          formController.salvarDadosCsv();
        },
      ),
    );
  }
}
