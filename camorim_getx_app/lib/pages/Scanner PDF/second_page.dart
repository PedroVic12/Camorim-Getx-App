import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'controller/pdf_controller.dart';

class Secondpage extends StatelessWidget {
  final controller = Get.put(ImageToPdfController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(() {
            return controller.image.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Selecione uma imagem da Câmera ou Galeria',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.indigo[900],
                          fontSize: 30,
                        ),
                      ),
                    ),
                  )
                : PdfPreview(
                    maxPageWidth: 1000,
                    canChangeOrientation: true,
                    canDebug: false,
                    build: (format) => _generateDocument(
                      format,
                      controller.image.length,
                      controller.image,
                    ),
                  );
          }),
          Align(
            alignment: Alignment(-0.5, 0.8),
            child: FloatingActionButton(
              elevation: 0.0,
              child: Icon(Icons.image),
              backgroundColor: Colors.indigo[900],
              onPressed: () =>
                  controller.getImageFromSource(ImageSource.gallery),
            ),
          ),
          Align(
            alignment: Alignment(0.5, 0.8),
            child: FloatingActionButton(
              elevation: 0.0,
              child: Icon(Icons.camera),
              backgroundColor: Colors.indigo[900],
              onPressed: () =>
                  controller.getImageFromSource(ImageSource.camera),
            ),
          ),
        ],
      ),
    );
  }

  Future<Uint8List> _generateDocument(
      PdfPageFormat format, int imagelength, List<Uint8List> images) async {
    final doc = pw.Document(pageMode: PdfPageMode.outlines);
    for (var img in images) {
      final showimage = pw.MemoryImage(img);
      doc.addPage(
        pw.Page(
          pageTheme: pw.PageTheme(
            pageFormat: format.copyWith(
              marginBottom: 0,
              marginLeft: 0,
              marginRight: 0,
              marginTop: 0,
            ),
            orientation: pw.PageOrientation.portrait,
          ),
          build: (context) {
            return pw.Center(
              child: pw.Image(showimage, fit: pw.BoxFit.contain),
            );
          },
        ),
      );
    }
    return await doc.save();
  }
}
