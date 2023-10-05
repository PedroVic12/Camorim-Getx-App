import 'dart:io';

import 'package:camorim_getx_app/app/pages/Scanner%20PDF/ImagePickerPage/ColunaBotoes.dart';
import 'package:camorim_getx_app/widgets/AppBarPersonalizada.dart';
import 'package:camorim_getx_app/widgets/BotaoWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controller/imagem_controller.dart';

class ScannerOcrPage extends StatelessWidget {
  final controllerImage = Get.put(ImagemController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPersonalizada(
        titulo: "Extrair texto manuscrito de uma imagem",
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => controllerImage.enviarImagem(),
              child: Text("Enviar Imagem para Servidor"),
            ),
            SizedBox(height: 20),
            Center(child: ColunaBotoes()),
            const SizedBox(
              height: 20,
            ),
            Obx(() => controllerImage.imagemSelecionada.value != null
                ? Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.file(controllerImage.imagemSelecionada.value!))
                : Text('Insira uma imagem...')),
          ],
        ),
      ),
    );
  }
}
