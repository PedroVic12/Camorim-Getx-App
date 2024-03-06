import 'package:camorim_getx_app/widgets/customText.dart';
import 'package:camorim_getx_app/widgets/glass_card_container.dart';
import 'package:camorim_getx_app/widgets/tabela_excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../Tabela Banco Page/controllers/tabela_controller.dart';

class ConsultaBancoMongoDB extends StatefulWidget {
  const ConsultaBancoMongoDB({super.key});

  @override
  State<ConsultaBancoMongoDB> createState() => _ConsultaBancoMongoDBState();
}

class _ConsultaBancoMongoDBState extends State<ConsultaBancoMongoDB> {
  final TableController = Get.put(TabelaController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.greenAccent,
        appBar: AppBar(title: const Text("Consultas Banco de dados")),
        body: ListView(scrollDirection: Axis.vertical, children: [
          GlassCard(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: tabelaDatabaseMongo(context),
          ),
          _buildExportExcelButton(TableController.mongoDB_array),
          const SizedBox(
            height: 5,
          ),
          const Divider(),
          showMongoDatabase(context),
        ]));
  }

  Widget tabelaDatabaseMongo(context) {
    return GetBuilder<TabelaController>(builder: (controller) {
      final colunas = [
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
        "ARQUIVO PDF",
      ];
      final linhas = controller.mongoDB_array.map((data) {
        return [
          data["BARCO"].toString(),
          data["DESC_FALHA"].toString(),
          data["EQUIPAMENTO"].toString(),
          data["MANUTENCAO"].toString(),
          data["SERV_EXECUTADO"].toString(),
          data["DATA_EXEC"].toString(),
          data["RESPONSAVEL"].toString(),
          data["OFICINA"].toString(),
          data["FINALIZADO"].toString(),
          data["DATA_CONCLUSAO"].toString(),
          data["FORA_OPERACAO"].toString(),
          data["OBS"].toString(),
          '', // Espaço reservado para a coluna de edição
        ];
      }).toList();

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
          color: Colors.blueGrey,
          child: Column(
            children: [
              TabelaGrid(
                columns: colunas,
                rows: linhas
                    .map((row) => row.map((cell) => cell ?? '').toList())
                    .toList(),
                onUpdate: (List<List<String?>> newData) {
                  setState(() {
                    tableData = newData;
                    print("Dados atualizados!");
                    print(tableData[0]);
                  });
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  final controller = TabelaGridController();

                  List<Uint8List> pdfBytesList = [];

                  for (var rowData in controller.table) {
                    var dataset =
                        await controller.salvarDadosRelatorioOSByIndex(
                            controller.table,
                            controller.table.indexOf(rowData));
                    Uint8List fileBytes = await TableController.bulbassauro
                        .gerarOsDigital(dataset);
                    pdfBytesList.add(fileBytes);
                  }

                  await TableController.showPdfCarousel(pdfBytesList);
                },
                child: const Text('Gerar Carrousel Digital'),
              ),
              // Exibir o número de colunas e linhas
              Text('Número de colunas: ${colunas.length}'),
              Text('Número de linhas: ${linhas.length}'),
            ],
          ),
        );
      }
    });
  }

  Widget _buildExportExcelButton(array) {
    return ElevatedButton(
      onPressed: () =>
          TableController.bulbassauro.gerarExcelDadosRelatorioOS(array),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.indigo),
      ),
      child: const CustomText(
        text: "Exportar Excel",
        color: Colors.white,
      ),
    );
  }

  Widget showMongoDatabase(context) {
    return Container(
      height: MediaQuery.of(context).size.height *
          0.5, // Defina a altura desejada aqui
      child: GetBuilder<TabelaController>(builder: ((controller) {
        if (controller.mongoDB_array.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          print("SetState =  ${controller.mongoDB_array.length}");

          try {
            return ListView.builder(
                itemCount: controller.mongoDB_array.length,
                itemBuilder: (context, index) {
                  final obj = controller.mongoDB_array[index];

                  return Card(
                    child: CupertinoListTile(
                      title: CustomText(text: obj["BARCO"]),
                      subtitle: Column(children: [
                        CustomText(text: obj["DESC_FALHA"]),
                        CustomText(text: obj["DESC_FALHA"]),
                        CustomText(text: obj["FINALIZADO"])
                      ]),
                    ),
                  );
                });
          } catch (e) {
            return Container(
                child: CustomText(text: "Erro ao buscar ${e.toString()}"));
          }
        }
      })),
    );
  }
}
