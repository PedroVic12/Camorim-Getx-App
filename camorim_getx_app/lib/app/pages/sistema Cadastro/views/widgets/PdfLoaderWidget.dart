import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PdfDownloader {
  Future<String> downloadPdf(Map<String, dynamic> data) async {
    final url = "https://docker-raichu.onrender.com/gerar-pdf/";
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({"dados": data}),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      // Verifica se a resposta do servidor é um JSON válido
      if (response.body.isEmpty) {
        throw Exception("Resposta vazia do servidor");
      }

      final downloadUrl = response.body;
      print(downloadUrl);
      return downloadUrl;
    } else {
      throw Exception("Falha ao baixar o PDF");
    }
  }
}

class PdfDownloadButton extends StatelessWidget {
  final Map<String, dynamic> data;
  final PdfDownloader downloader;

  const PdfDownloadButton({
    Key? key,
    required this.data,
    required this.downloader,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          final downloadUrl = await downloader.downloadPdf(data);
          // Abrir o PDF em uma nova aba do navegador
          html.window.open(downloadUrl, 'PDF Viewer');
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
            ),
          );
        }
      },
      child: Text('Baixar PDF'),
    );
  }
}

class PdfDownloadPage extends StatelessWidget {
  final PdfDownloader downloader;

  const PdfDownloadPage({
    Key? key,
    required this.downloader,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download de PDF'),
      ),
      body: Center(
        child: PdfDownloadButton(
          data: {
            'EMBARCAÇÃO': 'BALSA CAMORIM',
            'DATA INICIO': '19/02/2024',
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
          },
          downloader: downloader,
        ),
      ),
    );
  }
}
