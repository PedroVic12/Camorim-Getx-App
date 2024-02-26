import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/controller/pdf_loader_controller.dart';
import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/views/widgets/send_files_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;

class PdfDownloadPage extends StatelessWidget {
  final PdfDownloader downloader;

  PdfDownloadPage({
    Key? key,
    required this.downloader,
  }) : super(key: key);
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
      'RESPONSAVEL': 'RONDINELLI'
    }
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download de PDF'),
      ),
      body: Center(
          child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          gerarRelatorioDigital(),
          GeneratePDF(),
          transferirArquivos(),
        ],
      )),
    );
  }

  Widget gerarRelatorioDigital() {
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

            // Salvar o arquivo no disco
            final blob = html.Blob([bytes]);
            final url = html.Url.createObjectUrlFromBlob(blob);
            final anchor = html.AnchorElement(href: url)
              ..setAttribute("download", "relatorio.pdf")
              ..click();

            // Limpar a URL
            html.Url.revokeObjectUrl(url);

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

  Widget transferirArquivos() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.blue),
      ),
      onPressed: () async {
        try {
          // Dados para enviar como JSON
          Map<String, dynamic> requestData = dataset;

          // Enviar solicitação POST para o servidor FastAPI
          var response = await http.post(
            Uri.parse('https://docker-raichu.onrender.com/generate-pdf'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(requestData),
          );

          print('Status code: ${response.statusCode}');

          // Verificar se a solicitação foi bem-sucedida
          if (response.statusCode == 200) {
            // Converter a resposta em bytes
            Uint8List bytes = response.bodyBytes;

            // Criar um objeto Blob para o arquivo PDF
            var blob = html.Blob([bytes]);

            // Criar a URL do arquivo PDF
            var url = html.Url.createObjectUrlFromBlob(blob);

            // Abrir o arquivo PDF no navegador
            html.window.open(url, "_blank");
          } else {
            print('Erro ao baixar o PDF: ${response.statusCode}');
          }
        } catch (e) {
          print('Erro: $e');
        }
      },
      child: Text('Baixar PDF'),
    );
  }
}
