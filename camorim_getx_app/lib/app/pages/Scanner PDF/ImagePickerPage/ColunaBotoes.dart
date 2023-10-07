import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

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
          btnPressionado: controllerImage.selecionarImagem,
          text: 'Pegar imagem',
          cor: MaterialStateProperty.all<Color?>(Colors.red),
        ),
      ],
    );
  }
}
