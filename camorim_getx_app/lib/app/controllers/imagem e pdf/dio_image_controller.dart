import 'dart:io';
import 'package:camorim_getx_app/app/controllers/imagem%20e%20pdf/files_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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

  Future<void> pegandoImagemWeb({required ImageSource source}) async {
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
        'raichu-server-web.onrender.com/upload_image',
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
    final FilesController controller = FilesController();
    //pegando a imagem pelo controller
    Uint8List? imagemBytes = controller.imagemBytes.value;

    return Container(
      color: Colors.red,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: controller.pegarUmArquivo,
            child: Text('Selecione um arquivo'),
          ),
          Card(
            child: Text('Exibindo a imagem'),
          ),
          ElevatedButton(
              onPressed: () {
                try {
                  dioPost(imagemBytes as FormData);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Imagem enviada com sucesso'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Fazer um post da img'))
        ],
      ),
    );
  }
}
