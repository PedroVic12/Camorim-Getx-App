import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:printing/printing.dart';

class Controller extends GetxController {
  final picker = ImagePicker();
  final pdf = pw.Document();
  var imagens = <File>[].obs;

  Future<void> pegarImagemDaGaleria() async {
    final arquivoSelecionado =
        await picker.pickImage(source: ImageSource.gallery);
    if (arquivoSelecionado != null) {
      imagens.add(File(arquivoSelecionado.path));
    } else {
      print('Nenhuma imagem selecionada.');
    }
  }

  Future<void> pegarImagemDaCamera() async {
    final arquivoSelecionado =
        await picker.pickImage(source: ImageSource.camera);
    if (arquivoSelecionado != null) {
      imagens.add(File(arquivoSelecionado.path));
    } else {
      print('Nenhuma imagem selecionada.');
    }
  }

  Future<Uint8List> gerarDocumento(PdfPageFormat formato) async {
    final doc = pw.Document(pageMode: PdfPageMode.outlines);
    for (var imagem in imagens) {
      final imagemExibida = pw.MemoryImage(imagem.readAsBytesSync());
      doc.addPage(
        pw.Page(
          build: (context) =>
              pw.Center(child: pw.Image(imagemExibida, fit: pw.BoxFit.contain)),
        ),
      );
    }
    return await doc.save();
  }
}

class PrimeiraPagina extends StatelessWidget {
  final controller = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          if (controller.imagens.isEmpty) {
            return Center(
              child: Text(
                'Selecione uma imagem da câmera ou galeria',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.indigo[900], fontSize: 30),
              ),
            );
          } else {
            return PdfPreview(
              maxPageWidth: 1000,
              canChangeOrientation: true,
              canDebug: false,
              build: (format) => controller.gerarDocumento(format),
            );
          }
        }),
        Align(
          alignment: Alignment(-0.5, 0.8),
          child: FloatingActionButton(
            child: Icon(Icons.image),
            backgroundColor: Colors.indigo[900],
            onPressed: controller.pegarImagemDaGaleria,
          ),
        ),
        Align(
          alignment: Alignment(0.5, 0.8),
          child: FloatingActionButton(
            child: Icon(Icons.camera),
            backgroundColor: Colors.indigo[900],
            onPressed: controller.pegarImagemDaCamera,
          ),
        ),
      ],
    );
  }
}
