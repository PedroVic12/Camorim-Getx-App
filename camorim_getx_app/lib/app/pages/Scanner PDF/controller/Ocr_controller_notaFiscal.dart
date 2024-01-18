import 'package:camorim_getx_app/app/pages/Scanner%20PDF/controller/servidor_dio_ocr.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart' as getX;

class OCRController {
  XFile? imagemSelecionada;
  String textoExtraido = '';
  final String baseUrl = 'https://docker-raichu.onrender.com';

  final String raichu_url = 'https://raichu-server-web.onrender.com';
  final dio_API = ServidorOCR();
  bool isLoading = false; // Adicionado para gerenciar o estado de carregamento
  TextEditingController totalText = TextEditingController();
  TextEditingController dataText = TextEditingController();
  TextEditingController categoriaText = TextEditingController();
  TextEditingController localText = TextEditingController();
  TextEditingController produtosText = TextEditingController();

  getStatus() async {
    var response = await dio_API.dio.get('$baseUrl/');
    print('Testando o docker  ${response.data} ');
  }

  Future<void> processarRespostaAPI(http.Response response) async {
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      dataText.text = responseData['Data'];
      localText.text = responseData['Local'];
      produtosText.text =
          responseData['Produtos'].join(", "); // Se for uma lista
      totalText.text = responseData['Total'];
    } else {
      // Lidar com erros ou status de resposta não esperados
      print('Erro na ao pegar os dados');
    }
  }

  Future<void> escolherImagemGaleria() async {
    final ImagePicker seletorImagem = ImagePicker();
    final XFile? imagem =
        await seletorImagem.pickImage(source: ImageSource.gallery);

    if (imagem != null) {
      imagemSelecionada = imagem;
      await sendImageServer(imagem);
    }
  }

  Future<void> escolherImagemCamera() async {
    final ImagePicker seletorImagem = ImagePicker();
    final XFile? imagem = await seletorImagem.pickImage(
      source: ImageSource.camera, maxHeight: 600, // Exemplo de altura máxima
      maxWidth: 600,
    );

    if (imagem != null) {
      imagemSelecionada = imagem;

      await sendImageServer(imagemSelecionada!);
    }
  }

  Future<http.Response> sendImageServer(XFile file) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${baseUrl}/enviar-foto/'),
    );
    request.files.add(
      http.MultipartFile(
        'file', // Este deve ser o nome do campo esperado pelo servidor
        file.readAsBytes().asStream(),
        await file.length(),
        filename: file.name,
      ),
    );
    var res = await request.send();
    var response = await http.Response.fromStream(res);
    print("Response status code: ${res.statusCode}");

    if (res.statusCode == 200) {
      print("Response body: " + response.body);

      var responseData = await json.decode(response.body);

      textoExtraido = responseData['ocr_text'];

      showMessage('OK', 'Imagem enviada com sucesso!');
    }
    return response;
  }

  Future<void> obterTexto() async {
    var response = await dio_API.dio.get('$baseUrl/get-text/');
    if (response.statusCode == 200) {
      textoExtraido = response.data['extracted_text'];
      dataText.text = textoExtraido;
    }
  }

  void showMessage(String texto1, String texto2) {
    getX.Get.snackbar(texto1, texto2, snackPosition: getX.SnackPosition.TOP);
  }
}
