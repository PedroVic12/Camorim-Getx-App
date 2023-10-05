import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../widgets/BotaoWidget.dart';
import '../controller/imagem_controller.dart';

class ColunaBotoes extends StatelessWidget {
  final controllerImage = Get.find<ImagemController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        BotaoWidget(
          btnPressionado: () =>
              controllerImage.selecionarImagem(ImageSource.gallery),
          text: 'Pegar imagem da Galeria',
          cor: MaterialStateProperty.all<Color?>(Colors.red),
        ),
        BotaoWidget(
          btnPressionado: () =>
              controllerImage.selecionarImagem(ImageSource.camera),
          text: 'Pegar imagem da Camera',
          cor: MaterialStateProperty.all<Color?>(Colors.blueAccent),
        )
      ],
    );
  }
}
