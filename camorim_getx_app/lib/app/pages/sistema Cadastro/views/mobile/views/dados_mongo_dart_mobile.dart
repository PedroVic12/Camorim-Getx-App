import 'package:camorim_getx_app/app/pages/Tabela%20Banco%20Page/controllers/tabela_controller.dart';
import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/cadastro_controllers.dart';
import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/views/mobile/views/DatabasePage.dart';
import 'package:camorim_getx_app/widgets/customText.dart';
import 'package:camorim_getx_app/widgets/glass_card_container.dart';
import 'package:camorim_getx_app/widgets/submit_button.dart';
import 'package:camorim_getx_app/widgets/tabela_excel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../CRUD Excel/controllers/bulbassaur_excel.dart';

class DatabaseMongoDBTableScreen extends StatelessWidget {
  final TableController = Get.put(TabelaController());

  DatabaseMongoDBTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TableController.getAllDatabaseInfo();
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      appBar: AppBar(
        title: const Text('Mongo DB - CRUD - Bulbassauro'),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          const CustomText(text: "Dados Cadastrados"),
          const GlassCard(
            child: BuildCustomTable(),
          ),
          buildButtons(TableController.dataset),
          const Center(child: CustomText(text: "Banco de Dados MONGO")),
          //TabelaDatabaseMongo(),
          Container(height: 500, child: showMongoDatabase())
        ],
      ),
    );
  }

  Widget TabelaDatabaseMongo() {
    return GetBuilder<TabelaController>(builder: (controller) {
      final columns = [
        "EMBARCAÇÃO",
        "DESCRIÇÃO DA FALHA",
        "EQUIPAMENTO",
        "MANUTENÇÃO",
        "SERVIÇO EXECUTADO",
        "DATA DE ABERTURA",
        "RESPONSAVEL EXECUÇÃO",
        "OFICINA",
        "FINALIZADO",
        "DATA DE CONCLUSÃO",
        "FORA DE OPERAÇÃO",
        "OBSERVAÇÃO",
        "AÇÕES",
      ];
      final rows = controller.mongoDB_array.map((data) {
        return [
          data.rebocador ?? "Sem dados",
          data.descFalha ?? "Sem dados",
          data.equipamento ?? "Sem dados",
          data.tipoManutencao ?? "Sem dados",
          data.servicoExecutado ?? "Sem dados",
          data.dataFinal.toString() ?? "Sem dados",
          data.funcionario.toString() ?? "Sem dados",
          data.oficina ?? "Sem dados",
          data.status_finalizado.toString() ?? "Sem dados",
          data.dataFinal.toString() ?? "Sem dados",
          data.status_finalizado.toString() ?? "Sem dados",
          data.obs ?? "Sem dados",
          '', // Espaço reservado para a coluna de edição
        ];
      }).toList();

      print(rows);

      List tableData = [];

      if (controller.mongoDB_array.isEmpty) {
        return const Center(
          child: Text(
            'Nenhum dado disponível. :(',
            style: TextStyle(color: Colors.red),
          ),
        );
      } else {
        return Container(
          color: const Color.fromARGB(255, 148, 137, 137),
          child: Column(
            children: [
              showMongoDatabase(),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Gerar Carrousel Digital'),
              ),
              // Exibir o número de colunas e linhas
              Text('Número de colunas: ${columns.length}'),
              Text('Número de linhas: ${rows.length}'),
            ],
          ),
        );
      }
    });
  }

  Widget showMongoDatabase() {
    return GetBuilder<TabelaController>(builder: ((controller) {
      if (controller.mongoDB_array.isEmpty) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        print("SetState =  ${controller.mongoDB_array.length}");

        return ListView.builder(itemBuilder: (context, index) {
          final obj = controller.mongoDB_array[index];
          print(controller.mongoDB_array);
          return Card(
            child: CupertinoListTile(
              title: CustomText(text: "obj.BARCO"),
              subtitle: Column(children: [
                //CustomText(text: obj.DESC_FALHA),
                //CustomText(text: obj.OFICINA),
                //CustomText(text: obj.FINALIZADO)
              ]),
            ),
          );
        });
      }
    }));
  }

  Widget buildButtons(dataset) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () async {},
          child: const Text("Salvar no Banco de dados"),
        ),
        _buildExportExcelButton(),
        _buildSendFilesButton(),
      ],
    );
  }

  Widget _buildExportExcelButton() {
    return ElevatedButton(
      onPressed: () => TableController.bulbassauro.salvarDadosRelatorioOS(),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.indigo),
      ),
      child: const CustomText(
        text: "Exportar Excel",
        color: Colors.white,
      ),
    );
  }

  Widget _buildSendFilesButton() {
    return ElevatedButton(
      onPressed: () async {
        List<int> fileBytesExcel =
            await TableController.bulbassauro.salvarDadosRelatorioOS();
        var fileBytes = await TableController.bulbassauro
            .gerarOsDigital(TableController.dataset);
        await TableController.bulbassauro.sendEmailFiles(
            fileBytes, fileBytesExcel, 'Output.pdf', 'dados_cadastrados.xlsx');
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.indigo),
      ),
      child: const CustomText(
        text: "Save and send files",
        color: Colors.white,
      ),
    );
  }

  Widget gerarRelatorioDigital() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.green),
      ),
      onPressed: () async {
        var newDataset = TableController.salvarDadosRelatorioOS();
        Uint8List fileBytes =
            await TableController.bulbassauro.gerarOsDigital(newDataset);
        await TableController.showPdfFile(fileBytes, newDataset);
      },
      child: const Text('Gerar um Relatório Digital'),
    );
  }
}
