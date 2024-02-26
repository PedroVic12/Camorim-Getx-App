import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:universal_html/html.dart' as html;
import 'package:open_file/open_file.dart';

import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/cadastro_controllers.dart';
import 'package:camorim_getx_app/widgets/TableCustom.dart';
import 'package:camorim_getx_app/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../CRUD Excel/controllers/bulbassaur_excel.dart';

class ShowTableDadosCadastrados extends StatelessWidget {
  final bulbassauro = Get.put(BulbassauroExcelController());
  final CadastroController relatorio_controller = Get.put(CadastroController());
  Uint8List? pdfBytes;

  @override
  Widget build(BuildContext context) {
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
                gerarRelatorioDigital(),
              ],
            ),

            Center(
                child: pdfBytes != null
                    ? SfPdfViewer.memory(pdfBytes!, key: UniqueKey())
                    : CircularProgressIndicator()),
          ],
        ));
  }

  Future showPdfFile(url) async {
    return Get.dialog(
      Dialog(
        child: Container(
          height: 600,
          width: 300,
          child: Column(
            children: [
              Expanded(
                child: SfPdfViewer.memory(
                  url,
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

  Widget abrirPDF(url) {
    return Scaffold(
      body: Container(
        height: 600,
        width: 300,
        child: Column(children: [Text("PDF gerado"), SfPdfViewer.network(url)]),
      ),
    );
  }

  Widget gerarRelatorioDigital() {
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
    void salvarDadosRelatorioOS() {
      relatorio_controller.array_cadastro.map((data) {
        dadosCadastrados["dados"]["EMBARCAÇÃO"] = data.rebocador;
        dadosCadastrados["dados"]["DESCRIÇÃO DA FALHA"] = data.descFalha;
        dadosCadastrados["dados"]["EQUIPAMENTO"] = data.equipamento;
        dadosCadastrados["dados"]["MANUTENÇÃO"] = data.tipoManutencao;
        dadosCadastrados["dados"]["SERVIÇO EXECUTADO"] = data.servicoExecutado;
        dadosCadastrados["dados"]["DATA DE ABERTURA"] =
            data.dataFinal.toString();

        dadosCadastrados["dados"]["RESPONSAVEL EXECUÇÃO"] =
            data.funcionario.toString();
        dadosCadastrados["dados"]["OFICINA"] = data.oficina;
        dadosCadastrados["dados"]["FINALIZADO"] =
            data.status_finalizado.toString();
        dadosCadastrados["dados"]["DATA DE CONCLUSÃO"] =
            data.dataFinal.toString();
        dadosCadastrados["dados"]["FORA DE OPERAÇÃO"] =
            data.status_finalizado.toString();
        dadosCadastrados["dados"]["OBSERVAÇÃO"] = data.obs;
      });
      print(
        "\n\nDEBUG JSON REQUEST = $dadosCadastrados",
      );
    }

    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.green),
      ),
      onPressed: () async {
        try {
          // Dados para enviar como JSON
          Map<String, dynamic> requestData = dataset;

          // Enviar solicitação POST para o servidor FastAPI
          var response = await http.post(
            Uri.parse('https://docker-raichu.onrender.com/gerar-pdf'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(requestData),
          );

          print('Status code: ${response.statusCode}');

          // Verificar se a solicitação foi bem-sucedida
          if (response.statusCode == 200) {
            // Converter a resposta em bytes
            Uint8List bytes = response.bodyBytes;
            pdfBytes = response.bodyBytes;

            var formattedDate =
                dataset["dados"]?["DATA INICIO"]?.replaceAll("/", "_");

            var fileName =
                "${dataset["dados"]?["EMBARCAÇÃO"]} - ${dataset["dados"]?["EQUIPAMENTO"]} - ${formattedDate}.pdf";

            print(fileName);

            // Salvar o arquivo no disco
            final blob = html.Blob([bytes]);
            final url = html.Url.createObjectUrlFromBlob(blob);
            final anchor = html.AnchorElement(href: url)
              ..setAttribute("download", fileName)
              ..click();

            // Escrever os bytes do PDF no arquivo
            try {
              print(url);
              final dir = await getApplicationDocumentsDirectory(
                  //onError: (error, stackTrace) => print("Erro ao obter o diretório"),

                  );
              final file = File("${dir.path}/$fileName");
              print("File = $file");
              //salvarArquivo(bytes, fileName);
              //Get.to(abrirPDF(url));
              showPdfFile(bytes);
            } catch (e) {
              print("erro $e");
            }

            // Limpar a URL
            html.Url.revokeObjectUrl(url);

            salvarDadosRelatorioOS();

            Get.snackbar("Sucesso", "Relatório gerado",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green);
          } else {
            print('Erro ao baixar o PDF: ${response.statusCode}');
          }
        } catch (e) {
          print('Erro: $e');
        }
      },
      child: Text('Gerar Relatório Digital'),
    );
  }

  Future<void> salvarArquivo(Uint8List bytes, String fileName) async {
    final filePath = "../../output/$fileName";
    final pdfFile = await File(filePath).writeAsBytes(bytes);
    print('Arquivo salvo em: ${pdfFile.path}');
  }
}
