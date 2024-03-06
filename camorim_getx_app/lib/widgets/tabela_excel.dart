import 'dart:typed_data';

import 'package:camorim_getx_app/app/pages/CRUD%20Excel/controllers/bulbassaur_excel.dart';
import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/cadastro_controllers.dart';
import 'package:camorim_getx_app/repository/MongoDBServices.dart';
import 'package:camorim_getx_app/widgets/customText.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TabelaGridController extends GetxController {
  RxList table = [].obs;

  void updateTableData(List<List<String?>> newData) {
    table.value = newData;
    update();
  }

  salvarDadosRelatorioOSByIndex(tableData, int index) {
    var data = tableData[index];

    var dadosCadastrados = {
      "dados": {
        "EMBARCAÇÃO": data[0],
        "DATA INICIO": data[5],
        "DESCRIÇÃO DA FALHA": data[1],
        "EQUIPAMENTO": data[2],
        "MANUTENÇÃO": data[3],
        "SERVIÇO EXECUTADO": data[4],
        "FUNCIONARIOS": data[6],
        "OFICINA": data[7],
        "FINALIZADO": data[8],
        "DATA FINAL": data[9],
        "FORA DE OPERAÇÃO": data[10],
        "OBS": data[11],
        "EQUIPE": "ELÉTRICA",
        "LOCAL": "NITEROI",
        "RESPONSAVEL": "RONDINELLI"
      }
    };

    return dadosCadastrados;
  }
}

class TabelaGrid extends StatefulWidget {
  final List<String> columns;
  final List<List<String?>> rows;
  final Function(List<List<String?>>)
      onUpdate; // Função para atualizar os dados

  const TabelaGrid({
    Key? key,
    required this.columns,
    required this.rows,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<TabelaGrid> createState() => _TabelaGridState();
}

class _TabelaGridState extends State<TabelaGrid> {
  final Dio dio = Dio();
  bool isEditing = false;
  int editingRowIndex = -1;
  int editingCellIndex = -1;
  bool _showIcon = false;

  final bulbassauro = Get.put(BulbassauroExcelController());
  final controller = Get.put(TabelaGridController());
  final banco = DataBaseMongoDB(
      "mongodb+srv://pedrovictorveras:admin@cluster.s1yzg4o.mongodb.net/?retryWrites=true&w=majority&appName=Cluster");

  late List<List<String?>> tableData;

  String getDateTime(Map<String, dynamic> dataset) {
    var formattedDate = dataset["dados"]?["DATA INICIO"]?.replaceAll("/", "_");
    var fileName =
        "${dataset["dados"]?["EMBARCAÇÃO"]} - ${dataset["dados"]?["EQUIPAMENTO"]} - ${formattedDate}.pdf";
    return fileName;
  }

  Future<void> _showPdfFile(Uint8List url, Map<String, dynamic> dataset) async {
    await Get.dialog(
      Dialog(
        child: Container(
          height: 900,
          width: 600,
          child: Column(
            children: [
              CustomText(text: "Relatorio OS Digital gerado "),
              Expanded(
                child: SfPdfViewer.memory(
                  url,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text('Fechar'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      var data = getDateTime(dataset);
                      await bulbassauro.enviarEmail(url, data);
                      bulbassauro.showMessage("Arquivo: $data, Email enviado");
                      Get.back();
                    },
                    child: Text('Enviar Email'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void checkStatusServer() async {
    var response = await dio.get('https://docker-raichu.onrender.com/');
    if (response.statusCode == 200) {
      print('Server is running');
      print(response.data);
    } else {
      print('Server is not running');
    }
  }

  void checkDataBateStatus() async {
    await banco.connect();
    var allDataSets =
        await banco.recuperarTodosDocumentos(banco.get_collection);
    print("\n\n\nMONGO DB = $allDataSets");
    for (var element in allDataSets) {
      print(element);
    }
  }

  generatePdfCarousel() async {
    List<Uint8List> pdfBytesList = [];

    for (var rowData in tableData) {
      var dataset = controller.salvarDadosRelatorioOSByIndex(
          tableData, tableData.indexOf(rowData));
      Uint8List fileBytes = await bulbassauro.gerarOsDigital(dataset);
      pdfBytesList.add(fileBytes);
    }

    return pdfBytesList;

    //await _showPdfCarousel(pdfBytesList);
  }

  @override
  void initState() {
    super.initState();
    checkStatusServer();
    checkDataBateStatus();
    controller.updateTableData(widget.rows);

    tableData = widget.rows;
  }

  void _updateTableData() {
    widget.onUpdate(tableData);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        sortColumnIndex: 0,
        sortAscending: true,
        border: TableBorder.all(),
        columns: widget.columns
            .map(
              (column) => DataColumn(
                label: Container(
                  color: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(column),
                  ),
                ),
              ),
            )
            .toList(),
        rows: widget.rows.asMap().entries.map(
          (entry) {
            final index = entry.key;
            final row = entry.value;

            if (row.length != widget.columns.length) {
              final filledRow = List<String?>.filled(widget.columns.length, '');
              for (int i = 0; i < row.length; i++) {
                filledRow[i] = row[i] ?? '';
              }
              widget.rows[index] = filledRow;
            }

            return DataRow(
              cells: row.asMap().entries.map((entry) {
                final cellIndex = entry.key;
                final cellValue = entry.value;

                return DataCell(
                  // Verifica se está em modo de edição e se é a célula a ser editada
                  showEditIcon: _showIcon,
                  onLongPress: () {
                    setState(() {
                      isEditing = true;
                      editingRowIndex = index;
                      editingCellIndex = cellIndex;
                      _showIcon = true;
                    });
                  },
                  isEditing &&
                          editingRowIndex == index &&
                          editingCellIndex == cellIndex
                      ? TextFormField(
                          initialValue: cellValue ?? '',
                          onChanged: (value) {
                            setState(() {
                              tableData[index][cellIndex] = value;
                              print("\nDados sendo atualizados");
                              print(tableData);
                            });
                          },
                          autofocus: true,
                          textAlign: TextAlign.center,
                          readOnly: !isEditing, // Permitir edição
                        )
                      : cellIndex == widget.columns.length - 1
                          ? IconButton(
                              onPressed: () async {
                                var dataset =
                                    controller.salvarDadosRelatorioOSByIndex(
                                        tableData, index);

                                Uint8List fileBytes =
                                    await bulbassauro.gerarOsDigital(dataset);

                                await _showPdfFile(fileBytes, dataset);
                              },
                              icon: Icon(Icons.file_download),
                            )
                          : Text(
                              cellValue ?? '',
                              overflow: TextOverflow.ellipsis,
                            ),
                );
              }).toList(),
            );
          },
        ).toList(),
      ),
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
      return Center(
        child: Text(
          'Nenhum dado disponível.',
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
