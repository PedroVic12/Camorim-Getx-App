// ignore_for_file: non_constant_identifier_names

import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/cadastro_controllers.dart';
import 'package:camorim_getx_app/widgets/button_async.dart';
import 'package:camorim_getx_app/widgets/customText.dart';
import 'package:camorim_getx_app/widgets/tabela_excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../app/pages/CRUD Excel/controllers/bulbassaur_excel.dart';

import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

import '../app/pages/sistema Cadastro/views/mobile/views/dados_mongo_dart_mobile.dart';

class DataRowModel {
  String embarcacao;
  String descricaoFalha;
  String equipamento;
  bool isEditing; // Track editing state for each row

  DataRowModel({
    required this.embarcacao,
    required this.descricaoFalha,
    required this.equipamento,
    this.isEditing = false,
  });
}

class EditableTable extends StatefulWidget {
  @override
  _EditableTableState createState() => _EditableTableState();
}

class _EditableTableState extends State<EditableTable> {
  late List<DataRowModel> _data;
  bool _isEditing = false;
  final bulbassauro = Get.put(BulbassauroExcelController());

  final CadastroController relatorio_controller = Get.put(CadastroController());
  bool isLoading = false;

  var dadosCadastrados = {};

  var dataset = {
    "dados": {
      "EMBARCAÇÃO": "BALSA CAMORIM",
      "DATA INICIO": "19/02/2024",
      'DESCRIÇÃO DA FALHA':
          'MCA BB com falha na partida. Mal contato nos terminais da ignição no painel.',
      'EQUIPAMENTO': 'MCA BB',
      'MANUTENÇÃO': 'CORRETIVA',
      'SERVIÇO EXECUTADO':
          'Foi feito reaperto dos terminais e contatos no arranque e painel de partida',
      'FUNCIONARIOS': 'Franklin/Gustavo/Rodrigo',
      'OFICINA': 'ELÉTRICA',
      'FINALIZADO': 'SIM',
      'DATA FINAL': '08/05/2024',
      'FORA DE OPERAÇÃO': 'SIM',
      'OBS':
          'Foi aplicado 40m de cabo pp 4x16nn² novo e 30m cabo pp 7x1,00 para comando tambem novo.',
      'EQUIPE': 'ELÉTRICA',
      'LOCAL': 'NITEROI',
      'RESPONSAVEL': 'PEDRO VERAS'
    }
  };
  @override
  void initState() {
    super.initState();
    _data = [
      DataRowModel(
        embarcacao: "Balsa 1",
        descricaoFalha: "Falha 1",
        equipamento: "Equipamento 1",
      ),
      DataRowModel(
        embarcacao: "Balsa 2",
        descricaoFalha: "Falha 2",
        equipamento: "Equipamento 2",
      ),
      DataRowModel(
        embarcacao: "Balsa 2",
        descricaoFalha: "Falha 2",
        equipamento: "Equipamento 2",
      ),
      DataRowModel(
        embarcacao: "Balsa 2",
        descricaoFalha: "Falha 2",
        equipamento: "Equipamento 2",
      ),
      DataRowModel(
        embarcacao: "Balsa 2",
        descricaoFalha: "Falha 2",
        equipamento: "Equipamento 2",
      ),
    ];
    var statusServer =
        bulbassauro.dio.get("https://rayquaza-citta-server.onrender.com/");
    print(statusServer);
  }

