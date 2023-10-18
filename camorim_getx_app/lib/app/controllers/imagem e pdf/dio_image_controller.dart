import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class DioFilesRestApiController extends StatefulWidget {
  @override
  State<DioFilesRestApiController> createState() =>
      _DioFilesRestApiControllerState();
}

class _DioFilesRestApiControllerState extends State<DioFilesRestApiController> {
  final restApi = Dio();

  Future<void> enviarImagemServidor({required ImageSource source}) async {
    var imagePicker = await ImagePicker().pickImage(source: source);

    if (imagePicker != null) {
      FormData formData;
      try {
        String fileName = imagePicker.path.split('/').last;
        formData = FormData.fromMap({
          'image': await MultipartFile.fromFile(
            imagePicker.path,
            filename: fileName,
            contentType: MediaType('image', 'png'),
          ),
        });

        await dioPost(formData);
      } catch (e) {
        print(e);
      }
    } else {
      print("Seleção de imagem cancelada");
    }
  }

  Future<void> dioPost(FormData formData) async {
    try {
      Response response = await restApi.post(
        'YOUR_SERVER_ENDPOINT_HERE', // <--- Substitua pelo endpoint correto
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      print("Resposta do servidor: ${response.data}");
    } catch (e) {
      print("Erro ao enviar imagem: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () => enviarImagemServidor(source: ImageSource.gallery),
            child: Text('Enviar imagem da galeria para o servidor'),
          ),
          ElevatedButton(
            onPressed: () => enviarImagemServidor(source: ImageSource.camera),
            child: Text('Enviar imagem da câmera para o servidor'),
          ),
        ],
      ),
    );
  }
}
