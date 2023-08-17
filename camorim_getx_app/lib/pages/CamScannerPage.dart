import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf_widget;
import 'package:printing/printing.dart';

class CamScannerPage extends StatefulWidget {
  const CamScannerPage({super.key});

  @override
  State<CamScannerPage> createState() => _CamScannerPageState();
}

class _CamScannerPageState extends State<CamScannerPage> {
  File? file;
  ImagePicker image = ImagePicker();

// Getters e Setters
  getImagemGaleria() async {
    var img = await image.pickImage(source: ImageSource.gallery);

    setState(() {
      file = File(img!.path);
    });
  }

  getImagemCamera() async {
    try {
      var img = await image.pickImage(source: ImageSource.camera);
      setState(() {
        file = File(img!.path);
      });
    } catch (e) {
      print('Camera nao disponivel');
    }
  }

  Future<Uint8List> gerarPdf(PdfPageFormat format, file) async {
    final pdf =
        pdf_widget.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();

    final showImagem = pdf_widget.MemoryImage(file.readAsBytesSync());

    pdf.addPage(
      pdf_widget.Page(
        pageFormat: format,
        build: (context) {
          return pdf_widget.Center(
            child: pdf_widget.Column(
              children: [
                pdf_widget.Text(
                  'Imagem',
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('SCANNER DE PDF'),
            if (file != null) ...[
              Image.file(file!),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final pdf = await gerarPdf(PdfPageFormat.a4, file);
                  await Printing.layoutPdf(
                      onLayout: (PdfPageFormat format) async => pdf);
                },
                child: const Text('Gerar PDF'),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                getImagemGaleria();
              },
              child: const Text('Galeria'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                getImagemCamera();
              },
              child: const Text('Camera'),
            ),
          ],
        ),
      ),
    );
  }
}
