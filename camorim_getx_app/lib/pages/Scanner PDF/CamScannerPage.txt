import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf_widget;
import 'package:printing/printing.dart';
import 'dart:html' as html;

class CamScannerPage extends StatefulWidget {
  const CamScannerPage({super.key});

  @override
  State<CamScannerPage> createState() => _CamScannerPageState();
}

class _CamScannerPageState extends State<CamScannerPage> {
  Uint8List? imageData;
  String? customFileName; // Para armazenar o nome personalizado do arquivo

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

  Future<Uint8List> gerarPdf(Uint8List image) async {
    final pdf =
        pdf_widget.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();

    final showImagem = pdf_widget.MemoryImage(image);

    pdf.addPage(
      pdf_widget.Page(
        build: (context) {
          return pdf_widget.Center(
            child: pdf_widget.Column(
              children: [
                pdf_widget.Text(
                  customFileName ??
                      'Imagem', // Use o nome personalizado do arquivo, se fornecido
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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('CamScanner'),
        backgroundColor: CupertinoColors.activeBlue,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('SCANNER DE PDF', style: TextStyle(fontSize: 20)),
            if (imageData != null) ...[
              Container(
                width: 200,
                height: 200,
                child: Image.memory(imageData!),
              ),
              const SizedBox(height: 20),
              CupertinoButton(
                color: CupertinoColors.activeBlue,
                onPressed: () async {
                  customFileName = await showCupertinoDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title: const Text('Enter File Name'),
                        content: CupertinoTextField(
                          onChanged: (value) {
                            customFileName = value;
                          },
                        ),
                        actions: [
                          CupertinoDialogAction(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop(customFileName);
                            },
                          ),
                        ],
                      );
                    },
                  );
                  final pdf = await gerarPdf(imageData!);
                  await Printing.layoutPdf(
                      onLayout: (PdfPageFormat format) async => pdf);
                },
                child: const Text('Gerar PDF'),
              ),
            ],
            const SizedBox(height: 20),
            CupertinoButton(
              color: CupertinoColors.activeBlue,
              onPressed: () {
                _captureImage(false);
              },
              child: const Text('Galeria'),
            ),
            const SizedBox(height: 20),
            CupertinoButton(
              color: CupertinoColors.activeBlue,
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
