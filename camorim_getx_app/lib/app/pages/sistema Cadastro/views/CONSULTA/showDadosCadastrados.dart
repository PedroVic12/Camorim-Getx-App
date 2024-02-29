import 'dart:typed_data';

import 'package:camorim_getx_app/app/models/relatorio_model.dart';
import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/cadastro_controllers.dart';
import 'package:camorim_getx_app/widgets/TableCustom.dart';
import 'package:camorim_getx_app/widgets/button_async.dart';
import 'package:camorim_getx_app/widgets/customText.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../CRUD Excel/controllers/bulbassaur_excel.dart';

class ShowTableDadosCadastrados extends StatefulWidget {
  @override
  State<ShowTableDadosCadastrados> createState() =>
      _ShowTableDadosCadastradosState();
}

class _ShowTableDadosCadastradosState extends State<ShowTableDadosCadastrados> {
  final bulbassauro = Get.put(BulbassauroExcelController());
  final relatorioController = Get.put(CadastroController());

  Uint8List? pdfBytes;
  bool isLoading = false;
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
  Widget build(BuildContext context) {
    return Obx(
      () => ListView(
        scrollDirection: Axis.vertical,
        children: [
          _buildTable(),
          _buildButtons(dataset),
        ],
      ),
    );
  }

  Widget _buildTable() {
    return Column(
      children: [
        CustomText(
          text: "Dados Cadastrados",
          size: 32,
          color: Colors.black,
        ),
        _buildCustomTable(),
      ],
    );
  }

  Widget _buildCustomTable() {
    return TableCustom(
      columns: const [
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
      ],
      rows: relatorioController.array_cadastro.map((data) {
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

  Widget _buildButtons(dataset) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //_buildAddButton(dataset),
        _buildExportExcelButton(),
        _buildSendFilesButton(),
        _buildGenerateReportButton(),
      ],
    );
  }

  Widget _buildAddButton(dataset) {
    return ButtonAsyncState(
      onPressed: () async {
        setState(() {
          isLoading = true;
        });

        var fileBytes = await bulbassauro.gerarOsDigital(dataset);
        await _showPdfCarousel(fileBytes, dataset);

        setState(() {
          isLoading = false;
        });
      },
      iconData: Icons.add,
      text: 'Adicionar',
      isLoading: isLoading,
    );
  }

  Widget _buildExportExcelButton() {
    return ElevatedButton(
      onPressed: () => bulbassauro.salvarDadosRelatorioOS(),
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
      onPressed: () => _sendFilesButtonPressed(dataset),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.indigo),
      ),
      child: const CustomText(
        text: "Save and send files",
        color: Colors.white,
      ),
    );
  }

  Widget _buildGenerateReportButton() {
    return gerarRelatorioDigital();
  }

  Widget gerarRelatorioDigital() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.green),
      ),
      onPressed: _generateReportButtonPressed,
      child: const Text('Gerar Relatório Digital'),
    );
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

  Future<void> _showPdfCarousel(
      List<Uint8List> pdfBytesList, Map<String, dynamic> dataset) async {
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
                      bulbassauro
                          .showMessage("Arquivos enviados por email: $data");
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

  Future<void> _sendFilesButtonPressed(dataset) async {
    List<int> fileBytesExcel = await bulbassauro.salvarDadosRelatorioOS();
    var fileBytes = await bulbassauro.gerarOsDigital(dataset);
    await bulbassauro.sendEmailFiles(
        fileBytes, fileBytesExcel, 'Output.pdf', 'dados_cadastrados.xlsx');
  }

  Future<void> _generateReportButtonPressed() async {
    var newDataset = _salvarDadosRelatorioOS();
    var fileBytes = await bulbassauro.gerarOsDigital(newDataset);
    await _showPdfCarousel(fileBytes, newDataset);
  }

  Map<String, dynamic> _salvarDadosRelatorioOS() {
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

  String getDateTime(Map<String, dynamic> dataset) {
    var formattedDate = dataset["dados"]?["DATA INICIO"]?.replaceAll("/", "_");
    var fileName =
        "${dataset["dados"]?["EMBARCAÇÃO"]} - ${dataset["dados"]?["EQUIPAMENTO"]} - ${formattedDate}.pdf";
    return fileName;
  }
}
