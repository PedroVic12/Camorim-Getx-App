import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camorim_getx_app/widgets/CustomDrawer.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf_widget;
import 'package:printing/printing.dart';

class CamScannerPage extends StatefulWidget {
  const CamScannerPage({super.key});

  @override
  State<CamScannerPage> createState() => _CamScannerPageState();
}

class _CamScannerPageState extends State<CamScannerPage> {
  Uint8List? imageData;
  String? customFileName; // To store the custom file name

  // Função para capturar imagem
  _captureImage(bool fromCamera) async {
    final input = html.FileUploadInputElement()
      ..accept = fromCamera ? 'image/*;capture=camera' : 'image/*';
    input.click();

    input.onChange.listen((event) {
      final file = input.files!.first;
      final reader = html.FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        setState(() {
          imageData = reader.result as Uint8List;
        });
      });
    });
  }

  Future<Uint8List> gerarPdf(PdfPageFormat format) async {
    final pdf =
        pdf_widget.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();

    final showImagem = pdf_widget.MemoryImage(imageData!);

    pdf.addPage(
      pdf_widget.Page(
        pageFormat: format,
        build: (context) {
          return pdf_widget.Center(
            child: pdf_widget.Column(
              children: [
                pdf_widget.Text(
                  customFileName ?? 'Imagem',
                  style: pdf_widget.TextStyle(
                    font: font,
                    fontSize: 20,
                  ),
                ),
                pdf_widget.Image(showImagem, fit: pdf_widget.BoxFit.contain),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CamScanner'),
        backgroundColor: Colors.blue,
      ),
      drawer: CustomDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('SCANNER DE PDF'),
            if (imageData != null) ...[
              Container(
                width: 200,
                height: 200,
                child: Image.memory(imageData!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Ask for custom file name
                  customFileName = await showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Digite o nome do arquivo'),
                        content: TextField(
                          onChanged: (value) {
                            customFileName = value;
                          },
                        ),
                        actions: [
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop(customFileName);
                            },
                          ),
                        ],
                      );
                    },
                  );
                  final pdf = await gerarPdf(PdfPageFormat.a4);
                  final blob = html.Blob([pdf]);
                  final url = html.Url.createObjectUrlFromBlob(blob);
                  final anchor = html.AnchorElement(href: url)
                    ..target = 'blank'
                    ..download = customFileName ?? 'imagem.pdf'
                    ..click();
                  html.Url.revokeObjectUrl(url);
                },
                child: const Text('Gerar PDF'),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _captureImage(false);
              },
              child: const Text('Galeria'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _captureImage(true);
              },
              child: const Text('Camera'),
            ),
          ],
        ),
      ),
    );
  }
}
