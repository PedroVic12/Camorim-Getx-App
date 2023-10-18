import 'dart:io';
import 'dart:typed_data';
import 'package:camorim_getx_app/app/pages/Scanner%20PDF/first_page.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// Controller para o Dio:
class FilesController extends GetxController {
  final restApi = Dio();
  var selectedFiles = <PlatformFile>[].obs;
  var pickedImage = Rx<Image?>(null);
  var pickedImageData = Rx<Uint8List?>(null);
  var imagemBytes = Rx<Uint8List?>(null);
  Uint8List webImage = Uint8List(8);
}

// Controller para seleção de imagem:
class ImagePickerController extends GetxController {
  final picker = ImagePicker();
  var imagens = <File>[].obs;

  Future<void> pegarImagem({required ImageSource source}) async {
    final arquivoSelecionado = await picker.pickImage(source: source);
    if (arquivoSelecionado != null) {
      imagens.add(File(arquivoSelecionado.path));
    } else {
      print('Nenhuma imagem selecionada.');
    }
  }

  Future<Uint8List> gerarDocumento(PdfPageFormat formato) async {
    final doc = pw.Document();
    for (var imagem in imagens) {
      final imagemExibida = pw.MemoryImage(imagem.readAsBytesSync());
      doc.addPage(pw.Page(
        build: (context) =>
            pw.Center(child: pw.Image(imagemExibida, fit: pw.BoxFit.contain)),
      ));
    }
    return await doc.save();
  }
}

class ImageDisplayCard extends StatelessWidget {
  final File image;

  ImageDisplayCard({required this.image});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0, // Ajuste a elevação conforme necessário
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.file(
          image,
          fit: BoxFit.cover, // Use BoxFit conforme necessário
        ),
      ),
    );
  }
}

// Widgets:
class DioFilesRestApiWidget extends StatelessWidget {
  final controller = FilesController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {},
          // onPressed: () =>              controller.enviarImagemServidor(source: ImageSource.gallery),
          child: Text('Enviar imagem da galeria para o servidor'),
        ),
        ElevatedButton(
          // onPressed: () =>              controller.enviarImagemServidor(source: ImageSource.gallery),
          onPressed: () {},

          child: Text('Enviar imagem da câmera para o servidor'),
        ),
      ],
    );
  }
}

class ImagePickerWidget extends StatefulWidget {
  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePickerController controller = Get.put(ImagePickerController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ElevatedButton(
          child: Text('Pegar Imagem da Galeria'),
          onPressed: () => controller.pegarImagem(source: ImageSource.gallery),
        ),
        ElevatedButton(
          child: Text('Pegar Imagem da Câmera'),
          onPressed: () => controller.pegarImagem(source: ImageSource.camera),
        ),
        Obx(() {
          if (controller.imagens.isNotEmpty) {
            return ImageDisplayCard(image: controller.imagens.last);
          } else {
            return Text('Nenhuma imagem selecionada.');
          }
        }),
      ],
    );
  }
}
