import 'dart:convert';
import 'dart:io';

import 'package:camorim_getx_app/app/controllers/imagem%20e%20pdf/pegando_arquivo_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';

class FilesController extends GetxController {
  var selectedFiles = <PlatformFile>[].obs;
  var pickedImage = Rx<Image?>(null);
  var pickedImageData = Rx<Uint8List?>(null);
  var imagemBytes = Rx<Uint8List?>(null);
  Uint8List webImage = Uint8List(8);

  void pegarUmArquivo() async {
    if (kIsWeb) {
      if (kIsWeb) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
        );

        if (result != null) {
          imagemBytes.value = result.files.single.bytes;
          Get.snackbar('Sucesso', 'Imagem selecionada com sucesso.');
        } else {
          Get.snackbar('Erro', 'Nenhuma imagem foi selecionada.');
        }
      }
    } else {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        selectedFiles.add(result.files.single);
        Get.to(() => DisplayFilesWidget());
      }
    }
  }

  void pegarVariosArquivos() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      selectedFiles.addAll(result.files);
      Get.to(() => DisplayFilesWidget());
    }
  }

  void abrirArquivo(String path) {
    OpenFile.open(path);
  }
}
