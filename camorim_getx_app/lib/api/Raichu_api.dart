import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class RaichuRestApi {
  final _dio = Dio();

  // URL da API (altere para o seu endpoint)
  final String url_raichu_server = 'raichu-server-web.onrender.com';

  Future<Map<String, dynamic>> uploadImage(Uint8List imageData) async {
    try {
      // Substitua pelo endpoint do seu servidor
      String path = 'raichu-server-web.onrender.com/upload_image';

      // Substitua pelo nome do campo esperado pelo seu servidor
      String imageFieldName = 'image';

      // Preparando os dados do arquivo para enviar como parte da requisição
      MultipartFile imageFile = MultipartFile.fromBytes(
        imageData,
        //filename: 'my_image.jpg',
        //contentType: MediaType('image', 'jpeg'),
      );

      // Criando o FormData
      FormData formData = FormData.fromMap({
        imageFieldName: imageFile,
      });

      // Fazendo a requisição POST
      var response = await _dio.post(path, data: formData);
      return response.data;
    } catch (e) {
      throw Exception('Erro ao fazer upload da imagem: $e');
    }
  }

  // CREATE
  Future<Map<String, dynamic>> createData(
      String path, Map<String, dynamic> data) async {
    try {
      var response = await _dio.post(path, data: data);
      return response.data;
    } catch (e) {
      throw Exception('Erro ao criar dados: $e');
    }
  }

  // READ
  Future<Map<String, dynamic>> readData(String path) async {
    try {
      final response = await _dio.get(path);
      return response.data;
    } catch (e) {
      throw Exception('Erro ao ler dados: $e');
    }
  }

  // UPDATE
  Future<void> updateData(String path, Map<String, dynamic> data) async {
    try {
      await _dio.put(path, data: data);
    } catch (e) {
      throw Exception('Erro ao atualizar dados: $e');
    }
  }

  // DELETE
  Future<void> deleteData(String path) async {
    try {
      await _dio.delete(path);
    } catch (e) {
      throw Exception('Erro ao deletar dados: $e');
    }
  }
}
