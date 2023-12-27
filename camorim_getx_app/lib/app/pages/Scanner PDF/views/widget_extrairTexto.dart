import 'dart:convert';
import 'dart:io';
import 'package:camorim_getx_app/app/pages/Scanner%20PDF/controller/servidor_dio_ocr.dart';
import 'package:camorim_getx_app/widgets/NavBarCustom.dart';
import 'package:camorim_getx_app/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getX;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class WidgetSelecionadorImagem extends StatefulWidget {
  @override
  _WidgetSelecionadorImagemState createState() =>
      _WidgetSelecionadorImagemState();
}

class _WidgetSelecionadorImagemState extends State<WidgetSelecionadorImagem> {
  XFile? imagemSelecionada;
  String textoExtraido = '';
  final String baseUrl = 'https://docker-raichu.onrender.com';
  final String raichu_url = 'https://raichu-server-web.onrender.com';
  final dio_API = ServidorOCR();
  bool isLoading = false; // Adicionado para gerenciar o estado de carregamento
  TextEditingController textEditingController = TextEditingController();
  TextEditingController dataText = TextEditingController();
  TextEditingController categoriaText = TextEditingController();

  @override
  void initState() {
    super.initState();
    getStatus();
  }

  getStatus() async {
    var response = await dio_API.dio.get('$baseUrl/');
    print('Testando o docker  ${response.data} ');
  }

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
      setState(() {
        textoExtraido = responseData['ocr_text'];
      });
      showMessage('OK', 'Imagem enviada com sucesso!');
    }
    return response;
  }

  Future<void> obterTexto() async {
    var response = await dio_API.dio.get('$baseUrl/get-text/');
    if (response.statusCode == 200) {
      showMessage('Texto', 'Extraido!');
      setState(() {
        textoExtraido = response.data['extracted_text'];
        textEditingController.text = textoExtraido;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade300,
      appBar: AppBar(title: const Text("OCR App + Backend Server")),
      body: ListView(
        children: [
          BotaoAcao(texto: 'Escolher Imagem', acao: escolherImagemGaleria),
          BotaoAcao(texto: ' Imagem Camera', acao: escolherImagemCamera),
          if (imagemSelecionada != null) CardImagem(),
          BotaoAcao(texto: 'Obter Texto', acao: obterTexto),
          //CardTexto(),

          Column(
            children: [
              cardTextoEditavel('Total', textEditingController),
              cardTextoEditavel("Data", dataText),
              cardTextoEditavel("Categoria", categoriaText)
            ],
          ),

          BotaoAcao(
              texto: "Salvar Excel",
              acao: () {
                String dataFormatada =
                    DateFormat('dd/MM/yyyy').format(DateTime.now());
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: obterTexto,
        child: const Icon(Icons.textsms),
      ),
      bottomNavigationBar: CustomNavBar(
        navBarItems: [
          NavigationBarItem(
              label: 'OCR',
              iconData: Icons.date_range_outlined,
              onPress: () {
                // Get.to(CalendarioWidget());
              }),
          NavigationBarItem(
              label: 'OS DIGITAL',
              iconData: Icons.search,
              onPress: () {
                // getX.Get.to();
              }),
        ],
      ),
    );
  }

  Widget CardImagem() {
    return Column(
      children: [
        GestureDetector(
          child: CustomText(text: imagemSelecionada!.path),
        ),
        Container(
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(imagemSelecionada!.path),
          ),
        )
      ],
    );
  }

  Widget BotaoAcao(
      {required String texto,
      required VoidCallback acao,
      MaterialStateProperty<Color?>? cor}) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: ElevatedButton(
        style: ButtonStyle(backgroundColor: cor),
        onPressed: acao,
        child: Text(texto),
      ),
    );
  }

  Widget cardTextoEditavel(
      String labelText, TextEditingController _controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Digite algo aqui...',
          border: OutlineInputBorder(),
          label: Text(
            labelText,
            style: const TextStyle(
              color: Colors.purple,
            ),
          ),
        ),
        maxLines: null, // Permite múltiplas linhas
        keyboardType: TextInputType.multiline,
      ),
    );
  }

  Widget CardTexto() {
    return Container(
      height: 400,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomText(text: textoExtraido),
      ),
    );
  }

  void showMessage(String texto1, String texto2) {
    getX.Get.snackbar(texto1, texto2, snackPosition: getX.SnackPosition.TOP);
  }
}
