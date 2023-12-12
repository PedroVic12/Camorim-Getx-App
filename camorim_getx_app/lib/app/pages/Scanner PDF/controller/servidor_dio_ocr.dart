import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class ServidorOCR {
  Dio dio = Dio();
  String baseUrl =
      'http://localhost:8000'; // Substitua com o endereço do seu servidor

  Future<String> enviarImagem(File imagem) async {
    String fileName = imagem.path.split('/').last;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(imagem.path, filename: fileName),
    });

    try {
      var response = await dio.post('$baseUrl/upload-image/', data: formData);
      return response.data.toString();
    } catch (e) {
      return '\n\n\nErro ao enviar imagem: $e';
    }
  }

  Future<String> obterTextoExtraido() async {
    try {
      var response = await dio.get('$baseUrl/get-text/');
      return response.data['extracted_text'];
    } catch (e) {
      return '\n\n\nErro ao obter texto: $e';
    }
  }
}
