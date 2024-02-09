import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class DragonitePDF extends GetxController {
  Future<void> pegarImagem() async {
    var imagens = <Uint8List>[].obs;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      Uint8List? imageData = await pickedFile.readAsBytes();
      imagens.add(imageData);
    } else {
      print('Nenhuma imagem selecionada.');
    }
  }

  Future<String> createSimpleTextPDF(String text, String filePath) async {
    // Método para criar um PDF simples com texto

    final PdfDocument document = PdfDocument();
    document.pages.add().graphics.drawString(
          text,
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        );
    return await _saveDocument(document, filePath);
  }

  Future<String> createTrueTypeFontPDF(
      String text, String fontPath, String filePath) async {
    // Método para criar um PDF com texto usando fonte TrueType

    final PdfDocument document = PdfDocument();
    final Uint8List fontData = File(fontPath).readAsBytesSync();
    final PdfFont font = PdfTrueTypeFont(fontData, 12);
    document.pages
        .add()
        .graphics
        .drawString(text, font, bounds: const Rect.fromLTWH(0, 0, 200, 50));
    return await _saveDocument(document, filePath);
  }

  Future<void> saveImageToPdf(Uint8List image, String fileName) async {
    final PdfDocument document = PdfDocument();
    final PdfBitmap pdfImage = PdfBitmap(image);
    document.pages
        .add()
        .graphics
        .drawImage(pdfImage, Rect.fromLTWH(0, 0, 500, 200));

    // Salve o documento em um arquivo
    final file = File('$fileName.pdf');
    file.writeAsBytes(await document.save());
    document.dispose();
  }

  criarImagemPDF(String imagePath, String filePath) async {
    // Método para criar um PDF com uma imagem

    final PdfDocument document = PdfDocument();
    final Uint8List imageData = File(imagePath).readAsBytesSync();
    final PdfBitmap image = PdfBitmap(imageData);
    document.pages
        .add()
        .graphics
        .drawImage(image, const Rect.fromLTWH(0, 0, 500, 200));
    File('$filePath.pdf').writeAsBytes(await document.save());
  }

  // Método auxiliar para salvar o documento PDF
  Future<String> _saveDocument(PdfDocument document, String filePath) async {
    File file = File(filePath);
    await file.writeAsBytes(document.save() as List<int>);
    document.dispose();
    return file.path;
  }

  // Método auxiliar para renomear o documento PDF
  Future<String> renamePDF(String oldFilePath, String newFilePath) async {
    File oldFile = File(oldFilePath);
    File newFile = oldFile.renameSync(newFilePath);
    return newFile.path;
  }

  Future<void> captureImage(String file) async {
    final ImagePicker _picker = ImagePicker();
    var imagens = <Uint8List>[].obs;

    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      Uint8List imageData = await pickedFile.readAsBytes();
      imagens.add(imageData);
      addImageToPDF(imageData, file);
    } else {
      print('Nenhuma imagem selecionada.');
    }
  }

  Future<void> saveAndLauchFile(List<int> bytes, String fileName) async {
    // Método para salvar e abrir um arquivo PDF

    final String PATH = (await getExternalStorageDirectory())!.path;
    final File file = File("$PATH/$fileName");
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open("$PATH/$fileName");
  }

  Future<void> addImageToPDF(Uint8List imageData, String output) async {
    final PdfDocument document = PdfDocument();
    final PdfBitmap image = PdfBitmap(imageData);
    document.pages
        .add()
        .graphics
        .drawImage(image, const Rect.fromLTWH(0, 0, 500, 200));

    // Salvando o documento em um arquivo
    String filePath = '$output.pdf';
    File file = File(filePath);
    await file.writeAsBytes(await document.save());
    document.dispose();
    try {
      OpenFile.open(filePath);
      //await saveAndLauchFile(await file.readAsBytes(), filePath);
    } catch (e) {
      print("\n\n\nERRO: $e");
    }
  }
}
