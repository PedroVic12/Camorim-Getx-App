import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PdfDownloader {
  Future<Uint8List> downloadPdf(Map<String, dynamic> data) async {
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

      if (response.headers["content-type"] == "application/pdf") {
        print(response.bodyBytes);
        return response.bodyBytes;
      } else {
        throw Exception("Resposta do servidor não é um pdf válido");
      }
    } else {
      throw Exception("Falha ao baixar o PDF");
    }
  }
}

class PdfDownloadButton extends StatefulWidget {
  final Map<String, dynamic> data;
  final PdfDownloader downloader;

  const PdfDownloadButton({
    Key? key,
    required this.data,
    required this.downloader,
  }) : super(key: key);

  @override
  _PdfDownloadButtonState createState() => _PdfDownloadButtonState();
}

class _PdfDownloadButtonState extends State<PdfDownloadButton> {
  bool _downloading = false;
  String? _downloadedPdfUrl;

  @override
  Widget build(BuildContext context) {
    return _downloading
        ? CircularProgressIndicator() // Mostrar indicador de progresso durante o download
        : _downloadedPdfUrl != null
            ? ElevatedButton(
                onPressed: () async {
                  // Abrir o PDF em uma nova aba do navegador
                  if (await canLaunch(_downloadedPdfUrl!)) {
                    await launch(_downloadedPdfUrl!);
                  } else {
                    throw Exception("Não foi possível baixar o PDF");
                  }
                },
                child: Text('Abrir PDF'),
              )
            : ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _downloading = true;
                  });
                  try {
                    final downloadUrl =
                        await widget.downloader.downloadPdf(widget.data);
                    setState(() {
                      _downloadedPdfUrl = downloadUrl as String?;
                      _downloading = false;
                    });
                  } catch (e) {
                    setState(() {
                      _downloading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                      ),
                    );
                  }
                },
                child: Text('Baixar PDF URL LAUNCHER'),
              );
  }
}
