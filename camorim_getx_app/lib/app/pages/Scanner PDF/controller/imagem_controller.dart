import 'dart:convert';
import 'dart:io';
import 'package:camorim_getx_app/api/Raichu_api.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagemController extends GetxController {
  var textoExtraido = "".obs;
  var imagemSelecionada = Rx<File?>(null);

  void atualizarTexto(String novoTexto) {
    textoExtraido.value = novoTexto;
  }

  Future<void> selecionarImagem(ImageSource source) async {
    try {
      final imagemEscolhida = await ImagePicker().pickImage(source: source);
      if (imagemEscolhida != null) {
        imagemSelecionada.value = File(imagemEscolhida.path);
        Get.snackbar('Sucesso', 'Imagem selecionada com sucesso.');
      } else {
        Get.snackbar('Erro', 'Nenhuma imagem foi selecionada.');
      }
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao selecionar imagem: $e');
    }
  }

  Future<void> enviarImagem() async {
    try {
      if (imagemSelecionada.value != null) {
        final bytes = imagemSelecionada.value!.readAsBytesSync();
        final encodedImage = base64Encode(bytes);
        final response = await RaichuRestApi()
            .createData('/upload_image', {'image': encodedImage});
        final extractedText = response['extracted_text'] ??
            "Erro na extração do texto"; // Ajuste para lidar com null.
        atualizarTexto(extractedText);
        Get.snackbar('Sucesso', 'Texto extraído com sucesso.');
      } else {
        Get.snackbar('Erro', 'Selecione uma imagem primeiro.');
      }
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao enviar imagem: $e');
    }
  }
}
