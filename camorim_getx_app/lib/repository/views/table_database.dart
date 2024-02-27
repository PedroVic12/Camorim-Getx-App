import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/cadastro_controllers.dart';
import 'package:camorim_getx_app/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class DataModel {
  final String nOs;
  final String barco;
  final DateTime dataInicio;
  final String descFalha;
  final String equipamento;
  final String manutencao;
  final String servExecutado;
  final DateTime dataExec;
  final String responsavel;
  final String oficina;
  final String finalizado;
  final DateTime dataConclusao;
  final String foraOperacao;
  final String obs;

  DataModel({
    required this.nOs,
    required this.barco,
    required this.dataInicio,
    required this.descFalha,
    required this.equipamento,
    required this.manutencao,
    required this.servExecutado,
    required this.dataExec,
    required this.responsavel,
    required this.oficina,
    required this.finalizado,
    required this.dataConclusao,
    required this.foraOperacao,
    required this.obs,
  });
}

class DataController extends GetxController {
  RxList<DataModel> data = <DataModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    final CadastroController relatorio_controller =
        Get.put(CadastroController());

    try {
      // Carrega o arquivo JSON
      //String jsonString = await rootBundle.loadString('assets/data.json');
      //List<dynamic> jsonList = jsonDecode(jsonString);
      var jsonList = relatorio_controller.relatorio_array;
      print(jsonList[0]);

      // Converte a lista de objetos JSON em uma lista de objetos DataModel
      data.assignAll(jsonList.map((item) {
        return DataModel(
          nOs: item.numeroOS,
          barco: item.rebocador,
          dataInicio: DateTime.parse(item.dataInicial),
          descFalha: item.descFalha,
          equipamento: item.equipamento,
          manutencao: item.tipoManutencao,
          servExecutado: item.servicoExecutado,
          dataExec: DateTime.parse(item.dataInicial),
          responsavel: item.funcionario.toString(),
          oficina: item.oficina,
          finalizado: item.status_finalizado.toString(),
          dataConclusao: DateTime.parse(item.dataFinal!),
          foraOperacao: item.foraOperacao.toString(),
          obs: item.obs,
        );
      }));
      print(data[0].barco);
    } catch (e) {
      print('Erro ao carregar os dados: $e');
    }
  }
}

class DataView extends StatelessWidget {
  final DataController controller = Get.put(DataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Data Table')),
      body: Obx(() {
        if (controller.data.isEmpty) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            itemCount: controller.data.length,
            itemBuilder: (context, index) {
              final item = controller.data[index];
              return Card(
                child: ListTile(
                  title: Text(item.barco),
                  subtitle: Text(item.descFalha),
                  trailing: TextButton(
                      onPressed: () {}, child: CustomText(text: "Editar")),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
