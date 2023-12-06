import 'dart:io';
import 'dart:typed_data';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class DragonitePDF {
  Future<String> createSimpleTextPDF(String text, String filePath) async {
      // Método para criar um PDF simples com texto

    final PdfDocument document = PdfDocument();
    document.pages.add().graphics.drawString(
      text, 
      PdfStandardFont(PdfFontFamily.helvetica, 12),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      bounds: const Rect.fromLTWH(0, 0, 150, 20)
    );
    return await _saveDocument(document, filePath);
  }

  Future<String> createTrueTypeFontPDF(String text, String fontPath, String filePath) async {
      // Método para criar um PDF com texto usando fonte TrueType

    final PdfDocument document = PdfDocument();
    final Uint8List fontData = File(fontPath).readAsBytesSync();
    final PdfFont font = PdfTrueTypeFont(fontData, 12);
    document.pages.add().graphics.drawString(
      text, 
      font,
      bounds: const Rect.fromLTWH(0, 0, 200, 50)
    );
    return await _saveDocument(document, filePath);
  }

  Future<String> createImagePDF(String imagePath, String filePath) async {
      // Método para criar um PDF com uma imagem

    final PdfDocument document = PdfDocument();
    final Uint8List imageData = File(imagePath).readAsBytesSync();
    final PdfBitmap image = PdfBitmap(imageData);
    document.pages
        .add()
        .graphics
        .drawImage(image, const Rect.fromLTWH(0, 0, 500, 200));
    return await _saveDocument(document, filePath);
  }

  // Método auxiliar para salvar o documento PDF
  Future<String> _saveDocument(PdfDocument document, String filePath) async {
    File file = File(filePath);
    await file.writeAsBytes(document.save());
    document.dispose();
    return file.path;
  }

  // Método auxiliar para renomear o documento PDF
  Future<String> renamePDF(String oldFilePath, String newFilePath) async {
    File oldFile = File(oldFilePath);
    File newFile = oldFile.renameSync(newFilePath);
    return newFile.path;
  }
}
