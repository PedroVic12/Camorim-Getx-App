import 'dart:convert';
import 'dart:io';
import 'package:camorim_getx_app/app/pages/Scanner%20PDF/controller/servidor_dio_ocr.dart';
import 'package:camorim_getx_app/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getX;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class WidgetSelecionadorImagem extends StatefulWidget {
  @override
  _WidgetSelecionadorImagemState createState() =>
      _WidgetSelecionadorImagemState();
}

class _WidgetSelecionadorImagemState extends State<WidgetSelecionadorImagem> {
  XFile? imagemSelecionada;
  String textoExtraido = '';
  final String baseUrl =
      'https://bb8e-2804-18-4840-7eed-eafb-1cff-fed7-91f7.ngrok-free.app';
  final String raichu_url = 'https://raichu-server-web.onrender.com';
  final dio_API = ServidorOCR();
  bool isLoading = false; // Adicionado para gerenciar o estado de carregamento

  Future<void> escolherImagemGaleria() async {
    final ImagePicker seletorImagem = ImagePicker();
    final XFile? imagem =
        await seletorImagem.pickImage(source: ImageSource.gallery);

    if (imagem != null) {
      setState(() {
        imagemSelecionada = imagem;
      });

      await sendImageServer(imagemSelecionada!);
    }
  }

  Future<void> escolherImagemCamera() async {
    final ImagePicker seletorImagem = ImagePicker();
    final XFile? imagem = await seletorImagem.pickImage(
      source: ImageSource.camera, maxHeight: 600, // Exemplo de altura máxima
      maxWidth: 600,
    );

    if (imagem != null) {
      setState(() {
        imagemSelecionada = imagem;
      });

      await sendImageServer(imagemSelecionada!);
    }
  }

  sendImageRaichu(XFile file) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${raichu_url}/enviar-foto/'),
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
    return response;
  }

  Future<http.Response> sendImageServer(XFile file) async {
    try {
      final data = await sendImageRaichu(file);
      print(data);
    } catch (e) {
      showMessage('Erro', e.toString());
    }

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
    print("Response body: " + response.body);
    print("Response status code: ${res.statusCode}");

    showMessage('Texto', 'Extraido!');
    var responseData = json.decode(response.body);
    setState(() {
      textoExtraido = responseData['ocr_text'];
    });
    return response;
  }

  Future<void> obterTexto() async {
    var response = await dio_API.dio.get('$baseUrl/get-text/');
    if (response.statusCode == 200) {
      showMessage('Sucesso', 'Imagem enviada com sucesso!');

      setState(() {
        textoExtraido = response.data['extracted_text'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade300,
      appBar: AppBar(title: Text("OCR App + Backend Server")),
      body: ListView(
        children: [
          BotaoAcao(texto: 'Escolher Imagem', acao: escolherImagemGaleria),
          BotaoAcao(texto: ' Imagem Camera', acao: escolherImagemCamera),
          if (imagemSelecionada != null) CardImagem(),
          BotaoAcao(texto: 'Obter Texto', acao: obterTexto),
          CardTexto()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: obterTexto,
        child: Icon(Icons.textsms),
      ),
    );
  }

  Widget CardImagem() {
    return Column(
      children: [
        GestureDetector(
          child: CustomText(text: '${imagemSelecionada}'),
        ),
        Container(
          height: 600,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(imagemSelecionada!.path),
          ),
        )
      ],
    );
  }

  Widget BotaoAcao({required String texto, required VoidCallback acao}) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton(
        onPressed: acao,
        child: Text(texto),
      ),
    );
  }

  Widget CardTexto() {
    return Container(
      height: 600,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomText(text: textoExtraido),
      ),
    );
  }

  void showMessage(String texto1, String texto2) {
    // Adiciona Snackbar para notificar sucesso

    getX.Get.snackbar(texto1, texto2, snackPosition: getX.SnackPosition.TOP);
  }
}
