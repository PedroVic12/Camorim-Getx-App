import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:camorim_getx_app/api/Raichu_api.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class ImagemController extends GetxController {
  var textoExtraido = "".obs;
  var imagemBytes = Rx<Uint8List?>(null);

  void atualizarTexto(String novoTexto) {
    textoExtraido.value = novoTexto;
  }

  Future<void> selecionarImagem() async {
    try {
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
      } else {
        final imagemEscolhida =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (imagemEscolhida != null) {
          imagemBytes.value = await File(imagemEscolhida.path).readAsBytes();
          Get.snackbar('Sucesso', 'Imagem selecionada com sucesso.');
        } else {
          Get.snackbar('Erro', 'Nenhuma imagem foi selecionada.');
        }
      }
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao selecionar imagem: $e');
    }
  }

  Future<void> enviarImagemServidorWeb() async {
    try {
      if (imagemBytes.value != null) {
        final encodedImage = base64Encode(imagemBytes.value!);
        final response = await RaichuRestApi()
            .createData('/upload_image', {'image': encodedImage});
        if (response.containsKey('result')) {
          final extractedText =
              response['result'] ?? "Erro na extração do texto";
          atualizarTexto(extractedText);
          Get.snackbar('Sucesso', 'Texto extraído com sucesso.');
        } else if (response.containsKey('message')) {
          Get.snackbar('Erro', response['message']);
        } else {
          Get.snackbar('Erro', 'Erro desconhecido.');
        }
      } else {
        Get.snackbar('Erro', 'Selecione uma imagem primeiro.');
      }
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao enviar imagem: $e');
    }
  }
}