  @override
  Widget build(BuildContext context) {
    print(_data.length);
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        CustomText(
          text: 'Editable Table - Clone Excel + MongoDB + Onedrive',
          size: 36,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: buildColumsAndRows(),
        ),
        Divider(),
        botoes(),
        ElevatedButton(
            onPressed: () => Get.to(BuildCustomTable), child: Text("Tabela")),
        simpleTable()
      ],
    );
  }

  void convertJsonToExcel() {
    final workbook = xlsio.Workbook();
    final sheet = workbook.worksheets[0];
    sheet.getRangeByName('A1').setText('Embarcação');
    sheet.getRangeByName('B1').setText('Descrição da Falha');
    sheet.getRangeByName('C1').setText('Equipamento');
    for (var i = 0; i < _data.length; i++) {
      sheet.getRangeByName('A${i + 2}').setText(_data[i].embarcacao);
      sheet.getRangeByName('B${i + 2}').setText(_data[i].descricaoFalha);
      sheet.getRangeByName('C${i + 2}').setText(_data[i].equipamento);
    }
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    //return bytes;
  }

  Widget getDatabaseCloudExcel() {
    final controller = Get.put(CadastroController());
    return Obx(() {
      return ListView.builder(
          //shrinkWrap: true, // Garante que o ListView não expanda infinitamente
          itemCount: controller.relatorio_array.length,
          itemBuilder: (context, index) {
            final object = controller.relatorio_array[index];
            //String formattedDate =                DateFormat('dd/MM/yyyy').format(object.dataInicial as DateTime);
            if (controller.relatorio_array.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.relatorio_array.length == 0) {
              return const Center(
                child: Text("Nenhum dado encontrado"),
              );
            } else {
              return Card(
                color: Colors.lightBlue,
                child: ListTile(
                  title: Row(
                    children: [
                      Text(object.rebocador),
                      Text(object.dataInicial),
                    ],
                  ),
                  subtitle: Column(
                    children: [
                      Text(object.equipamento),
                      Text(object.status_finalizado.toString())
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {},
                  ),
                ),
              );
            }
          });
    });
  }

  Future showPdfFile(url, dataset) async {
    return Get.dialog(
      Dialog(
        child: Container(
          height: 900,
          width: 600,
          child: Column(
            children: [
              CustomText(text: "Relatorio OS  Digtal gerado "),
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

  getDateTime(dataset) {
    var formattedDate = dataset["dados"]?["DATA INICIO"]?.replaceAll("/", "_");

    var fileName =
        "${dataset["dados"]?["EMBARCAÇÃO"]} - ${dataset["dados"]?["EQUIPAMENTO"]} - ${formattedDate}.pdf";

    return fileName;
  }

  Widget botoes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ButtonAsyncState(
          onPressed: () async {
            setState(() {
              // Add a new row with default values
              _data.add(DataRowModel(
                embarcacao: "",
                descricaoFalha: "",
                equipamento: "",
                isEditing: true, // Start in edit mode for the new row
              ));
            });
          },
          iconData: Icons.add,
          text: 'Adicionar',
          isLoading: isLoading,
        ),
        ElevatedButton(
          onPressed: () async {
            // Update the MongoDB Realm database
            // Implement the logic here to update the database using the GetX controller or service
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.indigo),
          ),
          child: const CustomText(
            text: "Save and send files",
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget gerarRelatorioDigital() {
    salvarDadosRelatorioOS() {
      print(relatorio_controller.array_cadastro.length);

      if (relatorio_controller.array_cadastro.isEmpty) {
        return Text("Nenhum dado cadastrado");
      } else {
        for (var data in relatorio_controller.array_cadastro) {
          // Criar um novo mapa de dados para este item
          var dadosCadastrados = {
            "dados": {
              "EMBARCAÇÃO": data.rebocador,
              "DATA INICIO": data.dataInicial,
              "DESCRIÇÃO DA FALHA": data.descFalha,
              "EQUIPAMENTO": data.equipamento,
              "MANUTENÇÃO": data.tipoManutencao,
              "SERVIÇO EXECUTADO": data.servicoExecutado,
              "FUNCIONARIOS": data.funcionario.toString(),
              "OFICINA": data.oficina,
              "FINALIZADO": data.status_finalizado.toString(),
              "DATA FINAL": data.dataFinal.toString(),
              "FORA DE OPERAÇÃO": data.status_finalizado.toString(),
              "OBS": data.obs,
              "EQUIPE": "ELÉTRICA",
              "LOCAL": "NITEROI",
              "RESPONSAVEL": "PEDRO VERAS"
            }
          };

          return dadosCadastrados;
        }
      }
    }

    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.green),
      ),
      onPressed: () async {
        var newDataset = salvarDadosRelatorioOS();
        print(newDataset);
        var fileBytes = await bulbassauro.gerarOsDigital(newDataset);
        showPdfFile(fileBytes, newDataset);
      },
      child: const Text('Gerar Relatório Digital'),
    );
  }

  Widget simpleTable() {
    final CadastroController relatorio_controller =
        Get.put(CadastroController());

    return TabelaGrid(
      onUpdate: (List<List<String?>> newData) {
        setState(() {
          _data = newData
              .map((row) => DataRowModel(
                    embarcacao: row[0] ?? "",
                    descricaoFalha: row[1] ?? "",
                    equipamento: row[2] ?? "",
                  ))
              .toList();
        });
      },
      columns: [
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
        "ações"
      ],
      rows: relatorio_controller.array_cadastro.map((data) {
        return [
          data.rebocador,
          data.descFalha,
          data.equipamento,
          data.tipoManutencao,
          data.servicoExecutado,
          data.dataFinal.toString(),
          data.funcionario.toString(),
          data.oficina,
          data.status_finalizado.toString(),
          data.dataFinal.toString(),
          data.status_finalizado.toString(),
          data.obs,
        ];
      }).toList(),
    );
  }

  Widget buildColumsAndRows() {
    return DataTable(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.black),
      ),
      columns: [
        DataColumn(
          label: Container(
            padding: EdgeInsets.all(8),
            color: Colors.blue,
            child: Text('Embarcação', style: TextStyle(color: Colors.white)),
          ),
        ),
        DataColumn(
          label: Container(
            padding: EdgeInsets.all(8),
            color: Colors.blue,
            child:
                Text('DATA DE ABERTURA', style: TextStyle(color: Colors.white)),
          ),
        ),
        DataColumn(
          label: Container(
            padding: EdgeInsets.all(8),
            color: Colors.blue,
            child: Text('Descrição da Falha',
                style: TextStyle(color: Colors.white)),
          ),
        ),
        DataColumn(
          label: Container(
            padding: EdgeInsets.all(8),
            color: Colors.blue,
            child: Text('Equipamento', style: TextStyle(color: Colors.white)),
          ),
        ),
        DataColumn(
          label: Container(
            padding: EdgeInsets.all(8),
            color: Colors.blue,
            child: Text('MANUTENÇÃO', style: TextStyle(color: Colors.white)),
          ),
        ),
        DataColumn(
          label: Container(
            padding: EdgeInsets.all(8),
            color: Colors.blue,
            child: Text('SERVIÇO EXECUTAVEL',
                style: TextStyle(color: Colors.white)),
          ),
        ),
        DataColumn(
          label: Container(
            padding: EdgeInsets.all(8),
            color: Colors.blue,
            child: Text('RESPONSAVEL', style: TextStyle(color: Colors.white)),
          ),
        ),
        DataColumn(
          label: Container(
            padding: EdgeInsets.all(8),
            color: Colors.blue,
            child: Text('OFICINA', style: TextStyle(color: Colors.white)),
          ),
        ),
        DataColumn(
          label: Container(
            padding: EdgeInsets.all(8),
            color: Colors.blue,
            child: Text('FINALIZADO', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
      rows: _data
          .map(
            (dataRow) => DataRow(
              cells: [
                DataCell(
                  TextFormField(
                    readOnly: !dataRow.isEditing, // Toggle read-only mode
                    initialValue: dataRow.embarcacao,
                    onChanged: (value) {
                      dataRow.embarcacao = value;
                    },
                  ),
                ),
                DataCell(
                  TextFormField(
                    readOnly: !dataRow.isEditing, // Toggle read-only mode
                    initialValue: dataRow.embarcacao,
                    onChanged: (value) {
                      dataRow.embarcacao = value;
                    },
                  ),
                ),
                DataCell(
                  TextFormField(
                    readOnly: !dataRow.isEditing, // Toggle read-only mode
                    initialValue: dataRow.embarcacao,
                    onChanged: (value) {
                      dataRow.embarcacao = value;
                    },
                  ),
                ),
                DataCell(
                  TextFormField(
                    readOnly: !dataRow.isEditing, // Toggle read-only mode
                    initialValue: dataRow.embarcacao,
                    onChanged: (value) {
                      dataRow.embarcacao = value;
                    },
                  ),
                ),
                DataCell(
                  TextFormField(
                    readOnly: !dataRow.isEditing, // Toggle read-only mode
                    initialValue: dataRow.embarcacao,
                    onChanged: (value) {
                      dataRow.embarcacao = value;
                    },
                  ),
                ),
                DataCell(
                  TextFormField(
                    readOnly: !dataRow.isEditing, // Toggle read-only mode
                    initialValue: dataRow.embarcacao,
                    onChanged: (value) {
                      dataRow.embarcacao = value;
                    },
                  ),
                ),
                DataCell(
                  TextFormField(
                    readOnly: !dataRow.isEditing,
                    initialValue: dataRow.descricaoFalha,
                    onChanged: (value) {
                      dataRow.descricaoFalha = value;
                    },
                  ),
                ),
                DataCell(
                  TextFormField(
                    readOnly: !dataRow.isEditing,
                    initialValue: dataRow.equipamento,
                    onChanged: (value) {
                      dataRow.equipamento = value;
                    },
                  ),
                ),
                DataCell(
                  IconButton(
                    onPressed: () {
                      setState(() {
                        dataRow.isEditing =
                            !dataRow.isEditing; // Toggle edit mode
                      });
                    },
                    icon: Icon(dataRow.isEditing ? Icons.save : Icons.edit),
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}
