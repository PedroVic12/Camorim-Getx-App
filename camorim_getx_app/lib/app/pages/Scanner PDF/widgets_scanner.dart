import 'dart:typed_data';
import 'package:camorim_getx_app/app/pages/Scanner%20PDF/models/Dragonite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends GetxController {
  var imagens = <Uint8List>[].obs;

  Future<void> pegarImagem() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      Uint8List? imageData = await pickedFile.readAsBytes();
      imagens.add(imageData);
    } else {
      print('Nenhuma imagem selecionada.');
    }
  }
}

class ImageDisplayCard extends StatelessWidget {
  final Uint8List image;

  ImageDisplayCard({required this.image});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.memory(
          image,
        ),
      ),
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
          child: Text('Pegar Imagem da Câmera'),
          onPressed: controller.pegarImagem,
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

class ImagemController extends GetxController {
  var imagens = <Uint8List>[].obs;
  final DragonitePDF pdfCreator = DragonitePDF(); // Criador de PDF

  Future<void> pegarImagem() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      Uint8List? imageData = await pickedFile.readAsBytes();
      imagens.add(imageData);

      // Cria um PDF com a imagem capturada
      await pdfCreator.saveImageToPdf(imageData, 'NomeDoArquivo');
      // Salva e abre o PDF
      await pdfCreator.saveAndLauchFile(imageData, 'NomeDoArquivo.pdf');
    } else {
      print('Nenhuma imagem selecionada.');
    }
  }
}
