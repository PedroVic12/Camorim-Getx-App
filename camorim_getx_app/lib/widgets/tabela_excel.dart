import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:camorim_getx_app/app/pages/CRUD%20Excel/controllers/bulbassaur_excel.dart';
import 'package:camorim_getx_app/app/pages/Tabela%20Banco%20Page/controllers/tabela_controller.dart';
import 'package:camorim_getx_app/widgets/customText.dart';

class TabelaGridController extends GetxController {
  RxList table = [].obs;
  final tableController = Get.put(TabelaController());

  void updateTableData(List<List<String?>> newData) {
    table.value = newData;
    update();
  }

  salvarDadosRelatorioOSByIndex(tableData, int index) {
    var data = tableData[index];

    var dadosCadastrados = {
      "dados": {
        "EMBARCAÇÃO": data[1],
        "DESCRIÇÃO DA FALHA": data[2],
        "EQUIPAMENTO": data[3],
        "MANUTENÇÃO": data[4],
        "SERVIÇO EXECUTADO": data[5],
        "DATA INICIO": data[6],
        "FUNCIONARIOS": data[7],
        "OFICINA": data[8],
        "FINALIZADO": data[9],
        "DATA FINAL": data[10],
        "FORA DE OPERAÇÃO": data[11],
        "OBS": data[12],
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
  final Function(List<List<String?>>) onUpdate;

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

  late List<List<String?>> tableData;

  @override
  void initState() {
    super.initState();
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

                if (cellIndex == 0) {
                  // Se for a primeira coluna, adicione o botão IconButton
                  return DataCell(
                    IconButton(
                      onPressed: () {
                        // Obter o ID dos dados da linha
                        String? barco = tableData[index][1];
                        print(barco);

                        //deleteDataFromMongoDB(id);
                      },
                      icon: Icon(Icons.delete),
                    ),
                  );
                } else {
                  return DataCell(
                    onLongPress: () {
                      setState(() {
                        isEditing = true;
                        editingRowIndex = index;
                        editingCellIndex = cellIndex;
                        _showIcon = true;
                      });
                    },
                    // Restante das células, conforme antes
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isEditing = false;
                          editingRowIndex = -1;
                          editingCellIndex = -1;
                          _showIcon = false;
                        });
                      },
                      child: isEditing &&
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
                                    var dataset = controller
                                        .salvarDadosRelatorioOSByIndex(
                                            tableData, index);

                                    //dataset = json.encode(dataset);

                                    print(
                                      "\nDataset selecionado = $dataset",
                                    );
                                    Uint8List fileBytes = await bulbassauro
                                        .gerarOsDigital(dataset);
                                    await controller.tableController
                                        .showPdfFile(fileBytes, dataset);
                                  },
                                  icon: Icon(Icons.file_download),
                                )
                              : Text(
                                  cellValue ?? '',
                                  overflow: TextOverflow.ellipsis,
                                ),
                    ),
                  );
                }
              }).toList(),
            );
          },
        ).toList(),
      ),
    );
  }
}
