import 'package:dio/dio.dart';

class RaichuRestApi {
  final Dio _dio;

  // URL da API (altere para o seu endpoint)
  final String url_raichu_server = 'http://127.0.0.1:5000';

  RaichuRestApi([Dio? dio])
      : _dio = dio ?? Dio(BaseOptions(baseUrl: 'http://127.0.0.1:5000'));

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
