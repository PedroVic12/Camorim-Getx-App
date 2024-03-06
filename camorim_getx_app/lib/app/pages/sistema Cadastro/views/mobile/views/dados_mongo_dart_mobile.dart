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

class DatabaseMongoDBTableScreen extends StatefulWidget {
  DatabaseMongoDBTableScreen({super.key});

  @override
  State<DatabaseMongoDBTableScreen> createState() =>
      _DatabaseMongoDBTableScreenState();
}

class _DatabaseMongoDBTableScreenState
    extends State<DatabaseMongoDBTableScreen> {
  final TableController = Get.put(TabelaController());

  @override
  Widget build(BuildContext context) {
    TableController.getAllDatabaseInfo();
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      appBar: AppBar(
        title: const Text('Dados Cadastrados OS - Analise e edição'),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          const GlassCard(
            child: BuildCustomTable(),
          ),
          buildButtons(TableController.dataset),
        ],
      ),
    );
  }

  Widget buildButtons(dataset) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () async {
            var dadosCadastrados =
                TableController.relatorioController.array_cadastro;

            print(dadosCadastrados);

            var response =
                await TableController.dio.post(TableController.url, data: []);

            if (response.statusCode == 200) {
              print("Cadastro");
            }
          },
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

class BuildCustomTable extends StatefulWidget {
  const BuildCustomTable({Key? key}) : super(key: key);

  @override
  State<BuildCustomTable> createState() => _BuildCustomTableState();
}

class _BuildCustomTableState extends State<BuildCustomTable> {
  @override
  Widget build(BuildContext context) {
    final relatorioController = Get.put(CadastroController());
    final controller = Get.put(TabelaGridController());
    final bulbassauro = Get.put(BulbassauroExcelController());

    if (relatorioController.array_cadastro.isEmpty) {
      return const Center(
        child: Text(
          'Sem dados Cadastrados no momento',
          style: TextStyle(color: Colors.red),
        ),
      );
    }

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
      "ARQUIVO",
    ];

    final rows = relatorioController.array_cadastro.map((data) {
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
        "Arquivo"
        // O ícone de download será adicionado automaticamente
      ];
    }).toList();
    List<List<String?>> tableData = [];

    return Column(
      children: [
        TabelaGrid(
          columns: columns,
          rows: rows
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
            List<Uint8List> pdfBytesList = [];

            for (var rowData in controller.table) {
              var dataset = controller.salvarDadosRelatorioOSByIndex(
                  controller.table, controller.table.indexOf(rowData));
              Uint8List fileBytes = await bulbassauro.gerarOsDigital(dataset);
              pdfBytesList.add(fileBytes);
            }

            await _showPdfCarousel(pdfBytesList);
          },
          child: Text('Gerar Carrossel Digital'),
        ),
        // Exibir o número de colunas e linhas
        Text('Número de colunas: ${columns.length}'),
        Text('Número de linhas: ${rows.length}'),
      ],
    );
  }

  Future<void> _generateReportButtonPressed() async {
    List<Uint8List> pdfBytesList = [];

    //await _showPdfCarousel(pdfBytesList);
    await _showPdfCarousel(pdfBytesList);
  }

  Future<void> _showPdfCarousel(List<Uint8List> pdfBytesList) async {
    await Get.dialog(
      Dialog(
        child: Container(
          height: 900,
          width: 600,
          child: Column(
            children: [
              CustomText(text: "Relatório OS Digital gerado"),
              Expanded(
                child: CarouselSlider(
                  options: CarouselOptions(
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: false,
                    reverse: false,
                    autoPlay: false,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: pdfBytesList.map((bytes) {
                    return Builder(
                      builder: (BuildContext context) {
                        return SfPdfViewer.memory(
                          bytes,
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('Fechar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
