import 'dart:io';
import 'dart:typed_data';

import 'package:camorim_getx_app/widgets/assinatura_widget.dart';
import 'package:camorim_getx_app/widgets/button_async.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/cadastro_controllers.dart';
import 'package:camorim_getx_app/widgets/TableCustom.dart';
import 'package:camorim_getx_app/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../CRUD Excel/controllers/bulbassaur_excel.dart';

class ShowTableDadosCadastrados extends StatefulWidget {
  @override
  State<ShowTableDadosCadastrados> createState() =>
      _ShowTableDadosCadastradosState();
}

class _ShowTableDadosCadastradosState extends State<ShowTableDadosCadastrados> {
  final bulbassauro = Get.put(BulbassauroExcelController());

  final CadastroController relatorio_controller = Get.put(CadastroController());

  Uint8List? pdfBytes;
  bool isLoading = false;

  var dadosCadastrados = {};

  @override
  void initState() {
    super.initState();
    var statusServer =
        bulbassauro.dio.get("https://rayquaza-citta-server.onrender.com/");
    print(statusServer);
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
      'RESPONSAVEL': 'PEDRO VICTOR Veras'
    }
  };

  @override
  Widget build(BuildContext context) {
    var filesArrayBytes = [];

    return Obx(() => ListView(
          scrollDirection: Axis.vertical,
          children: [
            // Tabela com os dados cadastrados
            CustomText(
                text: "Dados Cadastrados", size: 32, color: Colors.black),

            TableCustom(
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
                  data.obs
                ];
              }).toList(),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ButtonAsyncState(
                  onPressed: () async {
                    // Chamar uma função assíncrona aqui
                    setState(() {
                      isLoading =
                          true; // Define isLoading como true para mostrar o CircularProgressIndicator
                    });

                    //!função aqui
                    var fileBytes = await bulbassauro.gerarOsDigital(dataset);
                    showPdfFile(fileBytes, dataset);

                    setState(() {
                      isLoading =
                          false; // Define isLoading como false para voltar ao ícone original
                    });
                  },
                  iconData: Icons.add, // Ícone original
                  text: 'Adicionar',
                  isLoading: isLoading,
                ),
                ElevatedButton(
                  onPressed: () => bulbassauro.salvarDadosRelatorioOS(),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.indigo),
                  ),
                  child: const CustomText(
                    text: "Exportar Excel",
                    color: Colors.white,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    //relatorio_controller.salvar(context);
                    // Gerar os arquivos em bytes
                    var fileBytes1 = await bulbassauro.gerarOsDigital(dataset);
                    var fileBytes2 = await bulbassauro.salvarDadosRelatorioOS();

                    try {
                      // Criar uma lista de arquivos a partir dos bytes
                      List<File> files = [
                        File.fromRawPath(Uint8List.fromList(fileBytes1)),
                        File.fromRawPath(Uint8List.fromList(fileBytes2)),
                      ];

                      // Enviar os arquivos para a API
                      //await bulbassauro.uploadFiles(files);
                      await bulbassauro.sendEmailFiles(fileBytes1, fileBytes2,
                          'Output.pdf', 'dados_cadastrados.xlsx');

                      //!funcinando
                      //await bulbassauro.enviarEmail(fileBytes1, "arquivo.pdf");
                      //await bulbassauro.enviarEmail(fileBytes2, "excel.xlsx");
                    } catch (e) {
                      print("Nao enviado: $e");
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.indigo),
                  ),
                  child: const CustomText(
                    text: "Save and send files in email",
                    color: Colors.white,
                  ),
                ),
                gerarRelatorioDigital(),
              ],
            ),
          ],
        ));
  }

  Future showPdfFile(url, dataset) async {
    return Get.dialog(
      Dialog(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            CustomText(text: "Relatorio OS  Digtal gerado "),
            Container(
              height: 600,
              width: 400,
              child: Expanded(
                child: SfPdfViewer.memory(
                  url,
                ),
              ),
            ),
            AssinaturaWidget(),
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
                    var data = getFileNameByData(dataset);
                    await bulbassauro.enviarEmail(url, data);
                    bulbassauro.showMessage("Arquivo: $data, Email enviado");
                    Get.back();
                  },
                  child: Text('Enviar Email'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showPdfCarousel(List<Uint8List> pdfBytesList) async {
    print("Numero de Documetnos gerados: ${pdfBytesList.length}");
    return Get.dialog(
      Dialog(
        child: Container(
          height: 900,
          width: 600,
          child: Column(
            children: [
              CustomText(text: "Relatorio OS  Digtal gerado "),
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
                      // Implement your logic to send email for each PDF
                      bulbassauro.showMessage("Arquivos enviados por email: ");
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

  Widget gerarRelatorioDigital() {
    salvarDadosRelatorioOS() {
      if (relatorio_controller.array_cadastro.isEmpty) {
        return Text("Nenhum dado cadastrado");
      } else {
        print(relatorio_controller.array_cadastro.length);
        print("\n\nDatabase = ${relatorio_controller.array_cadastro}");
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
        textStyle: MaterialStateProperty.all(TextStyle(color: Colors.white)),
      ),
      onPressed: () async {
        List<Uint8List> arrayDataset = [];

        for (var i = 0; i < relatorio_controller.array_cadastro.length; i++) {
          var newDataset = salvarDadosRelatorioOS();

          var fileBytes = await bulbassauro.gerarOsDigital(newDataset);
          arrayDataset.add(fileBytes);
          //showPdfFile(fileBytes, newDataset);
        }
        //todo gerar um showPdfCarousel para cada OS gerada, adcioanr nados incrementar dados no mesmo documento
        showPdfCarousel(arrayDataset);
      },
      child: const Text('Gerar OS Digital'),
    );
  }

  getFileNameByData(dataset) {
    var formattedDate = dataset["dados"]?["DATA INICIO"]?.replaceAll("/", "_");

    var fileName =
        "${dataset["dados"]?["EMBARCAÇÃO"]} - ${dataset["dados"]?["EQUIPAMENTO"]} - ${formattedDate}.pdf";

    return fileName;
  }
}
