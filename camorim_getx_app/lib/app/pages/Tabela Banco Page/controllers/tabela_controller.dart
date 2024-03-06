import 'dart:convert';

import 'package:camorim_getx_app/widgets/customText.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart' as backend;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../CRUD Excel/controllers/bulbassaur_excel.dart';
import '../../sistema Cadastro/cadastro_controllers.dart';

class TabelaController extends GetxController {
  final relatorioController = Get.put(CadastroController());
  final bulbassauro = Get.put(BulbassauroExcelController());
  backend.Dio dio = backend.Dio();
  final url = 'https://docker-raichu.onrender.com';
  var mongoDB_array = [].obs;

  @override
  void onInit() async {
    super.onInit();
    getAllDatabaseInfo();
    checkStatusServer();
  }

  Future<void> getAllDatabaseInfo() async {
    try {
      backend.Response response;
      response = await dio.get("${url}/database");
      if (response.statusCode == 200) {
        // Convertendo as strings JSON para objetos Dart
        var registros =
            response.data.map((jsonString) => jsonDecode(jsonString)).toList();

        // Exibindo os registros
        registros.forEach((registro) {
          //print("\nRegister = $registro");
        });
        mongoDB_array.assignAll(registros);

        update();
      } else {
        print("Erro ao buscar os dados: ${response.statusCode}");
      }
    } catch (e) {
      print("Erro ao buscar os dados: $e");
    }
  }

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
      'RESPONSAVEL': 'Rondinelli'
    }
  };
  Map<String, dynamic> salvarDadosRelatorioOS() {
    print(relatorioController.array_cadastro.length);

    if (relatorioController.array_cadastro.isEmpty) {
      return {};
    } else {
      for (var data in relatorioController.array_cadastro) {
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

    return {};
  }

  Future<void> showPdfFile(Uint8List url, Map<String, dynamic> dataset) async {
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

  String getDateTime(Map<String, dynamic> dataset) {
    var formattedDate = dataset["dados"]?["DATA INICIO"]?.replaceAll("/", "_");
    var fileName =
        "${dataset["dados"]?["EMBARCAÇÃO"]} - ${dataset["dados"]?["EQUIPAMENTO"]} - ${formattedDate}.pdf";
    return fileName;
  }

  Future<void> showPdfCarousel(List<Uint8List> pdfBytesList) async {
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

  void checkStatusServer() async {
    var response = await dio.get(url);
    if (response.statusCode == 200) {
      print('Server is running');
      print(response.data);
    } else {
      print('Server is not running');
    }
  }
}
