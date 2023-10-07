import 'dart:typed_data';
import 'package:camorim_getx_app/app/pages/Scanner%20PDF/ImagePickerPage/ColunaBotoes.dart';
import 'package:camorim_getx_app/widgets/AppBarPersonalizada.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

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
              onPressed: controllerImage.selecionarImagem,
              child: Text("Selecionar Imagem"),
            ),
            ElevatedButton(
              onPressed: controllerImage.enviarImagemServidorWeb,
              child: Text("Enviar Imagem para Servidor"),
            ),
            SizedBox(height: 20),
            Obx(() {
              Uint8List? imagemBytes = controllerImage.imagemBytes.value;
              return imagemBytes != null
                  ? Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.memory(imagemBytes),
                    )
                  : Text('Insira uma imagem...');
            }),

            
          ],
        ),
      ),
    );
  }
}
